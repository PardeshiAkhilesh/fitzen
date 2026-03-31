from pydantic import BaseModel
from typing import List, Optional


class ExerciseSchema(BaseModel):
    name: str
    sets: str
    reps: str

    model_config = {"from_attributes": True}


class WorkoutDayResponse(BaseModel):
    id: int
    day_number: int
    day_label: str
    title: str
    exercises: List[ExerciseSchema]

    model_config = {"from_attributes": True}


class UpdateDayRequest(BaseModel):
    title: str
    exercises: List[ExerciseSchema]


class CompletionStatusResponse(BaseModel):
    plan_id: int
    completed: bool
    completed_on: Optional[str] = None


class DayCompletionRequest(BaseModel):
    plan_id: int


class WorkoutDayWithStatusResponse(WorkoutDayResponse):
    is_completed: bool
    is_unlocked: bool
