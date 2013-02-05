
require_relative 'HTMLInspector.rb'
require_relative 'CookieInspector.rb'
require_relative 'URLInspector.rb'
require 'selenium-webdriver'


# Read in data from the configuration file
def openConfig()
	urlList = Array.new
	file = File.new("config.txt")
	
	# Create the selenium web driver based on the configured browser
	browser = file.gets
	@web_driver 
	if browser.gsub(/\n/,'') == "Firefox"
		@web_driver = Selenium::WebDriver.for :firefox
	elsif browser.gsub(/\n/,'') == "Chrome"
		@web_driver = Selenium::WebDriver.for :chrome
	end
	
	# Read in the URLs to visit
	while(line = file.gets)
		urlList << line.chomp
	end
	file.close
	
	# Instantiate the page inspection classes
	@htmlInspect = HTMLInspector.new(@web_driver)
	@cookieInspect = CookieInspector.new(@web_driver)
	@urlInspect = URLInspector.new()
	
	return urlList
end

# Inspect each url
def inspect(urls, visitedUrls)

	fuzzRep = Hash.new(0)
	urlSet = Set.new(urls)

	# Continue to loop through urls to visit until none are left
	while(!urls.length.zero?)

		url = urls.shift
		
		# Construct the has representation of the data for JSON formatting
		fuzzRep[url] = Hash.new(0)
		fuzzRep[url]["cookies"] = nil
		fuzzRep[url]["links"] = nil
		fuzzRep[url]["url params"] = nil
		fuzzRep[url]["forms"] = nil
	
		# Return this url without any extra data
		justURL = @urlInspect.getURL(url)
	
		# Only analyze this url if it hasn't been visited yet
		if(!visitedUrls.include?(justURL))
			
			visitedUrls.push(justURL)
			urlParams = Array.new(0)
			
			# Get the links from the page
			links = @htmlInspect.scanForLinks(url)
			tempParam = ""
			# For each link found, get the used URL parameters
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
			
			#Get page inputs and cookies
			inputs = @htmlInspect.scanForInputs(url)
			cookies = @cookieInspect.inspect(url)
			
			
			#Construct the JSON representation of found data
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

# Save the report JSON data to a text file
def save_report(fuzzRep)
	document = JSON.pretty_generate(fuzzRep)
	File.open("FuzzRep.txt", 'w+') do |file|
		file.write(document)
	end
end

# Print out numerical report statistics 
def printStatistics(fuzzRep, urls)
	urls.each do |url|
		linkCount = 0
		cookieCount = 0
		formCount = 0
		urlParamCount = 0
		fuzzRep.keys.sort.each do |key|
			if key.include? url
				linkCount += fuzzRep[key]["links"].length
				cookieCount += fuzzRep[key]["cookies"].length
				formCount += fuzzRep[key]["forms"].length
				urlParamCount += fuzzRep[key]["url params"].length
			end
		end
		
		puts "Results for #{url}"
		puts "     links found: #{linkCount}"
		puts "     cookie count: #{cookieCount}"
		puts "     form count: #{formCount}"
		puts "     url param count: #{urlParamCount}"
		puts ""
	end
end


urlList = openConfig()
urlCopy = Marshal.load(Marshal.dump(urlList))
fuzzRep = inspect(urlList, Array.new)
save_report(fuzzRep)
printStatistics(fuzzRep, urlCopy)
@web_driver.quit
