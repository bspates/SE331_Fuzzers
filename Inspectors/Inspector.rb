
class Inspector
	
	def initialize(driver, time_gap)
		@driver = driver	
		@time_gap = time_gap
	end
	
	def inspect(url)
		puts url
	end
	
	def save(hash, fileString, mode)
		document = JSON.pretty_generate(hash)
		File.open(fileString, mode) do |file|
			file.write(document)
		end
	end
	
	def getUrl(url)
		@driver.get url
		sleep(@time_gap)
	end
	
	def submitInput(element)
		sleep(@time_gap)
		element.submit
	end
end