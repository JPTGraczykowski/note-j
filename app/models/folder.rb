class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Folder", optional: true
  has_many :children, class_name: "Folder", foreign_key: :parent_id, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validate :cannot_be_parent_of_itself
  validate :cannot_create_circular_reference

  scope :root_folders, -> { where(parent_id: nil) }
  scope :for_user, ->(user) { where(user: user) }

  def root?
    parent_id.nil?
  end

  def has_children?
    children.exists?
  end

  def ancestors
    return [] if root?
    [parent] + parent.ancestors
  end

  def descendants
    children.flat_map { |child| [child] + child.descendants }
  end

  def full_path
    return name if root?
    "#{parent.full_path}/#{name}"
  end

  def depth
    root? ? 0 : parent.depth + 1
  end

  private

  def cannot_be_parent_of_itself
    return if new_record?
    errors.add(:parent_id, "cannot be the same as the folder itself") if parent_id == id
  end

  def cannot_create_circular_reference
    return if parent_id.blank? || new_record?

    current_parent = parent
    while current_parent
      if current_parent.id == id
        errors.add(:parent_id, "cannot create circular reference")
        break
      end
      current_parent = current_parent.parent
    end
  end
end
