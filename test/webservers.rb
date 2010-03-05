def parsedata(data)
  # Print list of Ports matching IP to Email
  puts "Open Ports\n"
  puts "------------"
  ports = data.map {|d| d[1]}.uniq 
  ports.each do |port|
    puts "Port #{port}"
    data.select {|d| d[1] == port}.each do |d| 
      puts "\t#{d[0]} => #{d[2].to_s.scan(/\?e=(.*)/).to_s}\n"
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

aa = File.read("/Users/matt/emaily_webserver_FriMar0517444703002010.log")
aaa = aa.scan(/\|\| (.*) \|\| (.*) \|\| (.*) \|\| (.*)/)

p aa
p aaa
parsedata(aaa)
