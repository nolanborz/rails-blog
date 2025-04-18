class Article < ApplicationRecord
  has_many_attached :images
  has_rich_text :body
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
  validates :tags, presence: true, allow_blank: true

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(created_at: :desc) }

  scope :oldest, -> { order(created_at: :asc) }
  scope :newest, -> { order(created_at: :desc) }
end
