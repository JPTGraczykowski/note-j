class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]

  def index
    @folders = current_user.folders.includes(:parent, :children, :notes)
    @root_folders = @folders.root_folders
  end

  def show
    @notes = @folder.notes.includes(:tags, images_attachments: :blob).recent
    @subfolders = @folder.children
  end

  def new
    @folder = current_user.folders.build
    @available_parents = current_user.folders.order(:name)
  end

  def edit
    @available_parents = current_user.folders.where.not(id: @folder.id).order(:name)
  end

  def create
    @folder = current_user.folders.build(folder_params)

    if @folder.save
      redirect_to @folder, notice: "Folder was successfully created."
    else
      @available_parents = current_user.folders.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @folder.update(folder_params)
      redirect_to @folder, notice: "Folder was successfully updated."
    else
      @available_parents = current_user.folders.where.not(id: @folder.id).order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @folder.destroy
    redirect_to folders_url, notice: "Folder was successfully deleted."
  end

  private

  def set_folder
    @folder = current_user.folders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to folders_path, alert: "Folder not found."
  end

  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end
end
