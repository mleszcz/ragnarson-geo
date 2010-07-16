RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.gem 'authlogic', :version => '2.1.5'
  config.gem 'geokit', :version => '1.5.0'
  config.gem 'will_paginate', :version => '~> 2.3.12', :source => 'http://gemcutter.org'  

  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_blog_session',
    :secret      => 'f3f57b71ef9345ffccd0c4e841d8e74bb2e7d2ef692a5303bb455fea0667a62d30458d17f95766b12906aa6c2a3c29d584a55dd18426ffc04610be49956a51af'
  }

end
