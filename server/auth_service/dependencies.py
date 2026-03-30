"""
Dependency injection functions for hybrid authentication.
Validates Local JWTs and Supabase JWKS tokens.
"""
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session

from .security import decode_access_token
from . import models
from database.database import get_db

security = HTTPBearer()

def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> models.User:
    if not credentials or not credentials.credentials:
        print("get_current_user: Authorization token missing")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token missing",
            headers={"WWW-Authenticate": "Bearer"},
        )
        
    token = credentials.credentials
    payload = decode_access_token(token)
    
    if not payload:
        print("get_current_user: token decoding returned None")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # Support BOTH token formats (Supabase OAuth & existing manual tokens)
    email = payload.get("email")
    if not email:
        email = payload.get("sub")

    print(f"get_current_user: Decoded Payload: {payload}")

    if not email:
        print("get_current_user: payload missing email and sub")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Valid token missing identity claims",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # If the fallback identity is a numeric ID (old local tokens), query by ID
    if str(email).isdigit():
        user = db.query(models.User).filter(models.User.id == int(email)).first()
    else:
        user = db.query(models.User).filter(models.User.email == email).first()

    if not user:
        # Check if this could be an old local token looking for a user not found
        if str(email).isdigit():
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Local user not found")

        # Auto-create backend mapping for new Supabase sign-ins
        user_metadata = payload.get("user_metadata", {})
        full_name = user_metadata.get("full_name", email.split('@')[0])
        
        user = models.User(
            email=email,
            full_name=full_name,
            provider="supabase",
            is_active=True
        )
        try:
            db.add(user)
            db.commit()
            db.refresh(user)
        except Exception as e:
            db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to auto-create backend user: {str(e)}",
            )

    if not user.is_active:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="User account inactive")

    return user