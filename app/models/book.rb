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

   # 検索方法分岐の処理
  def self.looks(search, word)
   if search == "perfect_match"
     @book = Book.where("title LIKE?","#{word}")
   elsif search == "forward_match"
     @book = Book.where("title LIKE?","#{word}%")
   elsif search == "backward_match"
     @book = Book.where("title LIKE?","%#{word}")
   elsif search == "partial_match"
     @book = Book.where("title LIKE?","%#{word}%")
   else
     @book = Book.all
   end
  end


	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
end
