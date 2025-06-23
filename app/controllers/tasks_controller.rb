class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :destroy, :toggle]

  def index
    @task = Task.new
    @grouped_tasks = current_user.tasks.order(created_at: :desc).group_by do |task|
      task.created_at.strftime("%B %Y")  
    end
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to root_path, notice: 'Task added successfully.'
    else
      render :index
    end
  end

  def edit
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
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :completed)
  end
end
