class Subbluedit < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  # id: uuid
  self.primary_key = :id

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
