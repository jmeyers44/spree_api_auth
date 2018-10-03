users_controller = Spree::Api::V1::UsersController
Spree::Api::V1.const_set :UsersController, Spree::Api::UsersController if users_controller.name == 'Spree::Api::UsersController'

Spree::Api::V1::UsersController.class_eval do
  before_action :authenticate_user, :except => [:sign_up, :sign_in]
  prepend_before_action :allow_params_authentication!, only: :sign_in

  def sign_up
    user_params = params.require(:spree_user).permit :email, :password, :password_confirmation
    @user = Spree.user_class.new user_params
    if @user.save
      @user.generate_spree_api_key!
      render 'show'
    else
      invalid_resource! @user
    end
  end

  def sign_in
    if warden.authenticate scope: :spree_user
      @user = warden.user scope: :spree_user
      @user.generate_spree_api_key! if @user.spree_api_key.blank?
      render 'show'
    else
      render 'invalid', status: 401
    end
  end

  def recover
    @user = Spree.user_class.find_by_email(user_params[:email])
    if @user.present?
     @user.send_reset_password_instructions
    end
    render json: {status: true}
  end

  def me
    @user = current_api_user
    if @user.present?
      respond_with(@user, default_template: :show)
    else
      render 'invalid', status: 401
    end
  end
end
