from sqlalchemy import Column, String, Boolean, DateTime
from sqlalchemy.sql import func
from database.database import Base


class GymAccessCode(Base):
    __tablename__ = "gym_access_codes"

    code = Column(String(50), primary_key=True)
    gym_name = Column(String(200), nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, server_default=func.now())
