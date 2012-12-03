require 'coderay'
require 'hpricot'

module Rack::Coderay
  # This class is the interface between Rack and the CodeRay gem
  class Parser
    
    # Defaults for the Coderay gem config
    DEFAULT_CODERAY_OPTS = {
      :div => {
        :css => :class
      }
    }

    def initialize(app, markup_trigger, options = {})
      @app = app
      @markup_trigger = markup_trigger
      @options = DEFAULT_CODERAY_OPTS.merge(options)
      raise "Markup trigger must include a 'lang' attribute" if !markup_trigger.include?('lang')
    end
    
    # method required by Rack interface
    def call(env)
      call! env
    end

    # thread safe version using shallow copy of env
    def call!(env)
      @env = env.dup
      status, headers, response = @app.call(@env)
      if !ignored?(env['PATH_INFO']) && headers["Content-Type"] && headers['Content-Type'][%r{text/html}]
        headers.delete('Content-Length')
        response = Rack::Response.new(
                                      response = parse_and_replace(response.respond_to?(:body) ? response.body : response),
                                      status,
                                      headers
                                      )
        response.finish
        response.to_a
      else
        [status, headers, response]
      end
    end
    
    private
    
    def ignored?(path_info)
      @options[:ignore] and @options[:ignore].any? { |filter| path_info[filter] }
    end

    def parse_and_replace(content) #:nodoc:
      doc = Hpricot(content.is_a?(Array) ? content[0] : content.to_s)
      doc.search(@markup_trigger).each do |node|
        node.swap(coderay_render(node.inner_html, node['lang']))
      end
      doc.to_original_html
    end
    
    def coderay_render(text, language) #:nodoc:
      ::CodeRay.scan(text, language.to_sym).div(@options[:div])
    end
  end
end
