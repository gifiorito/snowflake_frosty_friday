-- Snowflake Frosty Friday
-- Week 112 - Intermediate - Creating a polygon
-- https://frostyfriday.org/blog/2024/09/27/week-112-intermediate/


-- data provided for the challenge {
CREATE OR REPLACE TABLE event_schedule_geo (
Region VARCHAR,
City VARCHAR,
Event_Date DATE,
GPS_Coordinates VARCHAR,
Geo_Point GEOGRAPHY
);

INSERT INTO event_schedule_geo (Region, City, Event_Date, Geo_Point)
SELECT
'Americas', 'Atlanta', '2024-10-03', TO_GEOGRAPHY('POINT(-84.3880 33.7490)')
UNION ALL
SELECT
'Americas', 'Bogotá', '2024-10-30', TO_GEOGRAPHY('POINT(-74.0721 4.7110)')
UNION ALL
SELECT
'Americas', 'Chicago', '2024-11-04', TO_GEOGRAPHY('POINT(-87.6298 41.8781)')
UNION ALL
SELECT
'Americas', 'Dallas', '2024-10-01', TO_GEOGRAPHY('POINT(-96.7970 32.7767)')
UNION ALL
SELECT
'Americas', 'Mexico City', '2024-10-24', TO_GEOGRAPHY('POINT(-99.1332 19.4326)')
UNION ALL
SELECT
'Americas', 'New York City', '2024-10-15', TO_GEOGRAPHY('POINT(-74.0060 40.7128)')
UNION ALL
SELECT
'Americas', 'São Paulo', '2024-10-08', TO_GEOGRAPHY('POINT(-46.6333 -23.5505)')
UNION ALL
SELECT
'Americas', 'Toronto', '2024-10-21', TO_GEOGRAPHY('POINT(-79.347015 43.651070)')

UNION ALL
SELECT
'EMEA', 'Amsterdam', '2024-10-03', TO_GEOGRAPHY('POINT(4.9041 52.3676)')
UNION ALL
SELECT
'EMEA', 'Berlin', '2024-10-16', TO_GEOGRAPHY('POINT(13.4050 52.5200)')
UNION ALL
SELECT
'EMEA', 'London', '2024-10-10', TO_GEOGRAPHY('POINT(-0.1278 51.5074)')
UNION ALL
SELECT
'EMEA', 'Paris', '2024-10-01', TO_GEOGRAPHY('POINT(2.3522 48.8566)')
UNION ALL
SELECT
'EMEA', 'Stockholm', '2024-10-17', TO_GEOGRAPHY('POINT(18.0686 59.3293)')

UNION ALL
SELECT
'APJ', 'Kuala Lumpur', '2024-10-23', TO_GEOGRAPHY('POINT(101.6869 3.1390)')
UNION ALL
SELECT
'APJ', 'Mumbai', '2024-10-04', TO_GEOGRAPHY('POINT(72.8777 19.0760)')
UNION ALL
SELECT
'APJ', 'Auckland', '2024-10-24', TO_GEOGRAPHY('POINT(174.7633 -36.8485)')
UNION ALL
SELECT
'APJ', 'Manila', '2024-10-02', TO_GEOGRAPHY('POINT(120.9842 14.5995)')
UNION ALL
SELECT
'APJ', 'Sydney', '2024-10-29', TO_GEOGRAPHY('POINT(151.2093 -33.8688)');

-- }


-- Solution of the challenge starts here
with

-- Angle to order coordinates -> needed to form a valid polygon, ensuring the edges do not cross
coordinates as (
  select 
    st_x(geo_point) as longitude
    ,st_y(geo_point) as latitude
    ,avg(st_x(geo_point)) over (partition by 1) as centroid_lon
    ,avg(st_y(geo_point)) over (partition by 1) as centroid_lat
    ,atan2(st_y(geo_point) - avg(st_y(geo_point)) over (partition by 1)
        , st_x(geo_point) - avg(st_x(geo_point)) over (partition by 1)) as angle
  from event_schedule_geo
  order by angle
)

-- Identify the 1st point as it needs to end with the same point
,polygon_start as (
    select
        longitude
        ,latitude
    from coordinates
    qualify row_number() over (partition by 1 order by angle) = 1
)

-- Create linestring
,linestring as (
  select 
    listagg(longitude || ' ' || latitude, ', ') 
        within group (order by angle) as linestring
  from coordinates
)

-- Adding the 1st point to the end of the linestring to ensure the lines are forming a loop
,final_linestring as (
    select
        l.linestring || ', ' || s.longitude || ' ' || s.latitude as linestring
    from linestring l
    left join polygon_start s
        on 1=1
)

-- Make the polygon
select 
    st_makepolygon(
        to_geography(
            'LINESTRING(' || linestring || ')')
    ) as polygon
from final_linestring
;