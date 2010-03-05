def D m
  puts m if EMaily::log
end

module EMaily
  @@log = false
  VERSION = 0.1
  
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
      @from = args[:from]
      @content_type = args[:content_type] || 'text/html; charset=UTF-8;'
      @template = Template.new(args[:template], @content_type)
      @ports = @template.ports
      @subject = @template.subject || args[:subject] 
      @serv = []; args[:servers].each {|s| @serv << @servers[s][0][:values] }
      setup_server(@serv[0])
    end
    attr_accessor :list, :from, :content_type, :subject, :serv, :ports
    
    def self.start(file, &block)
      self.new(file)
      block.call(self) if block_given?
    end
        
    def send
      @list.each {|p| connect p[:email], generate_email(p) }
    end
        
    def send_block(bloc = 1, rest = nil, &block)
      j = 0
      while (j <= @list.size) do
        @list[j..(j = until_this(j,bloc))].each {|p| connect p[:email], generate_email(p)}
        sleep(rest) if rest
        block.call(self) if block_given?
      end
    end
    
    def send_to_random_servers(bloc = 1, rest = 0)
      send_block bloc, rest { setup_server(@serv[rand(@serv.size)]) }
    end
    
    def send_to_servers
      @v = 0
      send_block bloc, rest { setup_server(@serv[(@v += 1) % @serv.size]) }
    end
    
    private
    def until_this(j, block)
      j + bloc > @list.size ? j + bloc : @list.size
    end
    
    def generate_email(data)
      @template.generate_email(data)
    end
    
    def setup_server(server)
      Mail.defaults { delivery_method :smtp, server }
    end
    
    def connect(email, template)
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
          m.add_file file
        end
        mail.deliver
        D "Successfully sent #{email}"
      rescue
        D "Something went wrong sending #{email}"
      end
    end
  end
end
