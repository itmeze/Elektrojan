# Load the rails application
Encoding.default_internal = 'UTF-8'
Encoding.default_external = 'UTF-8'

require File.expand_path('../application', __FILE__)

# Initialize the rails application
Elektrojan::Application.initialize!
