from sqlalchemy import Column, Integer, ForeignKey, Date, Boolean
from sqlalchemy.sql import func
from sqlalchemy import DateTime
from database.database import Base

class WorkoutDayCompletion(Base):
    __tablename__ = "workout_day_completions"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    plan_id = Column(Integer, ForeignKey("workout_plans.id", ondelete="CASCADE"), nullable=False)
    completed_on = Column(Date, nullable=False)
    created_at = Column(DateTime, server_default=func.now())
