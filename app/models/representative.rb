class Representative < ApplicationRecord
  belongs_to :district
  has_one :state, through: :district
  has_many :appointments, as: :congressperson

  def full_name
    self.first_name + " " + self.last_name
  end
end
