from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class WeightLogCreate(BaseModel):
    weight_kg: float = Field(..., gt=0)
    logged_at: Optional[datetime] = None


class WeightLogResponse(BaseModel):
    id: int
    weight_kg: float
    logged_at: datetime

    class Config:
        from_attributes = True


class WeightHistoryResponse(BaseModel):
    history: list[WeightLogResponse]
