"""
SQLAlchemy ORM models for authentication system.
Defines User table.
"""
from sqlalchemy import Column, Integer, String, Boolean, DateTime, func

from database.database import Base


class User(Base):
    """User model for authentication."""
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, nullable=False, index=True)
    full_name = Column(String(255), nullable=True) # Full name from Google/Supabase can be nullable initially
    hashed_password = Column(
        String(500),
        nullable=True,
        comment="Obsolete. Only kept for backwards compatibility."
    )
    provider = Column(
        String(50),
        nullable=False,
        default="supabase",
        index=True,
        comment="Authentication provider: 'local', 'google', or 'supabase'"
    )
    is_active = Column(Boolean, default=True, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now()
    )

    def __repr__(self):
        return f"<User(id={self.id}, email={self.email}, provider={self.provider})>"