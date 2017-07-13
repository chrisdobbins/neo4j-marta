FROM neo4j:3.2
ADD neo4j.conf /var/lib/neo4j/conf/
ADD data /var/lib/neo4j/import
ENV NEO4J_AUTH=none
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["neo4j"]
