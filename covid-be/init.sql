INSERT INTO public.covid_user
(age, gender, examination_prefecture, current_prefecture, lon, lat, created_by, updated_by)
VALUES(0, '', '', '', 0, 0, '', '');

gen_random_uuid();


select count(*) from covid_user;

drop table covid_user;


alter table covid_user
    add geom geometry(point, 4326);

UPDATE covid_user SET geom = ST_GeogFromText('SRID=4326;POINT(' || lon || ' ' || lat || ')')::GEOMETRY;


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
			) inputs
	) features;