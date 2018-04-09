install:
	bundle install
	rake neo4j:install[community-latest]
	# might need to install:
	# http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
	# https://docs.oracle.com/javase/8/docs/technotes/guides/install/mac_jdk.html#A1096855

start:
	rake neo4j:start
	rails s

stop:
	rake neo4j:stop

migrate:
	rake neo4j:migrate

seed:
	rake db:seed

run_specs:
	rake neo4j:stop
	rake neo4j:start[test]
	rake neo4j:migrate RAILS_ENV=test
	rspec
	rake neo4j:stop[test]
