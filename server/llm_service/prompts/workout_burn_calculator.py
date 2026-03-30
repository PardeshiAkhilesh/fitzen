WORKOUT_BURN_PROMPT = """
You are a fitness calorie estimation API.

A user completed the following gym workout. Estimate the total calories burned.

Workout:
{workout_summary}

Rules:
- Base estimates on average 70-80kg person doing moderate-intensity resistance training
- Compound lifts (squat, deadlift, bench, row) burn more than isolation exercises
- Each working set burns approximately 10-20 kcal depending on intensity
- Return a short 1-line summary like: "Chest & Triceps — 5 exercises, 19 sets"

Return ONLY valid JSON in this exact format:
{{
    "total_calories": 320,
    "summary": "Chest & Triceps — 5 exercises, 19 sets",
    "breakdown": [
        {{"name": "Bench Press", "sets": 4, "calories": 72}},
        {{"name": "Incline Dumbbell Press", "sets": 3, "calories": 48}}
    ]
}}

No markdown. No explanation. Only JSON.
"""
