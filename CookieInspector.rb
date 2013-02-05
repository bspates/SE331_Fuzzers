

class CookieInspector

	def initialize(driver)
		@driver = driver
	end
	
	
	def inspect(url)
		cookies = Array.new(0)
		@driver.get url
		@driver.manage.all_cookies.each { | cookie| cookies << cookie}
		return cookies
	end
end