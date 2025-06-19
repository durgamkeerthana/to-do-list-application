class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy, :toggle]

  def index
    @tasks = Task.order(created_at: :desc)
    @task = Task.new
     @grouped_tasks = Task.order(created_at: :desc).group_by do |task|
    date = task.created_at.to_date
    if date == Date.today
      "Today, #{date.strftime('%B %d, %Y')}"
    elsif date == Date.yesterday
      "Yesterday, #{date.strftime('%B %d, %Y')}"
    elsif date.cweek == Date.today.cweek && date.year == Date.today.year
      "This Week, #{date.strftime('%B %d, %Y')}"
    elsif date.year == Date.today.year
      date.strftime("%B %Y") # e.g., June 2025
    else
      date.strftime("%B %d, %Y") # e.g., May 14, 2024
    end
  end
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
