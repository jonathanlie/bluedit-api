class User < ApplicationRecord
  has_many :identities, dependent: :destroy
  has_many :subbluedits, dependent: :destroy
  has_many :posts, dependent: :destroy
end
