require './Inspectors/Inspector.rb'
require 'uri'
class LinkInspector < Inspector

	def initialize(d, t)
		super(d, t)
		@visited = Set.new()
	end
	
	def compareLink(startingURL, linkURL)
		startingURI = URI.parse(startingURL)
		linkURI = URI.parse(linkURL)
		
		if startingURI.host == linkURI.host
			return true
		else
			return false
		end
	end
	
	def inspect(url)
		links = Array.new(0)
		
		@driver.find_elements(:tag_name, "a").each do | value |
			temp = value.attribute("href")
			cutTemp = temp
			if((temp != nil)&& temp!=url)
				sameHost = compareLink(url, temp)
				if(sameHost)
					if(temp.match(/=/) != nil)
						cutTemp = temp.sub(/=[^=]*$/, "")
					elsif(temp.match(/#/) != nil)
						cutTemp = temp.sub(/#[^#]*$/, "")
					else
						cutTemp = temp
					end
					if(!@visited.member?(cutTemp)) 
						if(temp.scan(/(#{Regexp.escape(url)})/))
							links << temp
							@visited.add(url)
							@visited.add(cutTemp)
						end
					end
				end
			end
		end
		return links
	end
end