class Article < ApplicationRecord
  has_many_attached :images
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(created_at: :desc) }

  scope :oldest, -> { order(created_at: :asc) }
  scope :newest, -> { order(created_at: :desc) }
end
