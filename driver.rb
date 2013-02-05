
require_relative 'HTMLInspector.rb'
require_relative 'CookieInspector.rb'
require_relative 'URLInspector.rb'
require 'selenium-webdriver'



def openConfig()
	urlList = Array.new
	file = File.new("config.txt")
	
	browser = file.gets
	@web_driver 
	if browser.gsub(/\n/,'') == "Firefox"
		@web_driver = Selenium::WebDriver.for :firefox
	elsif browser.gsub(/\n/,'') == "Chrome"
		@web_driver = Selenium::WebDriver.for :chrome
	end
	
	while(line = file.gets)
		urlList << line.chomp
	end
	file.close
	
	@htmlInspect = HTMLInspector.new(@web_driver)
	@cookieInspect = CookieInspector.new(@web_driver)
	@urlInspect = URLInspector.new()
	
	return urlList
end

def inspect(urls, visitedUrls)
	fuzzRep = Hash.new(0)
	urlSet = Set.new(urls)
	while(!urls.length.zero?)

		url = urls.shift
		
		fuzzRep[url] = Hash.new(0)
		fuzzRep[url]["cookies"] = nil
		fuzzRep[url]["links"] = nil
		fuzzRep[url]["url params"] = nil
		fuzzRep[url]["forms"] = nil
	
		justURL = @urlInspect.getURL(url)
	
		if(!visitedUrls.include?(justURL))
			
			visitedUrls.push(justURL)
			urlParams = Array.new(0)#@urlInspect.getInput(url)
			links = @htmlInspect.scanForLinks(url)
			tempParam = ""
			links.each do |uri|
				if(uri!=nil)
					tempParam = uri.match(/(?<=\?|#)(.*)(?=$)/).to_s.prepend(uri.gsub(/(?<=\?|#)(.*)(?=$)/, "").match(/\?|\#/).to_s)
					tempParam == "" ? tempParam : urlParams << tempParam
					sanUri = uri.gsub(/(?<=\?|#)(.*)(?=$)/, "")
					sanUri.gsub!(/\?|\#/, "")
					if(!(urlSet.member?(sanUri)))
						urlSet.add(sanUri)
						urls << sanUri.to_s
					end
				end
			end
			
			inputs = @htmlInspect.scanForInputs(url)
			cookies = @cookieInspect.inspect(url)
			
			if(fuzzRep.has_key?(url))
				fuzzRep[url]["cookies"] = Array.new(cookies)
				fuzzRep[url]["links"] = Array.new(links)
				fuzzRep[url]["url params"] = Array.new(urlParams)
				fuzzRep[url]["forms"] = Array.new(inputs)
			end		
		end
	end
	
	return fuzzRep
	
end

def save_report(fuzzRep)
	document = JSON.pretty_generate(fuzzRep)
	File.open("FuzzRep.txt", 'w+') do |file|
		file.write(document)
	end
end


urlList = openConfig()
fuzzRep = inspect(urlList, Array.new)
save_report(fuzzRep)
@web_driver.quit
