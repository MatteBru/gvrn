class Senator < ApplicationRecord
  belongs_to :state
  has_many :appointments, as: :congressperson

  def full_name
    self.first_name + " " + self.last_name
  end
end
