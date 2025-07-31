class User < ApplicationRecord
  has_many :identities, dependent: :destroy
  has_many :subbluedits, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
end
