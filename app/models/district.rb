class District < ApplicationRecord
  belongs_to :state
  has_many :senators, through: :state
  has_one :representative
end
