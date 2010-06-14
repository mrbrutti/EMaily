def D m
  puts m if EMaily::log
end

class Array
  def / len
    a = []
    each_with_index do |x,i|
      a << [] if i % len == 0
      a.last << x
    end
    a
  end
end

module EMaily
  @@log = false
  @@status = true
  VERSION = 0.2
  
  def self.status
    @@status
  end
  
  def self.status=(v)
    @@status=v
  end
  
  def self.log
    @@log
  end
  
  def self.log=(v)
    @@log=v
  end
    
  class Email
    def initialize(args)
      #setup
      EMaily.log = args[:log] if args[:log]
      @servers = Servers.load
      #variables
      @list = CSV.parse(args[:list])
      @attach = args[:attachment] || []
      @o_from = @from = args[:from]
      @content_type = args[:content_type] || 'text/html; charset=UTF-8;'
      @template = Template.new(args[:template], @content_type)
      @template.bidly = args[:bidly] || false
      @ports = @template.ports
      @template.site = args[:site] if args[:site]
      @subject = @template.subject || args[:subject]
      if args[:servers]
        @serv = []; args[:servers].each {|s| @serv << @servers[s][0][:values] }
        setup_server(@serv[0])
      else
        setup_server(@servers[0][0][:values])
      end
    end
    attr_accessor :list, :from, :content_type, :subject, :serv, :ports
    
    def self.start(file, &block)
      self.new(file)
      block.call(self) if block_given?
    end
        
    def send
      @list.each { |p| connect(p[:email], generate_email(p)) }
    end
        
    def send_block(bloc = 1, rest = 0, &block)
      (@list / bloc).each do |b|
        b.each { |p| connect p[:email], generate_email(p) }
        sleep(rest) if rest != 0 && rest != nil
        block.call(self) if block_given?
      end
    end
    
    def send_to_random_servers(bloc = 1, rest = 0)
      send_block(bloc, rest) { setup_server(@serv[rand(@serv.size)]) }
    end
    
    def send_to_servers(bloc = 1, rest = 0)
      @v=0; send_block(bloc, rest) { setup_server(@serv[(@v += 1) % @serv.size]) }
    end
    
    private
    
    def generate_email(data)
      @template.generate_email(data)
    end
    
    def setup_server(server)
      Mail.defaults { delivery_method :smtp, server }
      if @from.nil? || (@from != server[:user_name] && server[:user_name].match(/@/))
        @from = server[:user_name]
      elsif server[:user_name].nil?
        @from = server[:reply_to]
      else
        @from = @o_from || "anonymous@#{server[:domain]}"
      end
    end
    
    def connect(email,template)
      begin
        mail = Mail.new
        mail.to email
        mail.from @from
        mail.subject @subject
        if @template.is_text?
          mail.text_part { body template }
        else
          mail.text_part do
        	  body 'This mail should be rendered or viewed as HTML'
          end
        end
        if @template.is_html?
          mail.html_part do
        	  content_type 'text/html; charset=UTF-8'
            body template
          end
        end
        @attach.each do |file|
          mail.add_file file
        end
        mail.deliver
        D "Successfully sent #{email}"
      rescue
        D "Something went wrong sending #{email}\nError: #{$!}\n"
      end
    end
  end
end
