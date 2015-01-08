class UsersController < ApplicationController
  include Crudie 
  crudie :user

  def crudie_context
    User.all
  end

  def crudie_params
    params.require(:user).permit(:name)
  end
end
