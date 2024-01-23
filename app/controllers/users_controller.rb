class UsersController < ApplicationController
	def index
    @users = User.all.as_json
    @total_users = User.count

    liquid_template = Liquid::Template.parse(File.read('app/views/users/index.liquid'))
    @rendered_content = liquid_template.render('users' => @users, 'total_users' => @total_users)

    # render html: rendered_content.html_safe
  end

  def daily_records
    @daily_records = DailyRecord.all.as_json

    liquid_template = Liquid::Template.parse(File.read('app/views/users/daily_records.liquid'))
    @rendered_content = liquid_template.render('daily_records' => @daily_records)

    # render html: rendered_content.html_safe
  end

   def search
    if params[:search].present?
      query = params[:search].downcase
      @users = User.where("LOWER(name->>'first') LIKE ? OR LOWER(name->>'last') LIKE ?", "%#{query}%", "%#{query}%")
    else
      @users = {}
    end
    @users_found= @users.count
    liquid_template = Liquid::Template.parse(File.read(Rails.root.join('app', 'views', 'users', 'search.liquid')))
    @rendered_content = liquid_template.render('users' => @users.as_json,'users_count' => @users_found,'query' =>params[:search].downcase)
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      head :no_content
    else
      head :unprocessable_entity
    end
  end
end
