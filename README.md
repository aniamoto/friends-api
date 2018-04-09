# README

## Friends API
Simple user relationships management.

Database: [Neo4j](https://neo4j.com/) graph database for efficiency and scalability.
Graph databases are great for handling queries over connected data, especially with a non-trivial or growing number of relationship traversals and they support high update rates.

Framework: Rails API to speed up the development (deliver ASAP, optimize later).
While for small applications it might be sufficient to use Grape or Sinatra, Rails provides a great support for adding more features and libraries when needed.

## Documentation
https://documenter.getpostman.com/view/4100407/friends-api/RVu5iTsE

## Live app
https://rocky-gorge-72080.herokuapp.com/api/v1

## Install and start
* Run `make install migrate seed start`.
* Installation of [Java SE Development Kit 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) might be required. [Java SE 8 Docs](https://docs.oracle.com/javase/8/docs/technotes/guides/install/mac_jdk.html#A1096855).

## Stop the app
* Exit rails server and run `make stop`.

## Tests
* Run `make run_specs`.
