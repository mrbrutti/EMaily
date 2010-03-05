require "../lib/emaily"

t = EMaily::Template.new("/Users/matt/Dropbox/EMaily/templates/test_template.html", 'text/html; charset=UTF-8;')
list = EMaily::CSV.parse("/Users/matt/emails.csv")

p t.generate_email(list[2])

list.each do |x|
  p x
  p t.generate_email(x)
end