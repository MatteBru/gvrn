class State < ApplicationRecord
  has_many :senators
  has_many :districts
  has_many :representatives, through: :districts

  def junior_senator
    self.senators.where(in_office: true, state_rank: "junior").first || self.senators.find{|s| s != self.senior_senator}
  end

  def senior_senator
    self.senators.where(in_office: true, state_rank: "senior").first
  end

  def alphabetic_reps
    self.representatives.order("first_name ASC")
  end

end
