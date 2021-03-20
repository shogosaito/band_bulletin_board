class Like < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  counter_culture :micropost
end
