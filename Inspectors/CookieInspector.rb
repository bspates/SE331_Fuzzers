require './Inspectors/Inspector.rb'
class CookieInspector < Inspector
	
	def inspect(url)
		cookies = Array.new(0)
		@driver.manage.all_cookies.each { | cookie| cookies << cookie}
		return cookies
	end
end