class User
  include Neo4j::ActiveNode
  property :email, type: String, constraint: :unique

  validates :email, presence: true, uniqueness: true
end
