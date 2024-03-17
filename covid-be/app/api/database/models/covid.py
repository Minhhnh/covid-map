import uuid
from sqlalchemy import UUID, Column, DateTime, Float, Integer, String

from app.api.database.connect import BaseModel


# class CovidUser(BaseModel):
#     __tablename__ = "covid_user"
#     id = Column(name="id", type_=UUID(as_uuid=True), primary_key=True, index=True, default=uuid.uuid4)
#     age = Column(name="age", type_=Integer)
#     gender = Column(name="gender", type_=String)
#     confirmed_date = Column(name="confirmed_date", type_=DateTime(timezone=True))
#     onset_date = Column(name="onset_date", type_=DateTime(timezone=True))
#     examination_prefecture = Column(name="examination_prefecture", type_=String)
#     current_prefecture = Column(name="current_prefecture", type_=String)
#     lon = Column(name="lon", type_=Float)
#     lat = Column(name="lat", type_=Float)
