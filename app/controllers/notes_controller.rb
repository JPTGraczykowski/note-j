class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    @notes = current_user.notes.includes(:folder, :tags, images_attachments: :blob)
    filter_notes
    @notes = @notes.recent
  end

  def show
  end

  def new
    @note = current_user.notes.build
  end

  def edit
  end

  def create
    @note = current_user.notes.build(note_params)

    if @note.save
      redirect_to @note, notice: "Note was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      redirect_to @note, notice: "Note was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    redirect_to notes_url, notice: "Note was successfully deleted."
  end

  private

  def set_note
    @note = current_user.notes.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to notes_path, alert: "Note not found."
  end

  def filter_notes
    if params[:folder_id].present?
      @folder = current_user.folders.find(params[:folder_id])
      @notes = @notes.where(folder: @folder)
    end

    if params[:tag].present?
      @notes = @notes.tagged_with(params[:tag])
    end

    if params[:search].present?
      query = params[:search].strip
      @notes = @notes.search_by_title(query)
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to notes_path, alert: "Filters are not correct."
  end

  def note_params
    params.require(:note).permit(:title, :content, :folder_id, tag_ids: [], images: [])
  end

  def current_user
    # Placeholder for authentication - will be implemented when we add authentication
    @current_user ||= User.first || User.create!(
      name: "Demo User",
      email: "demo@example.com",
      provider: "demo",
      uid: "demo123"
    )
  end
end
