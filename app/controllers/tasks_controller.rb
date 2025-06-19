class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy, :toggle]

  def index
    @tasks = Task.order(created_at: :desc)
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to root_path, notice: 'Task added successfully.'
    else
      render :index
    end
  end

  def edit
  @task = Task.find(params[:id])
end

  def update
    if @task.update(task_params)
      redirect_to root_path, notice: 'Task updated.'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to root_path, notice: 'Task deleted.'
  end

  def toggle
    @task.update(completed: !@task.completed)
    redirect_to root_path
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :completed)
  end
end
