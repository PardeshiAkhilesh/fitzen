from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import date
from pydantic import BaseModel
from typing import Union

from database.database import get_db
from auth_service.dependencies import get_current_user
from .schemas import LLMLogRequest, DailyNutritionResponse
from .service import process_llm_log, get_or_create_daily_nutrition
from .models import DailyNutrition
from llm_service.service import process_user_input

router = APIRouter(prefix="/food-or-workout", tags=["Food/Workout Log"])


class SimpleLogRequest(BaseModel):
    input: str


@router.post("/log", response_model=DailyNutritionResponse)
def log_food_or_exercise(
    data: Union[SimpleLogRequest, LLMLogRequest],
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    # Handle both simple text input and full LLMLogRequest
    if isinstance(data, SimpleLogRequest) or (hasattr(data, 'input') and not hasattr(data, 'intent')):
        # Process simple text input through LLM
        text_input = data.input if hasattr(data, 'input') else data.dict().get('input', '')
        llm_result = process_user_input(text_input)
        log_data = llm_result
    else:
        # Use full LLMLogRequest data
        log_data = data.dict()
    
    daily = process_llm_log(db, current_user.id, log_data)

    return DailyNutritionResponse(
        date=daily.date,
        consumed_calories=daily.consumed_calories,
        consumed_protein=daily.consumed_protein,
        consumed_carbs=daily.consumed_carbs,
        consumed_fat=daily.consumed_fat,
        burned_calories=daily.burned_calories,
        remaining_calories=daily.remaining_calories,
        remaining_protein=daily.remaining_protein,
        remaining_carbs=daily.remaining_carbs,
        remaining_fat=daily.remaining_fat,
    )


@router.get("/today", response_model=DailyNutritionResponse)
def get_today_summary(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    today = date.today()

    daily = db.query(DailyNutrition).filter_by(user_id=current_user.id, date=today).first()

    if not daily:
        daily = get_or_create_daily_nutrition(db, current_user.id, today)

    return DailyNutritionResponse(
        date=daily.date,
        consumed_calories=daily.consumed_calories,
        consumed_protein=daily.consumed_protein,
        consumed_carbs=daily.consumed_carbs,
        consumed_fat=daily.consumed_fat,
        burned_calories=daily.burned_calories,
        remaining_calories=daily.remaining_calories,
        remaining_protein=daily.remaining_protein,
        remaining_carbs=daily.remaining_carbs,
        remaining_fat=daily.remaining_fat,
    )


@router.get("/logs/today")
def get_today_logs(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    from sqlalchemy import text
    import datetime

    today_str = datetime.date.today().isoformat()
    # Also accept logs from last 24h to handle UTC vs IST offset
    since = (datetime.datetime.utcnow() - datetime.timedelta(hours=24)).strftime('%Y-%m-%d %H:%M:%S')

    rows = db.execute(
        text("""
            SELECT name, calories_kcal, protein_g, carbs_g, fat_g,
                   logged_at, type, raw_input
            FROM food_logs
            WHERE user_id = :uid
              AND (
                log_date = :today
                OR logged_at >= :since
              )
            ORDER BY logged_at DESC
        """),
        {"uid": current_user.id, "today": today_str, "since": since}
    ).fetchall()

    return [
        {
            "id": idx,
            "name": r.name or r.raw_input,
            "calories": r.calories_kcal,
            "protein": r.protein_g,
            "carbs": r.carbs_g,
            "fat": r.fat_g,
            "time": str(r.logged_at)[11:16] if r.logged_at else "",
            "type": "food" if "food" in str(r.type) else "workout",
        }
        for idx, r in enumerate(rows)
    ]


class BurnedCaloriesUpdate(BaseModel):
    burned_calories: float


@router.put("/burned")
def update_burned_calories(
    payload: BurnedCaloriesUpdate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    """Manually override today's burned calories."""
    today = date.today()
    daily = db.query(DailyNutrition).filter_by(user_id=current_user.id, date=today).first()
    if not daily:
        daily = get_or_create_daily_nutrition(db, current_user.id, today)

    diff = payload.burned_calories - daily.burned_calories
    daily.burned_calories = payload.burned_calories
    daily.remaining_calories = max(0, daily.remaining_calories + diff)
    db.commit()
    db.refresh(daily)
    return {
        "burned_calories": daily.burned_calories,
        "remaining_calories": daily.remaining_calories,
    }