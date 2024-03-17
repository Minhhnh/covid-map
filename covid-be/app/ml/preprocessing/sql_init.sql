INSERT INTO
    public.covid_user (
        age,
        gender,
        examination_prefecture,
        current_prefecture,
        lon,
        lat,
        created_by,
        updated_by
    )
VALUES
(0, '', '', '', 0, 0, '', '');

gen_random_uuid();

SELECT
    count(*)
FROM
    covid_user;

DROP TABLE covid_user;

ALTER TABLE
    covid_user
ADD
    geom geometry(point, 4326);

UPDATE
    covid_user
SET
    geom = ST_GeogFromText('SRID=4326;POINT(' || lon || ' ' || lat || ')') :: GEOMETRY;

SELECT
    jsonb_build_object(
        'type',
        'FeatureCollection',
        'features',
        jsonb_agg(features.feature)
    )
FROM
    (
        SELECT
            jsonb_build_object(
                'type',
                'Feature',
                'id',
                id,
                'geometry',
                ST_AsGeoJSON(geom) :: jsonb,
                'properties',
                to_jsonb(inputs) - 'gid' - 'geom'
            ) AS feature
        FROM
            (
                SELECT
                    *
                FROM
                    covid_user
            ) inputs
    ) features;