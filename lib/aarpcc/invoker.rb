class AARPCC::Invoker

  def initialize(action_class)
    @action_class = action_class
  end

  def invoke(request, response)
    action = @action_class.new
    validate_request_method(request)
    validate_declared_params_given(request)
    validate_given_params_declared(request)
    decoded_params = decode_params(request)
    validate_param_types(decoded_params)
    assign_params(action, decoded_params)
    action.execute
  end

  def assign_params(action, decoded_params)
    action.params = {}.with_indifferent_access
    decoded_params.each do |name, value|
      action.params[name] = value
    end
  end

  def validate_request_method(request)
    declared_request_method = action_declaration.get_request_method
    request_method          = request.method.to_s.strip.downcase.to_sym
    raise AARPCC::Errors::MethodNotAllowed.new unless request_method == declared_request_method
  end

  def validate_declared_params_given(request)
    action_declaration.parameter_declarations.each do |name, decl|
      next if request.params.has_key? name
      raise AARPCC::Errors::BadRequest.new("Missing parameter '#{name}'")
    end
  end

  def validate_given_params_declared(request)
    request.params.each do |name, value|
      next if name.to_sym == :controller
      next if name.to_sym == :action
      next if action_declaration.parameter_declarations.has_key? name
      raise AARPCC::Errors::BadRequest.new("Undeclared parameter '#{name}'")
    end
  end

  def decode_params(request)
    {}.tap do |result|
      request.params.each do |name, value|
        next if name.to_sym == :controller
        next if name.to_sym == :action
        result[name] = decode_param(name, value)
      end
    end
  end

  def decode_param(name, value)
    ActiveSupport::JSON::decode(value)
  rescue MultiJson::ParseError => e
    raise AARPCC::Errors::BadRequest.new("'#{name}': #{e.message}")
  end

  def validate_param_types(decoded_params)
    decoded_params.each do |name, value|
      pdecl = action_declaration.parameter_declarations[name]
      pdecl.validator.validate(name, value)
    end
  end


  def action_declaration
    @action_class.action_declaration
  end
end