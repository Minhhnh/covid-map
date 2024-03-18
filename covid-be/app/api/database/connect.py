"""Connect Postgres Database."""

import enum
import uuid

import pydantic
from geoalchemy2 import Geometry

from sqlalchemy import (
    ARRAY,
    UUID,
    Boolean,
    Column,
    DateTime,
    Float,
    ForeignKey,
    Integer,
    Numeric,
    String,
    create_engine,
    func,
    text,
)
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import declarative_base, sessionmaker
from sqlalchemy.sql import expression

from app.core.constant import SQLALCHEMY_DATABASE_URL
from app.logger.logger import custom_logger

custom_logger.info("Connecting PostgreSQL Database.")
custom_logger.info(SQLALCHEMY_DATABASE_URL)

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    pool_size=10,
    max_overflow=2,
    pool_recycle=300,
    pool_pre_ping=True,
    pool_use_lifo=True,
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
Base.metadata.create_all(bind=engine)

custom_logger.info("Connect PostgreSQL Database Success.")


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


class BaseModel(Base):
    __abstract__ = True

    created_by = Column(name="created_by", type_=String)
    updated_by = Column(name="updated_by", type_=String)
    created_at = Column(name="created_at", type_=DateTime(timezone=True), server_default=func.now())
    updated_at = Column(name="updated_at", type_=DateTime(timezone=True), server_default=func.now())

    @classmethod
    def create_from_schema(cls, schema: pydantic.BaseModel):
        obj = cls()
        obj.update_from_schema(schema)
        return obj

    def update_from_schema(self, schema: pydantic.BaseModel):
        for attr, value in schema.__dict__.items():
            if value is None:
                continue
            if attr != "_sa_instance_state":
                if isinstance(value, enum.Enum):
                    value = value.value
                if isinstance(value, list):
                    value = [x.value if isinstance(x, enum.Enum) else x for x in value]
                setattr(self, attr, value)

    def as_dict(self):
        return {c.name: str(getattr(self, c.name)) for c in self.__table__.columns}


class CovidUser(BaseModel):
    __tablename__ = "covid_user"
    id = Column(
        name="id",
        type_=UUID(as_uuid=True),
        primary_key=True,
        index=True,
        default=uuid.uuid4,
        server_default=text("gen_random_uuid()"),
    )
    age = Column(name="age", type_=Integer)
    gender = Column(name="gender", type_=String)
    confirmed_date = Column(name="confirmed_date", type_=DateTime())
    onset_date = Column(name="onset_date", type_=DateTime())
    examination_prefecture = Column(name="examination_prefecture", type_=String)
    current_prefecture = Column(name="current_prefecture", type_=String)
    lon = Column(name="lon", type_=Float)
    lat = Column(name="lat", type_=Float)
    geom = Column(name="geom", type_=Geometry(geometry_type="POINT", srid=4326))


CovidUser.__table__.create(bind=engine, checkfirst=True)
