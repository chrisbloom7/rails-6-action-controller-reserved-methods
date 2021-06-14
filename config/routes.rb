Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Generate routes for each new controller generated in
  # config/initializers/generate_controllers.rb
  ActionController::Base.instance_methods.each do |method_name|
    next unless method_name.to_s =~ /\A[a-z]\w*[a-z]\z/

    kontroller_name = "#{method_name.to_s.camelize}Test"

    get "/test_#{method_name}/#{method_name}",
      controller: kontroller_name.underscore,
      action: method_name

      get "/test_#{method_name}/nothing_special",
      controller: kontroller_name.underscore,
      action: :nothing_special
  end
end
