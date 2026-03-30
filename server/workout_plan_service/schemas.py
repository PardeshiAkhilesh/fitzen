from pydantic import BaseModel
from typing import List


class ExerciseSchema(BaseModel):
    name: str
    sets: str
    reps: str


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
