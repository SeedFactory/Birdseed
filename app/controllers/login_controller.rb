class LoginController < Spree::BaseController

  include Spree::Core::ControllerHelpers::Order

  before_filter :set_user, only: [:new, :create]

  helper_method :valid_email?, :reset_password?

  def new
  end

  def create
    case
    when !valid_email?
      @user.validate
    when @user.email != user_params[:previous_email]
    when @user.persisted? && reset_password?
      @user.send_reset_password_instructions
    when @user.persisted?
      if @user.valid_password?(user_params[:password])
        sign_in_and_associate
        return redirect_to Rails.application.routes.url_helpers.shop_path
      end
      @user.errors.add(:password, 'is incorrect')
    when @user.save
      sign_in_and_associate
      return redirect_to Rails.application.routes.url_helpers.shop_path
    end
    render 'new'
  end

  private

  def reset_password?
    params.key?(:reset_password)
  end

  def sign_in_and_associate
    sign_in(:spree_user, @user)
    associate_user
  end

  def valid_email?
    @user.email =~ Devise.email_regexp
  end

  def set_user
    @user = Spree::User.find_or_initialize_by(email: user_params[:email])
  end

  def user_params
    params.fetch(:spree_user, {})
  end

end
