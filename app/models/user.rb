class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_one_attached :profile_image
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  #has_many :active_relationships, class_name: 　　　"Relationship",foreign_key: "follower_id",dependent: :destroy
  # has_many :following, through: :active_relationships, source: :followed
  
  #フォローされる側
  has_many :following_users, through: :followers, source: :followed
  #フォローする側
  has_many :follower_users, through: :followeds, source: :follower
  

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {  maximum: 50 }



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  #followed_id　に　user_idを代入する
  def follow(user_id)
    followers.create(followed_id: user_id)
  end
  
  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end
  
  def following?(user)
    following_users.include?(user)
  end
  
  #self:クラスメソッドにできる
  def self.looks(search, word)
    if search == "perfect_match"
       User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      User.where("name LIKE?","%#{word}%")
    else
      User.all
    end
  end
end

