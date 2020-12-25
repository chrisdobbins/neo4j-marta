#!/bin/bash
# This script links each route trip's stops.

CYPHER_PATH='~/neo4j/neo4j-community-4.2.1/bin/cypher-shell'
NEO4J_USER='neo4j'
NEO4J_PW='password'

while IFS=, read -r ROUTE_NAME TRIP_ID; do
  "$CYPHER_PATH" -u "$NEO4J_USER" 'match (s:StopForRoute{tripId: '"$TRIP_ID"', routeShortName: "'"$ROUTE_NAME"'"})  with s order by s.sequenceNum asc with collect(s) as stops call apoc.nodes.link(stops, "NEXT") return stops' -p "$NEO4J_PW" --format plain 
done < "neo4j-import/routes-and-trips.csv"
