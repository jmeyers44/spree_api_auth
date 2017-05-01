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
    @user = Spree.user_class.find_by_email(params[:user][:email])
    render 'spree/api/v1/users/user_exists', status: 401 and return if @user.present?

    user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    @user = Spree.user_class.new(user_params)
    unless @user.save
      unauthorized
      return
    end
    @user.generate_spree_api_key!
  end

  def sign_in
    @user = Spree.user_class.find_by_email(params[:user][:email])
    if !@user.present? || !@user.valid_password?(params[:user][:password])
      unauthorized
      return
    end
    @user.generate_spree_api_key! if @user.spree_api_key.blank?
  end
end
