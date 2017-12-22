json.extract! review, :id, :approved, :user_id, :comment, :rating, :created_at, :updated_at
json.url review_url(review, format: :json)
