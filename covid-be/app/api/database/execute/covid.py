import datetime
from typing import List
from uuid import UUID
from sqlalchemy.sql import text

from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.api.database.connect import CovidUser


def get_all_covid_user(db: Session, limit=10, offset=10) -> List[CovidUser] | None:
    """Get user."""
    return db.query(CovidUser).limit(limit).offset(offset).all()


def get_geojson_data(db: Session, condition, limit=10, offset=10):
    condition = ""
    if condition:
        condition += f" WHERE {condition}"
    if limit > 0:
        condition += f" LIMIT {limit} OFFSET {offset}"

    query = f"""
    select
        jsonb_build_object(
            'type',
            'FeatureCollection',
            'features',
            jsonb_agg(features.feature)
        )
    from
        (
            select
                jsonb_build_object(
                    'type',
                    'Feature',
                    'id',
                    id,
                    'geometry',
                    ST_AsGeoJSON(geom)::jsonb,
                    'properties',
                    to_jsonb(inputs) - 'gid' - 'geom'
                ) as feature
            from
                (
                    select
                        *
                    from
                        covid_user
                    {condition}
                ) inputs
        ) features;
    """
    cur = db.execute(text(query))
    return cur.fetchall()
