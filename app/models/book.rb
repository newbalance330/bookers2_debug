class Book < ApplicationRecord
	belongs_to :user
  # userモデルとの関連付け

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
end
