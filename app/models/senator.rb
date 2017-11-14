class Senator < ApplicationRecord
  belongs_to :state

  def full_name
    self.first_name + " " + self.last_name
  end
end
