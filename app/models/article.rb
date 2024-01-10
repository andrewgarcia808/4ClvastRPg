class Article < ApplicationRecord
  validates :title, length: { maximum: 40 }
  validates :title,
            :content,
            :author,
            :category,
            :published_at, presence: true
end
