class Note < ApplicationRecord
  include ImageUploadable

  belongs_to :folder, optional: true
  belongs_to :user

  has_many_attached :images
  has_many :notes_tags, dependent: :destroy
  has_many :tags, through: :notes_tags

  validates :title, presence: true, length: { maximum: 200 }

  scope :for_user, ->(user_id) { where(user_id: user_id) }
  scope :recent, -> { order(created_at: :desc) }
  scope :search_by_title, ->(query) { where("title LIKE ?", "%#{query}%") }
  scope :in_folder, ->(folder_id) { where(folder_id: folder_id) }
  scope :without_folder, -> { where(folder_id: nil) }
  scope :tagged_with, ->(tag_id) { joins(:tags).where(tags: { id: tag_id }) }

  def folder_name
    folder&.name || "No folder"
  end

  def folder_path
    folder&.full_path || "No folder"
  end

  def has_images?
    images.attached?
  end

  def tag_names
    tags.pluck(:name)
  end
end
