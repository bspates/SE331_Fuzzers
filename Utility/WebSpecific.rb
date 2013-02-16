class WebSpecific
	def initialize(driver)
		@driver = driver		
	end
	def run(hash, url)
		@driver.get url
		hash[url].each do |value|
			ele = @driver.find_element(:xpath,"//input[@#{value[0]}='#{value[1]}']")
			if(value[2] =="send_keys")
				ele.send_keys(value[3])
			elsif(value[2] =="click")
				ele.click
			end
		end	
		return @driver.current_url
	end
	
	
end