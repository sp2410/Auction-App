class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :time_zone, :dealer_Name,:address,:city,:state,:zip,:bond_Number,:dealer_Number,:reseller_Number,:primary_Phone,:mobile_Phone_Number,:mobile_Phone_Carrier,:receiveemail,:referredby)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :time_zone, :dealer_Name,:address,:city,:state,:zip,:bond_Number,:dealer_Number,:reseller_Number,:primary_Phone,:mobile_Phone_Number,:mobile_Phone_Carrier,:receiveemail,:referredby)
  end
end
