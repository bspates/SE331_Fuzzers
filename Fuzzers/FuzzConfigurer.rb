require "JSON"
class FuzzConfigurer
	def initialize
		@repHash = load
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
	end
	
	def get
		@repHash
	end
	attr_reader :web_driver, :completeness, :time_gap, :guessing
	def load
		File.open("FuzzRep.txt", "r") do |file|
			JSON.load(file)
		end
	end
end
