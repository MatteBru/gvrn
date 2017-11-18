class District < ApplicationRecord
  belongs_to :state
  has_many :senators, through: :state
  has_one :representative

  def fancy
    if self.name != "At-Large"
      self.name.to_i.ordinalize + " District"
    else
      "At-Large"
    end
  end
end
