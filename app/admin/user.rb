ActiveAdmin.register User do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :email, :password, :password_confirmation, :time_zone, :dealer_Name,:address,:city,:state,:zip,:bond_Number,:dealer_Number,:reseller_Number,:primary_Phone,:mobile_Phone_Number,:mobile_Phone_Carrier, :receiveemai,:referredby
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end

       