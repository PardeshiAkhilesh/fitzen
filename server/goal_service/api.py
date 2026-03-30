from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.orm import Session

from goal_service.schemas import GoalCreate, GoalResponse
from goal_service.calculator import calculate_goal
from database.models.user_goal_setup import UserGoal
from database.models.user_profile_setup import UserProfile
from auth_service.dependencies import get_current_user

router = APIRouter(prefix="/goals", tags=["Goals"])


def _apply_goal(existing: UserGoal, payload: GoalCreate, result: dict, protein_g, carbs_g, fat_g):
    existing.target_weight = payload.target_weight
    existing.weekly_goal_kg = payload.weekly_goal_kg
    existing.goal_type = payload.goal_type
    existing.daily_calories = payload.target_calories
    existing.protein_g = protein_g
    existing.carbs_g = carbs_g
    existing.fat_g = fat_g
    existing.target_date = result["target_date"]
    existing.target_burn_calories = payload.target_burn_calories or 0


@router.post("/set", response_model=GoalResponse, status_code=201)
def set_goal(
    payload: GoalCreate,
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    profile = db.query(UserProfile).filter_by(user_id=current_user.id).first()
    if not profile:
        raise HTTPException(400, "Complete profile first")

    if db.query(UserGoal).filter_by(user_id=current_user.id).first():
        raise HTTPException(400, "Goal already exists. Use PUT /goals/me to update.")

    result = calculate_goal(profile, payload.target_weight, payload.weekly_goal_kg,
                            target_calories=payload.target_calories, goal_type=payload.goal_type)

    protein_g = payload.protein_g if payload.protein_g is not None else result["protein_g"]
    carbs_g = payload.carbs_g if payload.carbs_g is not None else result["carbs_g"]
    fat_g = payload.fat_g if payload.fat_g is not None else result["fat_g"]

    goal = UserGoal(
        user_id=current_user.id,
        target_weight=payload.target_weight,
        weekly_goal_kg=payload.weekly_goal_kg,
        goal_type=payload.goal_type,
        daily_calories=payload.target_calories,
        protein_g=protein_g,
        carbs_g=carbs_g,
        fat_g=fat_g,
        target_date=result["target_date"],
        target_burn_calories=payload.target_burn_calories or 0,
    )
    db.add(goal)
    db.commit()
    db.refresh(goal)
    return goal


@router.put("/me", response_model=GoalResponse)
def update_goal(
    payload: GoalCreate,
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    profile = db.query(UserProfile).filter_by(user_id=current_user.id).first()
    if not profile:
        raise HTTPException(400, "Complete profile first")

    goal = db.query(UserGoal).filter_by(user_id=current_user.id).first()
    if not goal:
        raise HTTPException(404, "Goal not found. Use POST /goals/set first.")

    result = calculate_goal(profile, payload.target_weight, payload.weekly_goal_kg,
                            target_calories=payload.target_calories, goal_type=payload.goal_type)

    protein_g = payload.protein_g if payload.protein_g is not None else result["protein_g"]
    carbs_g = payload.carbs_g if payload.carbs_g is not None else result["carbs_g"]
    fat_g = payload.fat_g if payload.fat_g is not None else result["fat_g"]

    _apply_goal(goal, payload, result, protein_g, carbs_g, fat_g)
    db.commit()
    db.refresh(goal)
    return goal


@router.get("/me", response_model=GoalResponse)
def get_my_goal(
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    goal = db.query(UserGoal).filter_by(user_id=current_user.id).first()
    if not goal:
        raise HTTPException(404, "Goal not found")

    return goal
