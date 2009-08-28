require 'rack'

# = CodeRay Syntax Highlighter Rack Appliance
#
# Rack::Coderay parses text/html markup and replaces code with output
# from the CodeRay gem (http://coderay.rubychan.de/), producing syntax highlighting. 
# By default, this component looks for <pre lang="xxxx">...</pre>
# blocks, where 'xxxx' is any of the languages supported by CodeRay (e.g. 'ruby'). 
# See http://coderay.rubychan.de/doc/classes/CodeRay/Scanners.html
#
# You can re-configure Rack::Coderay to look for a different trigger 
# but it needs to have a 'lang' attribute.
#
# === Usage
#
# Within a rackup file (or with Rack::Builder):
#   require 'rack/coderay'
#   use Rack::Coderay
#   run app
#
# Rails example:
#   # above Rails::Initializer block
#   require 'rack/coderay'
#
#   # inside Rails::Initializer block 
#   config.middleware.use Rack::Coderay
#
# To override the default markup trigger (<pre lang="xxxx">), you
# can pass in a css or xpath selector as the second argument:
#
#   config.middleware.use Rack::Coderay, "//div[@lang]"
#
# To set additional CodeRay gem options, pass a hash as the third argument:
#
#   config.middleware.use Rack::Coderay, 
#     "//pre[@lang]", 
#     :line_numbers => :table
module Rack::Coderay
  autoload :Parser, 'rack/coderay/parser'
    
  # Create a new Rack::Coderay middleware component that automatically
  # highlights syntax using the CodeRay gem.
  def self.new(backend, markup_trigger = "//pre[@lang]", options = {})
    Parser.new(backend, markup_trigger, options)
  end
end