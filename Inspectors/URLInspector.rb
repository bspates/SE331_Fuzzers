require "uri"
require "cgi"

class URLInspector < Inspector

	def getInput(url)
		begin
			uri = URI::parse(url)
			
			if uri.query != nil
				return CGI::parse(uri.query)
			else
				return nil
			end
		rescue
			puts "Error parseing URL: #{url} !!!"
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