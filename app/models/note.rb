class Note < ApplicationRecord
  include ImageUploadable

  belongs_to :folder, optional: true
  belongs_to :user

  has_many_attached :images
  has_many :notes_tags, dependent: :destroy
  has_many :tags, through: :notes_tags

  validates :title, presence: true, length: { maximum: 200 }

  scope :for_user, ->(user) { where(user: user) }
  scope :in_folder, ->(folder) { where(folder: folder) }
  scope :without_folder, -> { where(folder: nil) }
  scope :recent, -> { order(created_at: :desc) }
  scope :search_by_title, ->(query) { where("title LIKE ?", "%#{query}%") }
  scope :tagged_with, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }

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
