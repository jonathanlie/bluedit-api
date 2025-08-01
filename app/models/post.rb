class Post < ApplicationRecord
  belongs_to :user
  belongs_to :subbluedit
  has_many :comments, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  # id: uuid
  self.primary_key = :id
end
