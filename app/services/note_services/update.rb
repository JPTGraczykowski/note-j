module NoteServices
  class Update
    attr_reader :params, :note

    def initialize(params:, note:)
      @params = params
      @note = note
    end

    def call
      handle_image_removals
      handle_new_images

      note.update(params.except(:images))
    end

    private

    def handle_image_removals
      return unless params && params[:remove_images]

      image_ids_to_remove = Array(params[:remove_images]).reject(&:blank?)
      image_ids_to_remove.each do |image_id|
        image = note.images.find_by(id: image_id)
        image&.purge
      end
    end

    def handle_new_images
      return unless params[:images]

      new_images = params[:images].reject(&:blank?)
      new_images.each do |image|
        note.images.attach(image)
      end
    end
  end
end
