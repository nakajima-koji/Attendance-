class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to root_url
      remember.user
      flash[:success] = "新規作成しました。"
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:sucess] = "アカウント情報を更新しました。"
      redirect_to root_url
    else
      render :edit
    end
  end
  
  def destroy
    
  end
  
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
    
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
