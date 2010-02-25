module EMaily
  class SkyDrive
    LOGIN_URI = "http://login.live.com/login.srf?wa=wsignin1.0&rpsnv=10&ct=1242028992&rver=5.5.4177.0&wp=MBI&wreply=http:%2F%2Fskydrive.live.com%2Fwelcome.aspx%3Fmkt%3Den-us&lc=1033&id=250206&mkt=en-US"
    def initialize

    end
    
    def login(username,password)
      #TBI
    end
    
    def upload(files)
      files.each do |file|
        #TBI
      end
    end
  end
end