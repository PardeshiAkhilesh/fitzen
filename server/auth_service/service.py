"""
Authentication service handling local auth manual flow.
"""
from fastapi import HTTPException, status
from sqlalchemy.orm import Session
from . import models, schemas
from .security import hash_password, verify_password, create_access_token

def register_user(db: Session, data: schemas.RegisterRequest):
    if data.password != data.confirm_password:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Passwords do not match")

    existing_user = db.query(models.User).filter(models.User.email == data.email).first()
    if existing_user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already registered")

    user = models.User(
        email=data.email,
        full_name=data.full_name,
        hashed_password=hash_password(data.password),
        provider="local",
        is_active=True
    )

    try:
        db.add(user)
        db.commit()
        db.refresh(user)
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to create user")

    access_token = create_access_token({
        "sub": str(user.id),
        "email": user.email
    })
    return {"access_token": access_token, "token_type": "bearer", "refresh_token": None}

def login_user(db: Session, data: schemas.LoginRequest):
    user = db.query(models.User).filter(models.User.email == data.email).first()

    if not user or not user.hashed_password:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")

    if not user.is_active:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="User account is inactive")

    if not verify_password(data.password, user.hashed_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")

    access_token = create_access_token({
        "sub": str(user.id),
        "email": user.email
    })
    return {"access_token": access_token, "token_type": "bearer", "refresh_token": None}
