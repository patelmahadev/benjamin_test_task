require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

# Schedule the job to run every hour
scheduler.every '1h' do
  HourlyJobWorkerJob.perform_async
end

# Schedule the job to run every day
scheduler.every '1d', first_at: '23:55' do
  DailyJobWorkerJob.perform_async
end
