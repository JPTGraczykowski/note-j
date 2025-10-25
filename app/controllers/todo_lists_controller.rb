class TodoListsController < ApplicationController
  before_action :set_todo_list, only: [:show, :edit, :update, :destroy, :toggle]

  def index
    @todo_lists = current_user.todo_lists.includes(:todos).recent
  end

  def show
    @todos = @todo_list.todos.recent
  end

  def new
    @todo_list = current_user.todo_lists.build
  end

  def edit
  end

  def create
    @todo_list = current_user.todo_lists.build(todo_list_params)

    if @todo_list.save
      redirect_to @todo_list, notice: "Todo list was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @todo_list.update(todo_list_params)
      redirect_to @todo_list, notice: "Todo list was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @todo_list.destroy
    redirect_to todo_lists_url, notice: "Todo list was successfully deleted."
  end

  def toggle
    @todo_list.toggle_completion!
    redirect_to @todo_list, notice: "Todo list status was toggled."
  end

  private

  def set_todo_list
    @todo_list = current_user.todo_lists.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to todo_lists_path, alert: "Todo list not found."
  end

  def todo_list_params
    params.require(:todo_list).permit(:title, :completed)
  end
end
