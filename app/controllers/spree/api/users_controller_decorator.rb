users_controller = begin
  # Spree >= 3.1
  Spree::Api::V1::UsersController
rescue NameError
  # Spree ~> 3.0
  Spree::Api::UsersController
end

users_controller.class_eval do
  before_action :authenticate_user, :except => [:sign_up, :sign_in]

  def sign_up

    @user = Spree::User.find_by_email(params[:user][:email])

    if @user.present?
      render "spree/api/users/user_exists", :status => 401 and return
    end

    user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    @user = Spree::User.new(user_params)
    if !@user.save
      unauthorized
      return
    end
    @user.generate_spree_api_key!
  end

  def sign_in
    @user = Spree::User.find_by_email(params[:user][:email])
    if !@user.present? || !@user.valid_password?(params[:user][:password])
      unauthorized
      return
    end
    @user.generate_spree_api_key! if @user.spree_api_key.blank?
  end
end
