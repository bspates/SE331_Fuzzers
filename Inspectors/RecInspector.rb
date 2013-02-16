require './Inspectors/Inspector.rb'
require './Inspectors/LinkInspector.rb'
require './Inspectors/CookieInspector.rb'
require './Inspectors/InputInspector.rb'
require './Utility/WebSpecific.rb'

class RecInspector < Inspector
	def initialize(d, t)
		super(d, t)
		@linkInspect = LinkInspector.new(d, t)
		@cookieInspect = CookieInspector.new(d, t)
		@inputInspect = InputInspector.new(d, t)
		@webSpec = WebSpecific.new(@driver)
		@resHash = Hash.new(0)
		@cookieKey = "cookies"
		@linksKey = "links"
		@inputsKey = "inputs"
		@logons = loadLogons
	end
	def inspect(url)
		self.getUrl(url)
		if(@logons.has_key?(url))
			newUrl = @webSpec.run(@logons, url)
			if(url == "http://127.0.0.1/dvwa/login.php")
				@dvs = DvwaSetup.new(@driver)
				@dvs.setup
			end
			if(newUrl != url)
				self.inspect(newUrl)
			end
		end
		@resHash[url] = Hash.new(0)
		@resHash[url][@cookieKey] = nil
		@resHash[url][@linksKey] = nil
		@resHash[url][@inputsKey] = nil
		
		@resHash[url][@cookieKey] = @cookieInspect.inspect(url)
		@resHash[url][@inputsKey] = @inputInspect.inspect(url)
		links = @linkInspect.inspect(url)
		@resHash[url][@linksKey] = links
		if(links != nil)
			links.each do |link|
				self.inspect(link)
			end
		end
		
		return @resHash	
	end
	
	def loadLogons
		File.open("./Confs/Logons.txt", "r") do |file|
			JSON.load(file)
		end
	end
end