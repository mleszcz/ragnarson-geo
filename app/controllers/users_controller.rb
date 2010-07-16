class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end

  def free
    if admin_user
      session[:origin] = nil
      redirect_to users_url
    else
      flash[:notice] = "Must be an admin."
      redirect_to root_url      
    end
  end

  def index
    if admin_user
      session[:distance] ||= 50
      
      search_hash = Hash.new
      search_hash[:page] = params[:page]
      search_hash[:order] = 'created_at DESC'
      search_hash[:conditions] = "username <> 'admin'"

      if session[:origin].present?
        search_hash[:origin] = session[:origin][:address]
        search_hash[:within] = session[:distance]
      end

      @users = User.paginate search_hash
      @users_all = User.find(:all, :conditions => "username <> 'admin'").size
    else
      flash[:notice] = "Must be an admin."
      redirect_to root_url
    end
  end

  def showtime
    if request.xhr?
      if admin_user
        lat, lng = params[:location]['latitude'], params[:location]['longitude']
        revers = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{lat},#{lng}"

        if revers.success
          next_id = User.find_by_sql("SELECT MAX(id)+1 AS next_id FROM users")[0].next_id

          User.create :username               => "user_#{next_id}",
                      :email                  => "user#{next_id}@email.com",
                      :password               => "userpassword",
                      :password_confirmation  => "userpassword",
                      :lat                    => lat,
                      :lng                    => lng,
                      :address                => revers.full_address

          @flash = "<b>User created</b><br /><br />Aprox. user address:<br /> #{revers.full_address}"
        else
          @flash = "Unknown location, please mark it again"
        end
        @back_url = users_url
      else
        @flash = "You must be logged in"
        @back_url = root_url
      end

      render 'ajax_response'
    else
      if admin_user
        render 'showtime'
      else
        flash[:notice] = "You must be an admin."
        redirect_to root_url
      end
    end
  end

  def mark
    if request.xhr?
      if current_user
        lat, lng = params[:location]['latitude'], params[:location]['longitude']
        revers = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{lat},#{lng}"
        if revers.success
          current_user.lat = lat
          current_user.lng = lng
          current_user.address = revers.full_address
          current_user.send(:update_without_callbacks)

          @flash = "<b>Location updated!</b><br /><br />Aprox. address of your new location is:<br /> #{revers.full_address}"
        else
          @flash = "Unknown location, please mark it again"
        end
      else
        @flash = "You must be logged in"
      end

      @back_url = root_url
      render 'ajax_response'
    else
      if current_user
        @title = "Mark you location"
        @ajax_action = :mark

        render 'mark'
      else
        flash[:notice] = "Log in please."
        redirect_to root_url
      end
    end
  end

  def origin
    if request.xhr?
      if admin_user
        lat, lng = params[:location]['latitude'], params[:location]['longitude']
        revers = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{lat},#{lng}"
        if revers.success
          session[:origin] = Hash.new
          session[:origin][:lat] = lat
          session[:origin][:lng] = lng
          session[:origin][:address] = revers.full_address

          @flash = "<b>Origin saved!</b><br /><br />Aprox. address of the origin is:<br /> #{revers.full_address}"
        else
          @flash = "Unknown location, please mark it again or..."
        end
        @back_url = users_url
      else
        @flash = "You must be an admin."
        @back_url = root_url
      end

      render 'ajax_response'
    else
      if admin_user
        @title = "Mark the origin"
        @ajax_action = :origin

        render 'mark'
      else
        flash[:notice] = "Must be an admin."
        redirect_to root_url
      end
    end
  end

  def distance
    d = params[:distance].to_i
    if d > 0 and d <= 1000
      session[:distance] = d
      flash[:notice] = "Distance updated."
    else
      flash[:error] = "Wrong distance, please enter 1-1000 value."
    end

    redirect_to users_url
  end

end
