require './Inspectors/RecInspector.rb'
require './Inspectors/InspectionConfigurer.rb'
require './Fuzzers/FuzzConfigurer.rb'
require './Fuzzers/StageFuzzer'
require './Utility/DvwaSetup.rb'
@result = Hash.new

def setup(config)
	@web_driver = config.web_driver
	@time_gap = config.time_gap
	@complete = config.completeness
	@guessing = config.guessing
	config.get
end
if(ARGV[0] == nil)
	urls = setup(InspectionConfigurer.new)
	inspector = RecInspector.new(@web_driver, @time_gap)
	puts "Inspecting..."
	urls.each do |url| 
		@result = inspector.inspect(url)
	end
	inspector.save(@result, "FuzzRep.txt", "w+")
else
	@result = setup(FuzzConfigurer.new)
end

@file = File.open("FuzzedResult.txt", "w+")
stageFuzz = StageFuzzer.new(@web_driver, @time_gap, @complete, @guessing, @file)
puts "Fuzzing..."
fuzzedResults = stageFuzz.fuzz(@result)
stageFuzz.save(fuzzedResult, "FuzzResult.txt", "w+")

@web_driver.quit