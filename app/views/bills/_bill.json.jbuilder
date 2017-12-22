json.extract! bill, :id, :new, :bill_id, :ip_address, :first_name, :last_name, :card_type, :card_expires_on, :created_at, :updated_at
json.url bill_url(bill, format: :json)
