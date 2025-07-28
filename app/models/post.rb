class Post < ApplicationRecord
  belongs_to :user
  belongs_to :subbluedit

  validates :title, presence: true
  validates :body, presence: true

  # id: uuid
  self.primary_key = :id
end
