class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_or_correct_user, only: :show
  before_action :set_one_month, only: :show
  
  def index
    @users = User.paginate(page: params[:page], per_page: 20)
    if params[:name].present?
      @users = @users.get_by_name params[:name]
    end
  end
  
  def new
    @user = User.new
  end
  
  def show
    @worked_sum = @attendance_systems.where.not(started_at: nil).count
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to root_url
      flash[:success] = "新規作成しました。"
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "アカウント情報を更新しました。"
      redirect_to root_url
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:danger] = "ユーザーを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
    else
      flash[:danger] = "更新に失敗しました。"
    end
    redirect_to users_url
  end
  
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end
end
