from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session

from profile_service.schemas import ProfileCreate, ProfileResponse
from database.models.user_profile_setup import UserProfile
from auth_service.dependencies import get_current_user
from goal_service.calculator import calculate_bmr, ACTIVITY_FACTORS

router = APIRouter(prefix="/profile", tags=["Profile"])


def _calc_recommended(weight, height, age, gender, activity_level):
    try:
        bmr = calculate_bmr(weight, height, age, gender)
        multiplier = ACTIVITY_FACTORS.get(activity_level, 1.2)
        return max(1000, int(round(bmr * multiplier)))
    except Exception:
        return 0


@router.post("/setup", response_model=ProfileResponse, status_code=201)
def setup_profile(
    payload: ProfileCreate,
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    existing = db.query(UserProfile).filter_by(user_id=current_user.id).first()
    if existing:
        raise HTTPException(400, "Profile already exists. Use PUT /profile/me to update.")

    profile = UserProfile(user_id=current_user.id, **payload.dict())
    db.add(profile)
    db.commit()

    return {
        "user_id": current_user.id,
        **payload.dict(),
        "recommended_calories": _calc_recommended(
            payload.weight_kg, payload.height_cm, payload.age, payload.gender, payload.activity_level
        ),
    }


@router.put("/me", response_model=ProfileResponse)
def update_profile(
    payload: ProfileCreate,
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    profile = db.query(UserProfile).filter_by(user_id=current_user.id).first()
    if not profile:
        raise HTTPException(404, "Profile not found. Use POST /profile/setup first.")

    profile.age = payload.age
    profile.height_cm = payload.height_cm
    profile.weight_kg = payload.weight_kg
    profile.gender = payload.gender
    profile.activity_level = payload.activity_level
    db.commit()

    return {
        "user_id": current_user.id,
        **payload.dict(),
        "recommended_calories": _calc_recommended(
            payload.weight_kg, payload.height_cm, payload.age, payload.gender, payload.activity_level
        ),
    }


@router.get("/me", response_model=ProfileResponse)
def get_my_profile(
    request: Request,
    current_user=Depends(get_current_user)
):
    db: Session = request.state.db

    profile = db.query(UserProfile).filter_by(user_id=current_user.id).first()
    if not profile:
        raise HTTPException(404, "Profile not found")

    return {
        "user_id": profile.user_id,
        "age": profile.age,
        "height_cm": profile.height_cm,
        "weight_kg": profile.weight_kg,
        "gender": profile.gender,
        "activity_level": profile.activity_level,
        "recommended_calories": _calc_recommended(
            profile.weight_kg, profile.height_cm, profile.age, profile.gender, profile.activity_level
        ),
    }
