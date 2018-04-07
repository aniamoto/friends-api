class CreateUser < Neo4j::Migrations::Base
  def up
    add_constraint :User, :uuid
    add_constraint :User, :email
  end

  def down
    drop_constraint :User, :uuid
    drop_constraint :User, :email
  end
end
