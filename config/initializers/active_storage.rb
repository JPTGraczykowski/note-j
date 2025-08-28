# frozen_string_literal: true

# Configure Active Storage for image uploads

# Set maximum file size for uploads (5MB as per PRD requirements)
Rails.application.config.active_storage.max_attachment_size = 5.megabytes

# Configure image variants processor to use ImageMagick via mini_magick
Rails.application.config.active_storage.variant_processor = :mini_magick

# Allowed image content types
Rails.application.config.active_storage.allowed_image_types = %w[
  image/png
  image/jpeg
  image/gif
  image/webp
].freeze
