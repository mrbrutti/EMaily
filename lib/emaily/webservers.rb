require 'webrick'
include WEBrick
class CustomScanningServer < HTTPServlet::AbstractServlet
  def do_GET(req, resp)
      resp.body = ""
  end
end

module EMaily
  class WebServers
    LOG_FORMAT = "|| %h || %p || %U || %{User-agent}i"
    def initialize(ports)
      @ports = ports
      @log = Dir::pwd + "/emaily_webserver_#{Time.now.to_s.gsub(/ |:|-/,"")}.log"
      @data = []
      @path = Dir::pwd
    end
    attr_accessor :path
    
    def create_scan_server
      @server = WEBrick::HTTPServer.new(:Port => @ports[0],
                :AccessLog => [[$stdout, LOG_FORMAT], [Log.new(@log), LOG_FORMAT]])
      @ports[1..-1].each {|p| @server.listen("0.0.0.0", p)}
      @server.mount("/*", CustomScanningServer)
      trap("INT") do 
        stop
        parsedata(File.read(@log).scan(/\|\| (.*) \|\| (.*) \|\| (.*) \|\| (.*)/))
      end
    end
    
    def create_server
      @server = WEBrick::HTTPServer.new(:Port => @ports[0], :DocumentRoot => @path,
                :AccessLog => [[$stdout, LOG_FORMAT], [Log.new(@log), LOG_FORMAT]])
      @ports[1..-1].each {|p| @server.listen("0.0.0.0", p)}
      trap("INT") do 
        stop
        sleep(1)
        parsedata (File.read(@log).scan(/\|\| (.*) \|\| (.*) \|\| (.*) \|\| (.*)/))
      end
    end
    
    def run
      @server.start
    end
    
    def stop
      @server.shutdown
    end
        
    private
    def parsedata(data)
      # Print list of Ports matching IP to Email
      puts "Open Ports\n"
      puts "------------"
      ports = data.map {|d| d[1]}.uniq
      ports.each do |port|
        puts "Port #{port}"
        data.select {|d| d[1] == port}.each do 
          puts "\t#{data[0]} => #{data[2].to_s.scan(/\?e=(.*)/).to_s}\n"
        end
      end
      #Print list of Users-Agents discovered
      puts "User-Agents\n"
      puts "-------------"
      data.map { |d| d[1]}.uniq.each {|ua| puts ua}
      
      #Print list of email addresses that responded to attack.
      puts "Emails:"
      data.map { |d| d[2].scan(/\?e=(.*)/).to_s}.uniq.each {|e| puts e}
      
      puts "\n\nFull Access Log data is available on #{@log}\n"
    end
  end
end