# Active Storage Configuration

## Overview

Active Storage is configured for image uploads with the following specifications:

## Configuration

### File Storage
- **Development**: Local disk storage in `/storage` directory
- **Test**: Temporary storage in `/tmp/storage` directory
- **Production**: Local disk storage (can be changed to cloud storage later)

### Image Constraints
- **Maximum file size**: 5MB per image
- **Allowed formats**: PNG, JPEG, GIF, WebP
- **Processor**: ImageMagick via mini_magick gem

## Usage in Models

To add image support to a model:

```ruby
class Note < ApplicationRecord
  include ImageUploadable

  has_many_attached :images
end
```

## Usage in Views

```erb
<!-- Display images -->
<% note.images.each do |image| %>
  <%= image_tag image, class: "w-full h-auto rounded" %>
<% end %>

<!-- Display images with custom variants -->
<% note.images.each do |image| %>
  <%= image_tag image.variant(resize_to_fit: [500, 500]), class: "w-full h-auto rounded" %>
<% end %>

<!-- Image upload form -->
<%= form.file_field :images, multiple: true, accept: "image/*" %>
```

## Database Tables

Active Storage creates three tables:
- `active_storage_blobs`: File metadata
- `active_storage_attachments`: Polymorphic join table
- `active_storage_variant_records`: Processed variants cache

## Security

- File type validation prevents non-image uploads (PNG, JPEG, GIF, WebP only)
- Size limits prevent abuse (5MB maximum)
- Files are served through Rails (can add authentication later)
