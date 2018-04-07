class User
  include Neo4j::ActiveNode
  property :email, type: String, constraint: :unique

  has_many :both, :friends, type: 'FRIENDS_WITH', model_class: :User, unique: true
  has_many :in, :subscribers, type: 'FOLLOWS', model_class: :User, unique: true
  has_many :out, :subscriptions, type: 'FOLLOWS', model_class: :User, unique: true

  validates :email, presence: true, uniqueness: true
end
