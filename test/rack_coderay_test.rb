require 'test_helper'

class RackCoderayTest < Test::Unit::TestCase

  def get_response(path, body, markup_trigger = "//pre[@lang]", options = {})
    app = Rack::Builder.new do
      use Rack::Coderay, markup_trigger, options
      run lambda { |env| [200, {'Content-Type' => 'text/html'}, [body] ] }
    end
    Rack::MockRequest.new(app).get(path)
  end

  context "Rack::Coderay" do
    context "with default options" do
      setup do
        @response = get_response('/', %Q{
          <pre lang="ruby">
            class Foo
              def bar
              end
            end
          </pre>})
      end
      should "replace markup with CodeRay formatting" do
        assert @response.body.include?(%Q{<div class="CodeRay">})
      end
    end
    
    context "with markup trigger set to a non-matching tag" do
      setup do
        @response = get_response('/', %Q{
          <pre lang="ruby">
            class Foo
              def bar
              end
            end
          </pre>}, '//div[@lang]')
      end
      should "not replace markup with CodeRay formatting" do
        assert @response.body.include?(%Q{<pre lang="ruby">})
      end
    end
        
    context "with markup trigger set to //div[@lang]" do
      setup do
        @response = get_response('/', %Q{
          <div lang="ruby">
            class Foo
              def bar
              end
            end
          </div>}, '//div[@lang]')        
      end
      should "replace markup with CodeRay formatting" do
        assert @response.body.include?(%Q{<div class="CodeRay">})
      end
    end
    
    context "with :css property set to :style" do
      setup do
        @response = get_response('/', %Q{
          <pre lang="ruby">
            class Foo
              def bar
              end
            end
          </pre>}, "//pre[@lang]", :css => :style)
      end
      should "replace markup with CodeRay formatting and use embedded styles" do
        assert @response.body.include?(%Q{<span style="color:#080;font-weight:bold">})
      end
    end

    context "with different order of attributes in markup trigger" do
      setup do
        @response = get_response('/', %Q{
          <pre class="blah" lang="json">
            { "just": "an", "example": 42 }
          </pre>})
      end
      should "replace markup with CodeRay formatting" do
        assert @response.body.include?(%Q{<div class="CodeRay">})
      end
    end
      
    context "with lang set to json" do
      setup do
        @response = get_response('/', %Q{
          <pre lang="json">
            { "just": "an", "example": 42 }
          </pre>})
      end
      should "replace markup with CodeRay formatting" do
        assert @response.body.include?(%Q{<div class="CodeRay">})
      end
    end
    
    context "when markup trigger is missing 'lang' attribute" do
      should "raise a RuntimeError exception " do
        assert_raise(RuntimeError) {  
          @response = get_response('/', 'blah', '//pre')
        }
      end
    end
  end
end