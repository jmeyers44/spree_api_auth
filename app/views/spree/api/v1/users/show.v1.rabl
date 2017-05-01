object @user

attributes *user_attributes, :spree_api_key
child(:bill_address => :bill_address) do
  extends "spree/api/addresses/show"
end

child(:ship_address => :ship_address) do
  extends "spree/api/addresses/show"
end