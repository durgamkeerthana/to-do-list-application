class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    load_tasks
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      redirect_to tasks_path, notice: "Task created successfully."
    else
      load_tasks
      render :index
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "Task deleted successfully."
  end

  def toggle
    @task = current_user.tasks.find(params[:id])
    
    @task.completed = !@task.completed
    @task.completed_at = @task.completed? ? Time.current : nil
    @task.tagline = nil unless @task.completed?  

    @task.save
    redirect_to tasks_path, notice: "Task status updated."
  end

  private

  def task_params
    params.require(:task).permit(:title, :due_time)
  end

  def load_tasks
    @tasks = Task.where(user: current_user)
    @grouped_tasks = @tasks.group_by { |task| task.due_time.strftime("%B %Y") if task.due_time.present? }
  end
end
