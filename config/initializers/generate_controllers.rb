# Generates a new controller for each instance method on ActionController::Base
ActionController::Base.instance_methods.each do |method_name|
  next unless method_name.to_s =~ /\A[a-z]\w*[a-z]\z/

  kontroller_name = "#{method_name.to_s.camelize}Controller".intern
  Object::const_set(kontroller_name, Class.new(ActionController::Base) do
    # Redefine the reserved method as an action method
    define_method(method_name) do
      render plain: method_name.to_s
    end

    # This is a control. It will most likely resolve in the same way that
    # calling the redefined reserved method as an action will, but this tests
    # what happens if the redefined reserved method ia called inderectly via
    # the normal render process.
    def nothing_special
      render plain: "nothing_special"
    end
  end)
end
