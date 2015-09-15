Spree::CheckoutController.class_eval do

  before_filter :set_user, only: [:registration, :update_registration]

  helper_method :valid_email?

  def registration
  end

  def update_registration
    case
    when !valid_email?
      @user.validate
    when @user.email != user_params[:previous_email]
    when user_params[:password] == ''
      current_order.update_attribute(:email, @user.email)
      return redirect_to spree.checkout_path
    when @user.persisted?
      if @user.valid_password?(user_params[:password])
        sign_in_and_associate
        return redirect_to spree.checkout_path
      end
      @user.errors.add(:password, 'is incorrect')
    when @user.save
      sign_in_and_associate
      return redirect_to spree.checkout_path
    end
    render 'registration'
  end

  private

  def sign_in_and_associate
    sign_in(:spree_user, @user)
    associate_user
  end

  def valid_email?
    @user.email =~ Devise.email_regexp
  end

  def set_user
    email = user_params.fetch(:email, @order.email)
    @user = Spree::User.find_or_initialize_by(email: email)
  end

  def user_params
    params.fetch(:spree_user, {})
  end

end
