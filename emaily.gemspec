SPEC = Gem::Specification.new do |s| 
  s.name = "emaily"
  s.version = "0.1"
  s.author = "Matias P. Brutti"
  s.email = "matiasbrutti@gmail.com"
  s.homepage = "http://freedomcoder.com.ar/emaily"
  s.platform = Gem::Platform::RUBY
  s.summary = "A library to send template to multiple emails."
  s.files = Dir["lib/**/*.*"] + Dir["bin/**/*.*"] + Dir["templates/**/*.*"]
  %w{emaily emaily_genlist qp_decoder}.each do |command_line_utility|
    s.executables << command_line_utility
  end
  s.require_path = "lib"
  s.has_rdoc = true 
  s.extra_rdoc_files = ["README"] 
  s.add_dependency("mail", ">= 2.1.2")
end
