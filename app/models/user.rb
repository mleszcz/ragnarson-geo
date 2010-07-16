class User < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  acts_as_authentic
  acts_as_mappable :default_units => :kms

  before_update :geocode_address

  private
    def geocode_address
      geo = Geocoders::MultiGeocoder.geocode(request.remote_ip)
      self.lat, self.lng = geo.lat, geo.lng if geo.success
    end
end
