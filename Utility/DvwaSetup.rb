require "selenium-webdriver"
class DvwaSetup
	def initialize(driver)
		@driver = driver
	end
	def	setup
		@driver.get "http://127.0.0.1/dvwa/setup.php"
		@driver.find_element(:xpath, "//input[@name='create_db']").click
		@driver.get "http://127.0.0.1/dvwa/security.php"
		select = Selenium::WebDriver::Support::Select.new(@driver.find_element(:xpath, "//select[@name='security']"))
		select.select_by(:text, "low")
		@driver.find_element(:xpath, "//input[@name='seclev_submit']").click
		
	end
end