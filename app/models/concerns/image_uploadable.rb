# Concern for models that support image uploads
module ImageUploadable
  extend ActiveSupport::Concern

  included do
    validate :validate_image_attachments, if: -> { images.attached? }
  end

  private

  def validate_image_attachments
    images.each do |image|
      validate_image_content_type(image)
      validate_image_size(image)
    end
  end

  def validate_image_content_type(image)
    allowed_types = Rails.application.config.active_storage.allowed_image_types
    unless allowed_types.include?(image.blob.content_type)
      errors.add(:images, "must be a valid image format (PNG, JPEG, GIF, or WebP)")
    end
  end

  def validate_image_size(image)
    max_size = Rails.application.config.active_storage.max_attachment_size
    if image.blob.byte_size > max_size
      size_mb = max_size / 1.megabyte
      errors.add(:images, "must be smaller than #{size_mb}MB")
    end
  end
end
