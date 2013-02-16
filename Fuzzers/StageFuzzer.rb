require './Fuzzers/Fuzzer.rb'
require './Utility/WebSpecific.rb'
require './Utility/DvwaSetup.rb'
require './Fuzzers/XSSFuzzer.rb'
require './Fuzzers/SQLFuzzer.rb'
require './Fuzzers/InputFuzzer.rb'
class StageFuzzer < Fuzzer
	
	def initialize(d, t, c, g)
		super(d, t, c)
		@logons = loadLogons
		@vectors = loadVectors
		@webSpec = WebSpecific.new(d)
		@xssFuzz = XSSFuzzer.new(d, t, c)
		@inputFuzz = InputFuzzer.new(d, t, c)
		@sqlFuzz = SQLFuzzer.new(d, t, c)
		if(g =="on")
			@guess = true
		else
			@guess = false
		end

	end
	def fuzz(results)
		if(results.has_key?("http://127.0.0.1/dvwa/login.php"))
			if(@logons.has_key?("http://127.0.0.1/dvwa/login.php"))
				newUrl = @webSpec.run(@logons, "http://127.0.0.1/dvwa/login.php")
			end
			@dvs = DvwaSetup.new(@driver)
			@dvs.setup
		end
		if(@random == true)
			key = self.randomizer(results)
			self.getUrl(key)
			@sqlFuzz.fuzz(@vectors["SQLInjections"], results[key]["inputs"], key)
			if(@guess)
				@inputFuzz.fuzz( results[key]["inputs"], key)
			end
			@xssFuzz.fuzz(@vectors["XSS"],  results[key]["inputs"], key)
		else
			results.each do | key, value |
				if(value["inputs"] != nil && key != "http://127.0.0.1/dvwa/login.php" && key != "http://127.0.0.1/dvwa/index.php")
					self.getUrl(key)
					puts value["inputs"]
					@sqlFuzz.fuzz(@vectors["SQLInjections"], value["inputs"], key)
					if(@guess)
						@inputFuzz.fuzz(value["inputs"], key)
					end
					@xssFuzz.fuzz(@vectors["XSS"], value["inputs"], key)
				end
			end
		end
	end
	

	def loadVectors
		File.open("./Confs/vectors.txt", "r") do |file|
			JSON.load(file)
		end
	end
	
	def loadLogons
		File.open("./Confs/Logons.txt", "r") do |file|
			JSON.load(file)
		end
	end
	
end