class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # フォローした・されたの関係のアソシエーション   class_name: "Relationship" Relationshipテーブルを参照
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy   # foreign_key: "follower_id"で参照するカラムを指定しています。
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  #（relationships・reverse_of_relationships）は分かりにくいた名前を適当に付けている

  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # フォロー・フォロワーの一覧画面で、user.followersという記述でフォロワーを表示したいので、throughでスルーするテーブル、sourceで参照するカラムを指定。

  # フォローしたときの処理
  def follow(user_id)
    unless self == user_id
     relationships.create(followed_id: user_id)
    end
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end


  attachment :profile_image, destroy: false

  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: { maximum: 50 }
end
