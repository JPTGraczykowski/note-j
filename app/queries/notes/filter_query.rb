module Notes
  class FilterQuery
    def initialize(notes:, folder_id: nil, tag_id: nil)
      @notes = notes.dup
      @folder_id = folder_id
      @tag_id = tag_id
    end

    def results
      @notes =apply_folder_filter
      @notes = apply_tag_filter
      notes
    end

    private

    attr_reader :notes, :folder_id, :tag_id

    def apply_folder_filter
      return notes unless folder_id.present?

      if folder_id == "none"
        notes.without_folder
      else
        notes.in_folder(folder_id)
      end
    end

    def apply_tag_filter
      return notes unless tag_id.present?

      notes.tagged_with(tag_id)
    end
  end
end
