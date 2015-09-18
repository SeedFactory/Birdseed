Spree::UserPasswordsController.class_eval do

  def update
    password = params[:spree_user][:password]
    if password.blank?
      @spree_user = Spree::User.new(
        reset_password_token: params[:spree_user][:reset_password_token])
      @spree_user.errors.add(:password, "can't be blank")
      render :edit
    else
      params[:spree_user][:password_confirmation] = password
      super
    end
  end

end
