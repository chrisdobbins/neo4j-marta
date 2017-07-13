FROM neo4j:3.2
ADD neo4j.conf /var/lib/neo4j/conf/
ADD data /var/lib/neo4j/import
ENV NEO4J_CACHE_MEMORY=6G \
    NEO4J_HEAP_MEMORY=6G \
    JAVA_OPTS=-Xmx6G \
    NEO4J_AUTH=none
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["neo4j"]
