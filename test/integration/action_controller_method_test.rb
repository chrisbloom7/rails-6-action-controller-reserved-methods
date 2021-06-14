require "test_helper"

class ActionControllerMethodTest < ActionDispatch::IntegrationTest
  ActionController::Base.instance_methods.each do |method_name|
    next unless method_name.to_s =~ /\A[a-z]\w*[a-z]\z/

    kontroller_name = "#{method_name.to_s.camelize}Test"

    test "call `:#{method_name}` as action name" do
      get "/test_#{method_name}/#{method_name}"
      assert_response :success
      assert_equal method_name.to_s, @response.body
    end

    test "if `:#{method_name}` is called indirectly" do
      get "/test_#{method_name}/nothing_special"
      assert_response :success
      assert_equal "nothing_special", @response.body
    end
  end
end
