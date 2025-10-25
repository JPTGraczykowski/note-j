class TodosController < ApplicationController
  before_action :set_todo, only: [:edit, :update, :destroy, :toggle]
  before_action :set_todo_list, only: [:create]

  def new
    @todo_list = current_user.todo_lists.find(params[:todo_list_id])
    @todo = @todo_list.todos.build
  end

  def edit
  end

  def create
    @todo = @todo_list.todos.build(todo_params)
    @todo.user = current_user

    if @todo.save
      redirect_to @todo_list, notice: "Todo was successfully created."
    else
      redirect_to @todo_list, alert: "Error creating todo: #{@todo.errors.full_messages.join(', ')}"
    end
  end

  def update
    if @todo.update(todo_params)
      redirect_to @todo.todo_list, notice: "Todo was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    todo_list = @todo.todo_list
    @todo.destroy
    redirect_to todo_list, notice: "Todo was successfully deleted."
  end

  def toggle
    @todo.toggle_completion!
    redirect_to @todo.todo_list, notice: "Todo status was toggled."
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to todo_lists_path, alert: "Todo not found."
  end

  def set_todo_list
    @todo_list = current_user.todo_lists.find(params[:todo_list_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to todo_lists_path, alert: "Todo list not found."
  end

  def todo_params
    params.require(:todo).permit(:description, :completed)
  end
end
