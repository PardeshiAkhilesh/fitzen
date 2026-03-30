from pydantic import BaseModel, Field, field_serializer, ConfigDict
from datetime import date
from typing import Optional

class GoalCreate(BaseModel):
    target_weight: float = Field(..., gt=0)
    weekly_goal_kg: float = Field(..., description="0.25, 0.5, 0.75 or 1")
    target_calories: int = Field(..., gt=0, description="Daily calorie target")
    goal_type: str = Field(default="lose", description="lose, gain, or maintain")
    protein_g: Optional[int] = None
    carbs_g: Optional[int] = None
    fat_g: Optional[int] = None
    target_burn_calories: Optional[int] = Field(default=0, ge=0)


class GoalResponse(BaseModel):
    model_config = ConfigDict(populate_by_name=True, by_alias=False)

    daily_calories: int
    protein_g: int
    carbs_g: int
    fat_g: int
    target_date: date
    target_weight: float
    weekly_goal_kg: float
    goal_type: str = "lose"
    target_burn_calories: int = 0

    @field_serializer('target_date')
    def serialize_target_date(self, value: date) -> str:
        return value.strftime("%d-%m-%Y")
