class Article < ApplicationRecord
  has_many_attached :images
  has_rich_text :body
  validates :title, presence: true
  validates :tags, presence: true, allow_blank: true

  validate :body_length

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }
  scope :newest, -> { order(created_at: :desc) }

  private

  def body_length
    if body.present?
      if body.to_plain_text.length < 10
        errors.add(:body, "is too short (minimum is 10 characters)")
      end
    else
      errors.add(:body, "can't be blank")
    end
  end
end
