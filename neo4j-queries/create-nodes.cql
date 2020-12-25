load csv with headers from 'file:///stops.csv' as row with row.stop_name as stopName, toInteger(row.stop_id) as stopId, toFloat(row.stop_lat) as stopLat, toFloat(row.stop_lon) as stopLon create (s:Stop{id: stopId}) set s.name = stopName, s.lat = stopLat, s.lon = stopLon return count(s);
create index stopIdx for (s:Stop) on (s.stopId);

load csv with headers from 'file:///routes-and-stops.csv' as row with row.route_short_name as routeName, toInteger(row.trip_id) as tripId, toInteger(row.stop_id) as stopId, row.stop_name as stopName, toFloat(row.stop_lat) as stopLat, toFloat(row.stop_lon) as stopLon, toInteger(row.sequence_num) as seqNum create (sr:StopForRoute{stopId: stopId, tripId: tripId}) set sr.routeShortName=routeName, sr.stopLat=stopLat, sr.stopLon=stopLon, sr.stopName=stopName, sr.sequenceNum=seqNum return count(sr);
create index stopRouteIdx for (sr:StopForRoute) on (sr.stopId, sr.tripId, sr.sequenceNum);

match (sr:StopForRoute) match (s:Stop{id: sr.stopId}) merge (sr)-[rel:LOCATED]->(s);
