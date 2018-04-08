query_string = <<query
  create
  (_10:User  { uuid: 'user-01-andy', email: 'andy@example.com' }),
  (_11:User  { uuid: 'user-02-john', email: 'john@example.com' }),
  (_12:User  { uuid: 'user-03-common', email: 'common@example.com' }),
  (_13:User  { uuid: 'user-04-lisa', email: 'lisa@example.com' }),
  (_14:User  { uuid: 'user-05-kate', email: 'kate@example.com' }),
  (_10)-[:friends]->(_12),
  (_11)-[:friends]->(_12),
  (_13)-[:subscriptions]->(_11),
  (_12)-[:blocks_users]->(_11)
query

Neo4j::Session.open(:server_db)
Neo4j::Session.current.query(query_string)
