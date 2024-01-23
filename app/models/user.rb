class User < ApplicationRecord
	validates :uuid, uniqueness: true
	before_destroy :update_daily_record

  private

  def update_daily_record
    daily_record = DailyRecord.find_by(date: created_at.to_date)
    if daily_record.present?
    	if gender == "male"
	    	daily_record.update(male_count: daily_record.male_count - 1)
	    else
	    	daily_record.update(female_count: daily_record.female_count - 1)
	    end
	  elsif created_at.to_date == Date.today
	  	if gender == "male"
	  		male_count = REDIS.get('male_count').to_i
	  		REDIS.set('male_count', male_count-1) if male_count > 0
	  	else
    		female_count = REDIS.get('female_count').to_i
    		REDIS.set('female_count', female_count-1) if female_count > 0
    	end
	  end
  end
end
