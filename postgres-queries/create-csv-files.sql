\copy (with trip_to_route as (select distinct route.route_short_name, stop_time.trip_id from trip inner join route on trip.route_id=route.route_id inner join stop_time on stop_time.trip_id=trip.trip_id)
select route_short_name, trip.trip_id, stop.stop_id, stop.stop_name, stop.stop_lat, stop.stop_lon, row_number() over(partition by trip.trip_id order by stop_time.stop_sequence) as sequence_num from stop_time inner join trip on trip.trip_id=stop_time.trip_id inner join stop on stop.stop_id=stop_time.stop_id inner join trip_to_route on trip_to_route.trip_id=stop_time.trip_id) to 'routes-and-stops.csv' csv header;

--create csv with routes and individual trip IDs, in order of route name
\copy (select distinct route_short_name, trip_id from trip inner join route on route.route_id=trip.route_id order by route_short_name;) to '~/routes-and-trips.csv' csv header;

