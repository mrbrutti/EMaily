####
#### Values in templates are represented by %%value%%.
#### for example %%name%%
####

module EMaily
  class Template
    def initialize(template, content_type)
      file = File.read(template)
      if file[0].match(/<subject>/)
        @s = file[0].scan(/<subject>(.*)<\/subject>/)
        @t=file[1..-1]
      else
        @t = file
      end
      @c = content_type
    end
    
    def generate_email(values)
      email=@t
      D "Creating Email for #{values[:email]}" if values[:email]
      @t.scan(/(%%.*%%)/).each {|x| email.gsub!(/(#{x})/) {|s| values[s.to_s[2..-2].to_sym]}}
      email
    end
    
    def is_text?
      @c.match(/text\/plain/)
    end
    
    def is_html?
      @c.match(/text\/html/)
    end
    
    def subject
      @s || nil
    end
  end
end