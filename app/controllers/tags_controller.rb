class TagsController < ApplicationController
  before_action :set_tag, only: [:edit, :update, :destroy]

  def index
    @tags = current_user.tags.includes(:notes, :todos).order(:name)
  end

  def new
    @tag = current_user.tags.build
  end

  def edit
  end

  def create
    @tag = current_user.tags.build(tag_params)

    if @tag.save
      redirect_to @tag, notice: "Tag was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @tag.update(tag_params)
      redirect_to @tag, notice: "Tag was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    redirect_to tags_url, notice: "Tag was successfully deleted."
  end

  private

  def set_tag
    @tag = current_user.tags.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tags_path, alert: "Tag not found."
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
