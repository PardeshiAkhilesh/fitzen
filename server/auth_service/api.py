"""
Authentication API routes mapping hybrid auth requirements.
Handles manual login/register endpoints and /me user retrival.
"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from . import schemas, service
from .dependencies import get_current_user
from . import models
from database.database import get_db

router = APIRouter()

@router.post("/register", response_model=schemas.TokenResponse, status_code=status.HTTP_201_CREATED)
def register(data: schemas.RegisterRequest, db: Session = Depends(get_db)):
    """Register a new user via local authentication."""
    return service.register_user(db, data)

@router.post("/login", response_model=schemas.TokenResponse)
def login(data: schemas.LoginRequest, db: Session = Depends(get_db)):
    """Login manually via local authentication."""
    return service.login_user(db, data)

@router.post("/logout")
def logout():
    """Sign-out logic is managed purely client-side by destroying the local JWT."""
    return {"message": "Logged out successfully."}

@router.get("/me", response_model=schemas.UserResponse)
def get_current_user_profile(current_user: models.User = Depends(get_current_user)):
    """Get current authenticated user mapping."""
    return current_user