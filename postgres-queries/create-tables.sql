--create route table
create table route (route_id integer primary key, route_short_name varchar, route_long_name varchar, route_desc varchar, route_type varchar, route_url varchar, route_text_color varchar);
copy route from 'source-data/routes.txt' delimiters ',' csv header;

--create trip table
create table trip (route_id integer, service_id varchar, trip_id integer primary key, trip_headsign varchar, direction_id smallint, block_id varchar, shape_id varchar);
copy trip from 'source-data/trips.txt' delimiters ',' csv header;

--create stop_time table from csv
create table stop_time (trip_id integer, arrival_time varchar, departure_time varchar, stop_id integer, stop_sequence smallint primary key(trip_id, stop_id, stop_sequence));
--NOTE: stop_sequence is needed as part of the composite key because there is at least one duplicate combo of trip_id and stop_id (trip_id 7734273, stop_id 212600)
copy stop_time from 'source-data/stop_times.txt' delimiters ',' csv header;

-- create stop table from csv
create table stop (stop_id integer primary key, stop_code varchar, stop_name varchar, stop_lat varchar, stop_lon varchar);
copy stop from 'source-data/stops.txt' delimiters ',' csv header;
--this part requires PostGIS to be installed
select AddGeometryColumn('stops', 'geom', 4326, 'POINT', 2);
with stop_points as (select stop_id, stop_lon, stop_lat from stops) update stops set geom=ST_GeometryFromText(concat('POINT(', stop_points.stop_lon, ' ', stop_points.stop_lat, ')'), 4326) from stop_points where stops.stop_id=stop_points.stop_id;

