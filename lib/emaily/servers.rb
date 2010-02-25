require 'yaml'

module EMaily
  class Servers
    SERVERS_PATH = ENV["HOME"] + "/.emaily_servers"
    
    def initialize
      File.exist?(SERVERS_PATH) ? @servers = YAML.load_file(SERVERS_PATH) : @servers = []
    end
    
    def create(name, values = {})   
      @servers << {:name => name, :values => values }
    end

    def delete(arg)
      @servers.delete_if {|x| x[:name] == arg }
    end
    
    def select_server(arg)
      @servers.select {|x| x[:name] == arg}
    end
    
    def [](arg)
      select_server(arg)
    end
    
    def self.load
      self.new
    end

    def flush
      File.open(SERVERS_PATH, 'w') { |f| f.puts(YAML::dump(@servers)) }
    end
  end
end
