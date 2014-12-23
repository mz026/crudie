class ProjectsController < ApplicationController
  include Crudie
  crudie :project
          
  def crudie_context
    User.find(params[:user_id]).projects
  end

  def crudie_params
    params.require(:project).permit(:name)
  end
end
