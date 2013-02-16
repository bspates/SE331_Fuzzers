require 'selenium-webdriver'
class InspectionConfigurer

	def initialize 
		file = File.new("./Confs/config.txt")
		@urlList = Array.new
		# Create the selenium web driver based on the configured browser
		browser = file.gets
		
		@web_driver 
		if browser.gsub(/\n/,'') == "Firefox"
			@web_driver = Selenium::WebDriver.for :firefox
		elsif browser.gsub(/\n/,'') == "Chrome"
			@web_driver = Selenium::WebDriver.for :chrome
		end
		@time_gap = file.gets.to_i
		@completeness = file.gets.gsub(/\n/,'')
		@guessing = file.gets.gsub(/\n/,'')
		# Read in the URLs to visit
		while(line = file.gets)
			@urlList << line.chomp
		end
		file.close
		
		if(File.exists?("./FuzzRep.txt"))
			File.delete("./FuzzRep.txt")
		end
		
	end
	
	def get
		return @urlList
	end
	
	attr_reader :web_driver, :completeness, :password_guess, :time_gap, :guessing
end