from fastapi import APIRouter, Request, HTTPException, Depends
from sqlalchemy.orm import Session
from typing import List
from pydantic import BaseModel

from auth_service.dependencies import get_current_user
from .models import WorkoutPlan, WorkoutPlanExercise
from .completion_models import WorkoutDayCompletion
from .schemas import WorkoutDayResponse, UpdateDayRequest, WorkoutDayWithStatusResponse, DayCompletionRequest

router = APIRouter(prefix="/workout-plan", tags=["Workout Plan"])

DEFAULT_PLAN = [
    {
        "day_label": "Day 1", "title": "Chest & Triceps",
        "exercises": [
            {"name": "Bench Press", "sets": "4", "reps": "8-10"},
            {"name": "Incline Dumbbell Press", "sets": "3", "reps": "10-12"},
            {"name": "Cable Flyes", "sets": "3", "reps": "12-15"},
            {"name": "Tricep Pushdown", "sets": "3", "reps": "12"},
            {"name": "Overhead Extension", "sets": "3", "reps": "12"},
        ],
    },
    {
        "day_label": "Day 2", "title": "Back & Biceps",
        "exercises": [
            {"name": "Deadlift", "sets": "4", "reps": "6-8"},
            {"name": "Lat Pulldown", "sets": "3", "reps": "10-12"},
            {"name": "Seated Row", "sets": "3", "reps": "10-12"},
            {"name": "Barbell Curl", "sets": "3", "reps": "10"},
            {"name": "Hammer Curl", "sets": "3", "reps": "12"},
        ],
    },
    {
        "day_label": "Day 3", "title": "Legs",
        "exercises": [
            {"name": "Squats", "sets": "4", "reps": "8-10"},
            {"name": "Leg Press", "sets": "3", "reps": "10-12"},
            {"name": "Leg Curl", "sets": "3", "reps": "12"},
            {"name": "Leg Extension", "sets": "3", "reps": "12"},
            {"name": "Calf Raises", "sets": "4", "reps": "15"},
        ],
    },
    {
        "day_label": "Day 4", "title": "Shoulders & Abs",
        "exercises": [
            {"name": "Overhead Press", "sets": "4", "reps": "8-10"},
            {"name": "Lateral Raises", "sets": "3", "reps": "12-15"},
            {"name": "Front Raises", "sets": "3", "reps": "12"},
            {"name": "Hanging Leg Raises", "sets": "3", "reps": "15"},
            {"name": "Plank", "sets": "3", "reps": "60s"},
        ],
    },
    {
        "day_label": "Day 5", "title": "Upper Body",
        "exercises": [
            {"name": "Pull-ups", "sets": "4", "reps": "8-10"},
            {"name": "Dips", "sets": "3", "reps": "10-12"},
            {"name": "Dumbbell Rows", "sets": "3", "reps": "10"},
            {"name": "Chest Flyes", "sets": "3", "reps": "12"},
            {"name": "Face Pulls", "sets": "3", "reps": "15"},
        ],
    },
    {
        "day_label": "Day 6", "title": "Lower Body",
        "exercises": [
            {"name": "Romanian Deadlift", "sets": "4", "reps": "8-10"},
            {"name": "Bulgarian Split Squats", "sets": "3", "reps": "10"},
            {"name": "Hip Thrusts", "sets": "3", "reps": "12"},
            {"name": "Seated Calf Raises", "sets": "4", "reps": "15"},
            {"name": "Ab Rollouts", "sets": "3", "reps": "12"},
        ],
    },
]


def _seed_default_plan(db: Session, user_id: int):
    for i, day in enumerate(DEFAULT_PLAN, start=1):
        plan = WorkoutPlan(
            user_id=user_id,
            day_number=i,
            day_label=day["day_label"],
            title=day["title"],
        )
        db.add(plan)
        db.flush()
        for j, ex in enumerate(day["exercises"]):
            db.add(WorkoutPlanExercise(
                plan_id=plan.id,
                order_index=j,
                name=ex["name"],
                sets=ex["sets"],
                reps=ex["reps"],
            ))
    db.commit()


@router.get("/", response_model=List[WorkoutDayWithStatusResponse])
def get_workout_plan(
    request: Request,
    current_user=Depends(get_current_user),
):
    db: Session = request.state.db
    plans = (
        db.query(WorkoutPlan)
        .filter_by(user_id=current_user.id)
        .order_by(WorkoutPlan.day_number)
        .all()
    )
    if not plans:
        _seed_default_plan(db, current_user.id)
        plans = (
            db.query(WorkoutPlan)
            .filter_by(user_id=current_user.id)
            .order_by(WorkoutPlan.day_number)
            .all()
        )

    completed_ids = set(
        row.plan_id for row in
        db.query(WorkoutDayCompletion).filter_by(user_id=current_user.id).all()
    )

    result = []
    for i, plan in enumerate(plans):
        is_completed = plan.id in completed_ids
        # Day 1 is always unlocked; every other day requires the previous day to be completed
        if i == 0:
            is_unlocked = True
        else:
            is_unlocked = plans[i - 1].id in completed_ids
        result.append(WorkoutDayWithStatusResponse(
            **WorkoutDayResponse.model_validate(plan).model_dump(),
            is_completed=is_completed,
            is_unlocked=is_unlocked,
        ))
    return result


@router.post("/complete-day")
def complete_day(
    payload: DayCompletionRequest,
    request: Request,
    current_user=Depends(get_current_user),
):
    from datetime import date
    db: Session = request.state.db

    plan = db.query(WorkoutPlan).filter_by(id=payload.plan_id, user_id=current_user.id).first()
    if not plan:
        raise HTTPException(status_code=404, detail="Workout day not found")

    existing = db.query(WorkoutDayCompletion).filter_by(
        user_id=current_user.id, plan_id=payload.plan_id
    ).first()
    if not existing:
        db.add(WorkoutDayCompletion(
            user_id=current_user.id,
            plan_id=payload.plan_id,
            completed_on=date.today(),
        ))
        db.commit()

    return {"success": True, "plan_id": payload.plan_id}


@router.put("/{plan_id}", response_model=WorkoutDayWithStatusResponse)
def update_workout_day(
    plan_id: int,
    payload: UpdateDayRequest,
    request: Request,
    current_user=Depends(get_current_user),
):
    db: Session = request.state.db
    plan = db.query(WorkoutPlan).filter_by(id=plan_id, user_id=current_user.id).first()
    if not plan:
        raise HTTPException(404, "Workout day not found")

    plan.title = payload.title

    # Replace all exercises
    db.query(WorkoutPlanExercise).filter_by(plan_id=plan.id).delete()
    for i, ex in enumerate(payload.exercises):
        db.add(WorkoutPlanExercise(
            plan_id=plan.id,
            order_index=i,
            name=ex.name,
            sets=ex.sets,
            reps=ex.reps,
        ))
    db.commit()
    db.refresh(plan)

    all_plans = db.query(WorkoutPlan).filter_by(user_id=current_user.id).order_by(WorkoutPlan.day_number).all()
    completed_ids = set(row.plan_id for row in db.query(WorkoutDayCompletion).filter_by(user_id=current_user.id).all())

    is_completed = plan.id in completed_ids
    idx = next((i for i, p in enumerate(all_plans) if p.id == plan.id), 0)
    is_unlocked = True if idx == 0 else (all_plans[idx - 1].id in completed_ids)

    return WorkoutDayWithStatusResponse(
        **WorkoutDayResponse.model_validate(plan).model_dump(),
        is_completed=is_completed,
        is_unlocked=is_unlocked,
    )


@router.post("/reset", response_model=List[WorkoutDayWithStatusResponse])
def reset_workout_plan(
    request: Request,
    current_user=Depends(get_current_user),
):
    """Delete user's custom plan and re-seed the default."""
    db: Session = request.state.db
    plans = db.query(WorkoutPlan).filter_by(user_id=current_user.id).all()
    for p in plans:
        db.delete(p)
    db.query(WorkoutDayCompletion).filter_by(user_id=current_user.id).delete()
    db.commit()
    _seed_default_plan(db, current_user.id)
    plans = (
        db.query(WorkoutPlan)
        .filter_by(user_id=current_user.id)
        .order_by(WorkoutPlan.day_number)
        .all()
    )
    result = []
    for i, plan in enumerate(plans):
        result.append(WorkoutDayWithStatusResponse(
            **WorkoutDayResponse.model_validate(plan).model_dump(),
            is_completed=False,
            is_unlocked=(i == 0),
        ))
    return result


class CompletedExercise(BaseModel):
    name: str
    sets: int
    reps: str


class CalculateBurnRequest(BaseModel):
    day_title: str
    exercises: List[CompletedExercise]


@router.post("/calculate-burn")
def calculate_burn(
    payload: CalculateBurnRequest,
    request: Request,
    current_user=Depends(get_current_user),
):
    """LLM estimates calories burned for a completed workout session and updates daily nutrition."""
    import json
    from llm_service.llm_client import get_llm
    from llm_service.prompts.workout_burn_calculator import WORKOUT_BURN_PROMPT
    from food_or_workout_log_service.models import DailyNutrition
    from food_or_workout_log_service.service import get_or_create_daily_nutrition
    from datetime import date

    db: Session = request.state.db

    # Build workout summary string for LLM
    lines = [f"Day: {payload.day_title}"]
    for ex in payload.exercises:
        lines.append(f"- {ex.name}: {ex.sets} sets x {ex.reps} reps")
    workout_summary = "\n".join(lines)

    # Call LLM
    llm = get_llm()
    response = llm.invoke(WORKOUT_BURN_PROMPT.format(workout_summary=workout_summary))
    raw = response.content.strip().replace("```json", "").replace("```", "").strip()

    try:
        result = json.loads(raw)
    except Exception:
        result = {"total_calories": 0, "summary": payload.day_title, "breakdown": []}

    total_calories = result.get("total_calories", 0)
    if not isinstance(total_calories, (int, float)):
        total_calories = 0

    # Update daily nutrition burned_calories only — independent of food calories
    today = date.today()
    daily = get_or_create_daily_nutrition(db, current_user.id, today)
    daily.burned_calories += total_calories
    db.commit()

    return {
        "total_calories": int(total_calories),
        "summary": result.get("summary", payload.day_title),
        "breakdown": result.get("breakdown", []),
    }
