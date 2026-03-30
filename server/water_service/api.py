from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.orm import Session
from datetime import date

from water_service.schemas import WaterGoalCreate, WaterStatusResponse
from water_service.utils import liters_to_glasses
from database.models.water_goal import WaterGoal
from database.models.water_log import WaterLog
from auth_service.dependencies import get_current_user

router = APIRouter(prefix="/water", tags=["Water"])


@router.post("/goal", status_code=201)
def create_water_goal(
    payload: WaterGoalCreate,
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    if db.query(WaterGoal).filter_by(user_id=current_user.id).first():
        raise HTTPException(400, "Water goal already exists. Use PUT /water/goal to update.")

    glass_size = 250
    goal = WaterGoal(
        user_id=current_user.id,
        target_liters=payload.target_liters,
        glass_size_ml=glass_size,
        target_glasses=liters_to_glasses(payload.target_liters, glass_size)
    )
    db.add(goal)
    db.commit()

    return {"target_liters": payload.target_liters, "target_glasses": goal.target_glasses}


@router.put("/goal")
def update_water_goal(
    payload: WaterGoalCreate,
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    goal = db.query(WaterGoal).filter_by(user_id=current_user.id).first()
    if not goal:
        raise HTTPException(404, "Water goal not found. Use POST /water/goal first.")

    glass_size = 250
    goal.target_liters = payload.target_liters
    goal.target_glasses = liters_to_glasses(payload.target_liters, glass_size)
    db.commit()

    return {"target_liters": payload.target_liters, "target_glasses": goal.target_glasses}


@router.post("/add-glass")
def add_glass(
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db
    today = date.today()

    log = db.query(WaterLog).filter_by(user_id=current_user.id, date=today).first()
    if not log:
        log = WaterLog(user_id=current_user.id, date=today, glasses_consumed=1)
        db.add(log)
    else:
        log.glasses_consumed += 1

    db.commit()
    return {"message": "Glass added", "glasses_consumed": log.glasses_consumed}


@router.get("/today", response_model=WaterStatusResponse)
def get_today_status(
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db
    today = date.today()

    goal = db.query(WaterGoal).filter_by(user_id=current_user.id).first()
    if not goal:
        raise HTTPException(400, "Set water goal first")

    log = db.query(WaterLog).filter_by(user_id=current_user.id, date=today).first()
    consumed = log.glasses_consumed if log else 0
    remaining = max(goal.target_glasses - consumed, 0)
    percentage = round((consumed / goal.target_glasses) * 100, 2) if goal.target_glasses else 0

    return WaterStatusResponse(
        target_glasses=goal.target_glasses,
        consumed_glasses=consumed,
        remaining_glasses=remaining,
        percentage=percentage
    )
