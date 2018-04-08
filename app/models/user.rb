class User
  include Neo4j::ActiveNode
  property :email, type: String, constraint: :unique

  has_many :both, :friends, type: 'FRIENDS_WITH', model_class: :User, unique: true
  has_many :in, :subscribers, type: 'FOLLOWS', model_class: :User, unique: true
  has_many :out, :subscriptions, type: 'FOLLOWS', model_class: :User, unique: true
  has_many :in, :blocked_by, type: 'BLOCKS', model_class: :User, unique: true
  has_many :out, :blocks_users, type: 'BLOCKS', model_class: :User, unique: true

  validates :email, presence: true, uniqueness: true

  def friend_list
    friends.pluck(:email)
  end

  def mutual_friends(user)
    friends.where(email: user.friend_list).pluck(:email)
  end

  def friendship_possible?(user)
    blocks_or_blocked_by.exclude?(user)
  end

  def recipients
    query_as(:user).
      optional_match("(user)<-[r:FOLLOWS]-(subscribers:User)").
      where_not(subscribers: { email: friend_list }).
      where_not("(user)<-[:BLOCKS]-(subscribers)").
      with("user, collect(subscribers) as subscribers").
      optional_match("(user)-[r:FRIENDS_WITH]->(friends:User)").
      where_not("(user)<-[:BLOCKS]-(friends)").
      with("subscribers, collect(friends) as friends").
      pluck(:subscribers, :friends).flatten.pluck(:email)
  end

  def blocks_or_blocked_by
    query_as(:user).
      match("(user)<-[r:BLOCKS]->(users:User)").
      with("user, collect(DISTINCT users) as users").
      pluck(:users).flatten
  end
end
