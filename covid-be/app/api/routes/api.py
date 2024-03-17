"""API Routes."""

from fastapi import APIRouter

from app.api.routes import covid_route

app = APIRouter()

# app.include_router(user_route.router, tags=["User"], prefix="/admin/user")
app.include_router(covid_route.router, tags=["Covid"], prefix="/admin/covid")
