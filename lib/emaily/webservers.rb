require 'webrick'
include WEBrick

class CustomScanningServer < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(req, resp)
      resp.body = ""
  end
  
  def do_POST(req, resp)
      resp.body = ""
  end
end

module EMaily
  class WebServers
    SHOW_FORMAT = "+ Response from IP %h on port %p"
    LOG_FORMAT = "|| %h || %p || %U || %{User-agent}i"
    def initialize(ports)
      @ports = ports
      @log = Dir::pwd + "/emaily_webserver_#{Time.now.to_s.gsub(/ |:|-/,"")}.log"
      @data = []
      @path = Dir::pwd
    end
    attr_accessor :path
    
    def create_scan_server
      @server = WEBrick::HTTPServer.new(:Port => @ports[0], :ServerType => Thread,
                :Logger => Log.new("/dev/null"),
                :AccessLog => [[$stdout, SHOW_FORMAT], [Log.new(@log), LOG_FORMAT]])
      if @ports.size > 1
        @ports[1..-1].each {|p| @server.listen("0.0.0.0", p)}
      end
      @server.mount("/*", CustomScanningServer)
    end
    
    def create_server
      @server = WEBrick::HTTPServer.new(:Port => @ports[0], :DocumentRoot => @path,
                :ServerType => Thread, :Logger => Log.new("/dev/null"),
                :AccessLog => [[$stdout, SHOW_FORMAT], [Log.new(@log), LOG_FORMAT]])
      if @ports.size > 1
        @ports[1..-1].each {|p| @server.listen("0.0.0.0", p)}
      end
    end
    
    def run
      @server.start
    end
    
    def stop
      @server.shutdown
    end
    
    def parsedata
      # Print list of Ports matching IP to Email
      data = File.read(@log).scan(/\|\| (.*) \|\| (.*) \|\| (.*) \|\| (.*)/)
      puts "Open Ports\n"
      puts "------------"
      ports = data.map {|d| d[1]}.uniq
      ports.each do |port|
        puts "Port #{port}"
        data.select {|d| d[1] == port}.uniq.each { |d| puts "  #{d[0]} => #{d[2].to_s.scan(/\?e=(.*)/).to_s}\n" }
      end
      #Print list of Users-Agents discovered
      puts "User-Agents\n"
      puts "-------------"
      data.map { |d| d[3]}.uniq.each {|ua| puts "  "+ua}
      
      #Print list of email addresses that responded to attack.
      puts "Emails:"
      data.map { |d| d[2].to_s.scan(/\?e=(.*)/).to_s}.uniq.each {|e| puts "  "+e}
      
      puts "\n\nFull Access Log data is available on #{@log}\n"
      EMaily::status = false
    end
  end
end