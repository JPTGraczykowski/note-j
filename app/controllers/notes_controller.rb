class NotesController < ApplicationController
  before_action :set_folder, only: [:index]
  before_action :set_tag, only: [:index]
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    @notes = current_user.notes.includes(:folder, :tags, images_attachments: :blob)
    filter_notes
    @notes = @notes.recent
    @children_folders = @folder.children.order(:name) if @folder
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
    service = NoteServices::Update.new(params: note_params, note: @note)

    if service.call
      redirect_to @note, notice: "Note was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    redirect_to notes_url, notice: "Note was successfully deleted."
  end

  def preview_markdown
    content = params[:content] || ""
    render json: { html: helpers.markdown(content) }
  end

  private

  def set_note
    @note = current_user.notes.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to notes_path, alert: "Note not found."
  end

  def set_folder
    @folder = current_user.folders.find_by(id: params[:folder_id])
  end

  def set_tag
    @tag = current_user.tags.find_by(id: params[:tag_id])
  end

  def filter_notes
    query = Notes::FilterQuery.new(
      notes: @notes,
      folder_id: params[:folder_id],
      tag_id: params[:tag_id]
    )
    @notes = query.results
  end

  def note_params
    params.require(:note).permit(:title, :content, :folder_id, tag_ids: [], images: [])
  end
end
