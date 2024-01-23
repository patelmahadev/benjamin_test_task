class DailyRecord < ApplicationRecord
	include ActiveModel::Dirty

  after_save :calculate_average_ages, if: :saved_change_to_male_count? || :saved_change_to_female_count?

  private

  def calculate_average_ages
  	users = User.where(created_at: self.date.beginning_of_day..self.date.end_of_day)
  	male_avg_age = users.where(gender: 'male').average(:age)
  	female_avg_age = users.where(gender: 'female').average(:age)

    self.update(
      male_avg_age: male_avg_age,
      female_avg_age: female_avg_age
    )
  end
end
