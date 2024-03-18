-- public.covid_user definition
-- Drop table
-- DROP TABLE public.covid_user;
CREATE EXTENSION postgis;

CREATE TABLE public.covid_user (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    age int4 NULL,
    gender varchar NULL,
    confirmed_date timestamp NULL,
    onset_date timestamp NULL,
    examination_prefecture varchar NULL,
    current_prefecture varchar NULL,
    lon float8 NULL,
    lat float8 NULL,
    geom public.geometry(point, 4326) NULL,
    created_by varchar NULL,
    updated_by varchar NULL,
    created_at timestamptz NULL DEFAULT NOW(),
    updated_at timestamptz NULL DEFAULT NOW(),
    CONSTRAINT covid_user_pkey PRIMARY KEY (id)
);

CREATE INDEX idx_covid_user_geom ON public.covid_user USING gist (geom);

CREATE INDEX ix_covid_user_id ON public.covid_user USING btree (id);