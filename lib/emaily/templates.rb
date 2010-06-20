####
#### Values in templates are represented by %%value%%.
#### for example %%name%%
####

module EMaily
  class Template
    def initialize(template, content_type, ports=nil, site=nil)
      file = File.readlines(template)
      if file[0].match(/<subject>/)
        @s = file[0].scan(/<subject>(.*)<\/subject>/)[0][0]
        @templete=file[1..-1].to_s
      else
        @templete = file.to_s
      end
      @c = content_type
      if ports
        @port = ports
      else @templete.match(/%%payload\[(.*)\]%%/) !=nil
        @ports = @templete.scan(/%%payload\[(.*)\]%%/)[0][0].split(",").map {|p| p.to_i}
      end
      @site = site
    end
    attr_accessor :ports, :bidly
    attr_reader :site
    
    def generate_email(values)
      email = @templete.clone
      D "Creating Email for #{values[:email]}" if values[:email]
      email.scan(/(%%.*%%)/).each {|x| email.gsub!(/(#{x[0]})/) {|s| values[s.to_s[2...-2].to_sym]}}
      email.gsub!(/%%payload\[.*\]%%/) { |pl| generate_scan_ports(values[:email])}
      email
    end
    
    # Method not used yet. It will be used when needed :)
    def generate_email_with_scan(values)
      email = generate_email(values)
      email.gsub!(/(<\/body>)/) {|s| "#{scan_ports(@ports, values[:email])}" + s }
    end
        
    def is_text?
      @c.match(/text\/plain/) != nil ? true : false
    end
    
    def is_html?
      @c.match(/text\/html/) != nil ? true : false
    end
        
    def site=(url)
      @site = url.match(/http/) ? url : "http://#{url}"
    end
    
    def subject
      @s || nil
    end
    
    private
    
    def generate_scan_ports(identifier)
      pl = ""
      @ports.each do |port|
        pl << "<img src=\"#{site(port,identifier)}\" style=\"display:none\"/>\n"
      end
      pl
    end
    
    def site(port,identifier)
      url = "#{ @site || ("http://"+local_ip) }:#{port}/#{port}.jpg?e=#{identifier}"
      begin
        @bidly ? bidly(url) : url
      rescue
        url
      end
    end
    
    # Future bitly URL shortten to hide Scan URLs ( I think this will only work with domains)
    def bitly(link)
      open( 'http://bit.ly/api?url=' + link ).read
    end
    
    def local_ip
      if @local_ip
        @local_ip
      else
        require 'socket'
        orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
        UDPSocket.open do |s|
          s.connect '8.8.8.8', 1
          @local_ip = s.addr.last
        end
      end
    ensure
      Socket.do_not_reverse_lookup = orig
    end
  end
end