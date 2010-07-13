SPEC = Gem::Specification.new do |s| 
  s.name = "emaily"
  s.version = "0.3"
  s.author = "Matias P. Brutti"
  s.email = "matiasbrutti@gmail.com"
  s.homepage = "http://freedomcoder.com.ar/emaily"
  s.platform = Gem::Platform::RUBY
  s.summary = "A library to send template to multiple emails."
  s.files = Dir["lib/**/*.*"] + Dir["bin/**/*.*"] + Dir["templates/**/*.*"]
  %w{emaily emaily_genlist emaily_web emaily_webserver qp_decoder}.each do |command_line_utility|
    s.executables << command_line_utility
  end
  s.require_path = "lib"
  s.has_rdoc = false 
  s.extra_rdoc_files = ["README"] 
  s.add_dependency("mail", ">= 2.1.2")
  s.add_dependency("socksify", ">=1.1.1") # Needed for Tor or other Proxy options
end
