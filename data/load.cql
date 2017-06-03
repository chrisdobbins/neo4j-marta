CREATE CONSTRAINT ON (l:Location) ASSERT l.id IS UNIQUE;
CREATE CONSTRAINT ON (r:Route) ASSERT r.id IS UNIQUE;
CREATE CONSTRAINT ON (t:Trip) ASSERT t.id IS UNIQUE;
CREATE INDEX ON :Stop(sequence, tripId, locationId);
CREATE INDEX ON :Stop(sequence, tripId);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM 'file:///routes.csv' AS row
CREATE (:Route {id: row.route_id, shortName: row.route_short_name, longName: row.route_long_name});

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM 'file:///stops.csv' AS row
CREATE (:Location {id: row.stop_id, code: row.stop_code, name: row.stop_name, lat: row.stop_lat, lon: row.stop_lon});

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM 'file:///stop_times.csv' AS row
match (sl:Location {id: row.stop_id})
create (s:Stop {sequence: toInteger(row.stop_sequence), tripId: row.trip_id, locationId: sl.id, arrival: row.arrival_time, departure: row.departure_time})
merge (s)-[:IS_LOCATED_AT]->(sl);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM 'file:///trips.csv' AS row
CREATE (:Trip {id: row.trip_id, routeId: row.route_id, headsign: row.trip_headsign, directionId: row.direction_id});

match (r:Route)
match (t:Trip {routeId: r.id})
merge (r)-[:TRIP]->(t);

match (t:Trip)
match (s:Stop {tripId: t.id, sequence: 1})
merge (t)-[:STARTS_AT]->(s);

USING PERIODIC COMMIT 1
LOAD CSV WITH HEADERS FROM "file:///stop_times.csv" AS row
WITH toInteger(row.stop_sequence) AS seq, row
match (s1:Stop {tripId: row.trip_id, sequence: seq})
match (s2:Stop {tripId: s1.tripId, sequence: seq+1})
merge(s1)-[:NEXT]->(s2);

