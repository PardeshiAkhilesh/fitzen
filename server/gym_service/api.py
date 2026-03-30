from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
from database.database import get_db
from .models import GymAccessCode

router = APIRouter(prefix="/gym", tags=["Gym"])


class VerifyCodeRequest(BaseModel):
    code: str


@router.post("/verify")
def verify_access_code(payload: VerifyCodeRequest, db: Session = Depends(get_db)):
    entry = db.query(GymAccessCode).filter_by(code=payload.code.strip(), is_active=True).first()
    if not entry:
        raise HTTPException(status_code=403, detail="Invalid or inactive access code")
    return {"valid": True, "gym_name": entry.gym_name}
