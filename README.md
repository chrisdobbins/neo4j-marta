# neo4j-marta-reborn
12/2020: I decided to revisit this project anew. There's no real point other than trying to learn more about graph databases and possibly make something that makes getting around by bus somewhat less onerous.

The inspiration for this project was my frustration with the limitations of transit directions via bus on Google Maps. Often, I found that some ways to arrive at a given point wouldn't show up in the directions. For example, to get to Five Points station from River Rd. in Clayton County, one can take the 15 and transfer to the 186 near South Dekalb Mall. Oftentimes, however, the only directions that would be shown as an option would be to take the 15 to the Decatur train station, then take the train to Five Points. Most times, that would be sufficient, but on the weekends that MARTA does single tracking, it can be a bit faster and more predictable to get there via bus since no transit apps account for the schedule change in determining the best way to get somewhere. I may add a web app that shows the closest buses to one's current location along with where they are headed.

## How to Use
This is designed to be straightforward to use. If there are improvements that could be made, feel free to submit a pull request. 

The following is assumed:
- Neo4j is installed and you have sufficient permissions to install/use [APOC](https://neo4j.com/labs/apoc/).
- PostgreSQL is installed.

### Things to note:
- Postgres was primarily used to get the data needed to create the Neo4j nodes and relationships. That data currently resides in `neo4j-import/routes-and-trips.csv`, `neo4j-import/routes-and-stops.csv`, and `neo4j-import/stops.csv`.
To re-generate `routes-and-trips.csv` and `routes-and-stops.csv`, first run `postgres-queries/create-tables.sql`, then run `postgres-queries/create-csv-files.sql`. `stops.csv` is the same as `stops.txt` in the `source-data` directory.
- To import data into Neo4j: 
  1. Copy the files in `neo4j-import/` to `$NEO4J_HOME/import/`. 
  2. **This step is only applicable if the APOC plugin is not already enabled and installed.** 
     1. To enable APOC, inside `neo4j.conf`, go to `dbms.security.procedures.unrestricted` and add `apoc.*` (this is the quick-n-dirty way and NOT recommended for production) *or* uncomment `dbms.security.procedures.allowlist` and append `apoc.*`, if you want to use all APOC procedures. In settings in which security matters, modify `apoc.*` accordingly to only allow those APOC procedures that are needed. Or, you can copy the `neo4j.conf` in this repo to your `$NEO4J_HOME/conf` directory. Then, **restart Neo4j**.
     2. To install APOC Core, copy its jar file (currently found in `$NEO4J_HOME/labs/`; mine is called `apoc-4.2.0.0-core.jar`) to `$NEO4J_HOME/plugins/` and **restart Neo4j**. If you run into trouble, [this](https://github.com/neo4j-contrib/neo4j-apoc-procedures) may help.
  3. Run `neo4j-queries/create-nodes.cql`.
  4. Run `link-route-stops.sh` to link all the `StopForRoute` nodes for every trip. This will probably take a while. On my (admittedly ancient) machine, it took ~12 hours. Its specs, to provide an idea of what to possibly expect: MacOS Catalina 10.15, 2.5 GHz Dual-Core Intel Core i5 with 16GB RAM. (My apologies to any Windows users; I don't have access to a Windows machine, nor do I know PowerShell. If you do and you want to remedy this, feel free to submit a PR.)
- The config file in this repo also sets the initial and max heap sizes to 7GB because that was worked best on my machine. Feel free to edit for your needs. If you're unsure, use [neo4j-admin-memrec](https://neo4j.com/docs/operations-manual/current/tools/neo4j-admin-memrec) to get an idea of sensible settings for your machine.
- `neo4j-queries/find-route-to-destination.cql` is a sample query that finds a path from one `Stop` to another `Stop`. It can also be modified for use on `StopForRoute` nodes.
