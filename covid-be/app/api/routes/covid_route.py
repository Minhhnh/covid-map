from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.database.connect import get_db
from app.api.responses.base import BaseResponse
from app.api.services.covid_service import covid_service

router = APIRouter()


@router.get("", response_description="users retrieved")
async def get_all_covid_user(
    limit: int | None = 10,
    offset: int | None = 0,
    db: Session = Depends(get_db),
):
    """Get all user's information."""
    users = covid_service.get_all_covid_user(db, limit, offset)
    return BaseResponse.success_response(data=users, status_code=200)


@router.get("/geojson", response_description="geojson retrieved")
async def get_all_covid_user(
    condition: str | None = "",
    limit: int | None = 10,
    offset: int | None = 0,
    db: Session = Depends(get_db),
):
    """Get all user's information."""
    geojson_data = covid_service.get_geojson_data(db, condition, limit, offset)
    return geojson_data
