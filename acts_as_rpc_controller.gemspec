Gem::Specification.new do |s|
  s.name        = 'acts_as_rpc_controller'
  s.version     = '0.0.1'
  s.date        = '2014-03-13'
  s.summary     = "Acts as RPC Controller"
  s.description = "Support for building RPC services in Rails"
  s.authors     = ["Lars Göransson"]
  s.email       = 'lars.goransson@kentor.se'
  s.files       = [].tap do |fs|
    fs << "lib/acts_as_rpc_controller.rb"
    fs << "lib/aarpcc/controller_support.rb"
    fs << "lib/aarpcc/action_support.rb"
    fs << "lib/aarpcc/errors.rb"
    fs << "lib/aarpcc/validators.rb"
    fs << "lib/aarpcc/integration_test_support.rb"
  end
  s.homepage    = 'https://github.com/kentorgbg/acts_as_rpc_controller'
  s.license     = 'MIT'
end