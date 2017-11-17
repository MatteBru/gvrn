class Representative < ApplicationRecord
  belongs_to :district
  has_one :state, through: :district
  has_many :appointments, as: :congressperson, dependent: :destroy

  def full_name
    self.first_name + " " + self.last_name
  end

  def calculate_age
    time_diff_components = Time.diff(Time.now, self.date_of_birth)
    time_diff_components[:year]
  end

  def get_start_year
    if self.start_date
      self.start_date.year
    else
      "N/A"
    end
  end

  def interpret_dw_nominate_score
    case self.dw_nominate
    when -1.0...-0.5
      ["solid", "liberal"]
    when -0.5...-0.3
      "liberal"
    when -0.3...-0.1
      ["moderate", "liberal"]
    when -0.1...0.1
      "centrist"
    when 0.1...0.3
      ["moderate", "conservative"]
    when 0.3...0.5
      "conservative"
    when 0.5..1.0
      ["solid", "conservative"]
    else
      "N/A"
    end
  end
end
