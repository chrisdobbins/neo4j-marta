// This query finds a path from one point to another,
// taking directionality into consideration (e.g., no
// part of any path will have the relationship <-[NEXT]-).
// It will also work with `StopForRoute`s.

// Note: using NODE_GLOBAL or RELATIONSHIP_GLOBAL 
// will avoid very long query times due to the
// Cartesian product that is created.

match (start:Stop{id: 902517}) match (end:Stop{id: 900051}) call apoc.path.expandConfig(start, {relationshipFilter: "NEXT>|LOCATED", endNodes: [end], uniqueness: "NODE_GLOBAL"}) yield path return path;
