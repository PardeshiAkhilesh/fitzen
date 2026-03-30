from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime, date
from math import ceil

from weight_service.schemas import WeightLogCreate, WeightLogResponse, WeightHistoryResponse
from database.models.weight_log import WeightLog
from auth_service.dependencies import get_current_user

router = APIRouter(prefix="/weight", tags=["Weight"])


@router.post("/log", response_model=WeightLogResponse, status_code=201)
def log_weight(
    payload: WeightLogCreate,
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    entry = WeightLog(
        user_id=current_user.id,
        weight_kg=payload.weight_kg,
        logged_at=payload.logged_at or datetime.utcnow()
    )
    db.add(entry)
    db.commit()
    db.refresh(entry)
    return entry


@router.put("/log/{log_id}", response_model=WeightLogResponse)
def update_weight_log(
    log_id: int,
    payload: WeightLogCreate,
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    entry = db.query(WeightLog).filter_by(id=log_id, user_id=current_user.id).first()
    if not entry:
        raise HTTPException(404, "Weight log not found")

    entry.weight_kg = payload.weight_kg
    if payload.logged_at:
        entry.logged_at = payload.logged_at
    db.commit()
    db.refresh(entry)
    return entry


@router.delete("/log/{log_id}", status_code=204)
def delete_weight_log(
    log_id: int,
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    entry = db.query(WeightLog).filter_by(id=log_id, user_id=current_user.id).first()
    if not entry:
        raise HTTPException(404, "Weight log not found")

    db.delete(entry)
    db.commit()


@router.get("/history", response_model=WeightHistoryResponse)
def get_weight_history(
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    logs = (
        db.query(WeightLog)
        .filter_by(user_id=current_user.id)
        .order_by(WeightLog.logged_at.asc())
        .all()
    )
    return {"history": logs}


@router.get("/summary")
def get_weight_summary(
    request: Request,
    current_user=Depends(get_current_user)
):
    """Returns weight progress summary for the home screen graph."""
    db: Session = request.state.db

    from database.models.user_profile_setup import UserProfile
    from database.models.user_goal_setup import UserGoal

    profile = db.query(UserProfile).filter_by(user_id=current_user.id).first()
    goal = db.query(UserGoal).filter_by(user_id=current_user.id).first()

    start_weight = profile.weight_kg if profile else None
    target_weight = goal.target_weight if goal else None
    weekly_pace = goal.weekly_goal_kg if goal else 0.5

    logs = (
        db.query(WeightLog)
        .filter_by(user_id=current_user.id)
        .order_by(WeightLog.logged_at.asc())
        .all()
    )

    current_weight = logs[-1].weight_kg if logs else start_weight
    history = [{"date": l.logged_at.strftime("%d %b"), "weight": l.weight_kg} for l in logs]

    # Calculate remaining and estimated date
    days_remaining = None
    estimated_date = None
    kg_remaining = None
    if current_weight is not None and target_weight is not None and weekly_pace and weekly_pace > 0:
        kg_remaining = round(abs(current_weight - target_weight), 2)
        weeks_needed = kg_remaining / weekly_pace
        days_remaining = ceil(weeks_needed * 7)
        estimated_date = (date.today().__class__.fromordinal(
            date.today().toordinal() + days_remaining
        )).strftime("%d %b %Y")

    return {
        "start_weight": start_weight,
        "current_weight": current_weight,
        "target_weight": target_weight,
        "weekly_pace_kg": weekly_pace,
        "kg_remaining": kg_remaining,
        "days_remaining": days_remaining,
        "estimated_date": estimated_date,
        "history": history,
    }
