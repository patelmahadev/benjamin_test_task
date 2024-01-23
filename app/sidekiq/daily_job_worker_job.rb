class DailyJobWorkerJob
  include Sidekiq::Job

  def perform
    male_count = REDIS.get('male_count').to_i
    female_count = REDIS.get('female_count').to_i

    # Store counts in DailyRecord table
    daily_record = DailyRecord.find_or_initialize_by(date: Date.today)
    daily_record.attributes = {
      male_count: male_count,
      female_count: female_count
    }
    daily_record.save
    REDIS.flushdb
  end
end
