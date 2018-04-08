class User
  include Neo4j::ActiveNode
  property :email, type: String, constraint: :unique

  has_many :both, :friends, type: 'FRIENDS_WITH', model_class: :User, unique: true
  has_many :in, :subscribers, type: 'FOLLOWED_BY', model_class: :User, unique: true
  has_many :out, :subscriptions, type: 'FOLLOWED_BY', model_class: :User, unique: true
  has_many :in, :blocked_by, type: 'BLOCKED_BY', model_class: :User, unique: true
  has_many :out, :blocks_users, type: 'BLOCKED_BY', model_class: :User, unique: true

  validates :email, presence: true, uniqueness: true

  def friend_list
    friends.pluck(:email)
  end

  def mutual_friends(user)
    friends.where(email: user.friend_list).pluck(:email)
  end

  def recipients
    query_as(:user).
      match("(user)<-[r:FOLLOWED_BY]-(subscribers:User)").
      where_not(subscribers: { email: friend_list }).
      where_not("(user)<-[:BLOCKED_BY]-(subscribers)").
      with("user, collect(subscribers) as subscribers").
      match("(user)-[r:FRIENDS_WITH]->(friends:User)").
      where_not("(user)<-[:BLOCKED_BY]-(friends)").
      pluck(:subscribers, :friends).flatten.pluck(:email)
  end
end
