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
    user_params = params.require(:user).permit :email, :password, :password_confirmation
    @user = Spree.user_class.new user_params
    if @user.save
      @user.generate_spree_api_key!
      render 'show'
    else
      invalid_resource! @user
    end
  end

  def sign_in
    @user = Spree.user_class.find_by! email: params[:user][:email]
    if @user.valid_password? params[:user][:password]
      @user.generate_spree_api_key! if @user.spree_api_key.blank?
      render 'show'
    else
      unauthorized
    end
  end
end
