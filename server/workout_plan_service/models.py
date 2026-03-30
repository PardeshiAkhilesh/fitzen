from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from database.database import Base


class WorkoutPlan(Base):
    __tablename__ = "workout_plans"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    day_number = Column(Integer, nullable=False)   # 1-based: 1..N
    day_label = Column(String(20), nullable=False)  # e.g. "Day 1"
    title = Column(String(100), nullable=False)     # e.g. "Chest & Triceps"
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    exercises = relationship(
        "WorkoutPlanExercise",
        back_populates="plan",
        cascade="all, delete-orphan",
        order_by="WorkoutPlanExercise.order_index",
    )


class WorkoutPlanExercise(Base):
    __tablename__ = "workout_plan_exercises"

    id = Column(Integer, primary_key=True, autoincrement=True)
    plan_id = Column(Integer, ForeignKey("workout_plans.id", ondelete="CASCADE"), nullable=False)
    order_index = Column(Integer, nullable=False, default=0)
    name = Column(String(150), nullable=False)
    sets = Column(String(10), nullable=False)   # stored as string e.g. "4"
    reps = Column(String(20), nullable=False)   # stored as string e.g. "8-10"

    plan = relationship("WorkoutPlan", back_populates="exercises")
