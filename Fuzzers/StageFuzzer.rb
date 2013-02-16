require './Fuzzers/Fuzzer.rb'
require './Utility/WebSpecific.rb'
require './Utility/DvwaSetup.rb'
require './Fuzzers/XSSFuzzer.rb'
require './Fuzzers/SQLFuzzer.rb'
require './Fuzzers/InputFuzzer.rb'
class StageFuzzer < Fuzzer

	def initialize(d, t, c, g, f)
		super(d, t, c, f)
		@logons = loadLogons
		@vectors = loadVectors
		@webSpec = WebSpecific.new(d)
		@xssFuzz = XSSFuzzer.new(d, t, c, f)
		@inputFuzz = InputFuzzer.new(d, t, c, f)
		@sqlFuzz = SQLFuzzer.new(d, t, c, f)
		
		@sqlKey = "SQLInjections"
		@xssKey = "XSS"
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
			@file.puts "SQL Injections:"
			@sqlFuzz.fuzz(@vectors["SQLInjections"], results[key]["inputs"], key)
			if(@guess)
				@inputFuzz.fuzz( results[key]["inputs"], key)
			end
			@file.puts "XSS:"
			@xssFuzz.fuzz(@vectors["XSS"],  results[key]["inputs"], key)
		else
			results.each do | key, value |
				@file.puts "#{key} is vulnerable to:"

				if(value["inputs"] != nil && key != "http://127.0.0.1/dvwa/login.php" && key != "http://127.0.0.1/dvwa/index.php")
			
				self.getUrl(key)
				@file.puts "SQL Injections:"
				@sqlFuzz.fuzz(@vectors[@sqlKey], value["inputs"], key)
				#@inputFuzz.fuzz(value["inputs"], key)
				if(@guess)
					@inputFuzz.fuzz(value["inputs"], key)
				end
				@file.puts "XSS:"
				@xssFuzz.fuzz(@vectors[@xssKey], value["inputs"], key)
				@file.puts ""
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