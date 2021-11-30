class Book < ApplicationRecord
	belongs_to :user
  # userモデルとの関連付け
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  # このメソッドで、引数で渡されたユーザidがFavoritesテーブル内に存在（exists?）するかどうかを調べます。
  # 存在していればtrue、存在していなければfalseを返すようにしています。viewのbook.showで使う！



	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
end
