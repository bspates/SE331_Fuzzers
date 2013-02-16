class Fuzzer 
	
	def initialize(d, t, c, f)
		@driver = d	
		@file = f
		@time_gap = t
		if(c == "random")
			@random = true
		else
			@random = false
		end
		
	end 
	
	def fuzz(fuzzable_obj)

	end
	

	def getUrl(url)
		sleep(@time_gap)
		@driver.get url
	end
	
	def submitInput(element)
		sleep(@time_gap)
		element.click
	end

	def click(element)
		sleep(@time_gap)
	  element.click
	end
	
	def randomizer(dataset)
			if(dataset.class == Hash)
				keys = dataset.keys		
				prng = Random.new(Time.now.to_i)
				num = prng.rand(keys.length)
				key = keys[num]
			elsif(dataset.class == Array)
				prng = Random.new(Time.now.to_i)
				num = prng.rand(dataset.length)
				key = num
			else
				puts "not proper data set"
			end
			return key
	end
	
	def save(hash, fileString, mode)
		document = JSON.pretty_generate(hash)
		File.open(fileString, mode) do |file|
			file.write(document)
		end
	end

end