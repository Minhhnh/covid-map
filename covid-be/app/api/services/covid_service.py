"""User Service."""

from datetime import datetime
from typing import List
from sqlalchemy.orm import Session

from app.api.database.connect import CovidUser
from app.api.database.execute import covid as covid_execute


class CovidService:
    """Covid Service."""

    @staticmethod
    def get_all_covid_user(db: Session, limit, offset):
        """Get all users."""
        all_users: List[CovidUser] = covid_execute.get_all_covid_user(db, limit, offset)
        return [user.as_dict() for user in all_users]

    @staticmethod
    def get_geojson_data(db: Session, condition, limit, offset):
        """Get all users."""
        json_data = covid_execute.get_geojson_data(db, condition, limit, offset)
        if json_data:
            return json_data[0][0]
        return {"type": "FeatureCollection", "features": []}


covid_service = CovidService()
