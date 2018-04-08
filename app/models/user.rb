class User
  include Neo4j::ActiveNode
  property :email, type: String, constraint: :unique

  has_many :both, :friends, type: 'FRIENDS_WITH', model_class: :User, unique: true
  has_many :in, :subscribers, type: 'FOLLOWS', model_class: :User, unique: true
  has_many :out, :subscriptions, type: 'FOLLOWS', model_class: :User, unique: true
  has_many :in, :blocked_by, type: 'BLOCKED_BY', model_class: :User, unique: true
  has_many :out, :blocked_users, type: 'BLOCKED_BY', model_class: :User, unique: true

  validates :email, presence: true, uniqueness: true

  def friend_list
    friends.pluck(:email)
  end

  def mutual_friends(user)
    friends.where(email: user.friend_list).pluck(:email)
  end

  def recipients
    [] # todo
  end
end
