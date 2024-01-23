class HourlyJobWorkerJob
  include Sidekiq::Job

  def perform
    response = HTTParty.get('https://randomuser.me/api/?results=20')
    data = JSON.parse(response.body)['results']

    data.each do |user_data|
      user = User.find_or_initialize_by(uuid: user_data['login']['uuid'])
      user.attributes = {
        name: user_data["name"],
        age: user_data['dob']['age'],
        gender: user_data['gender'],
        location: user_data['location']
      }
      user.save
    end

    update_gender_counts
  end

  private

  def update_gender_counts
    today_users = User.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
    male_count = today_users.where(gender: 'male').count
    female_count = today_users.where(gender: 'female').count

    REDIS.set('male_count', male_count)
    REDIS.set('female_count', female_count)
  end
end
