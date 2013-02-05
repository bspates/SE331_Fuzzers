require "uri"
require "cgi"

class URLInspector

	def initialize()
		
	end
	
	def getInput(url)
		begin
			url1 = URI.parse(url)
			return url1
		rescue
			puts "Error parseing URL: #{url} !!!"
			return nil
		end
		if uri.query != nil
			return CGI.parse(uri.query)
		else
			return nil
		end
	end

	def getURL(url)
		begin
			url1 = URI.parse(url)
			return url1
		rescue
			puts "Error parseing URL: #{url} !!!"
			return nil
		end
	end
		

end 