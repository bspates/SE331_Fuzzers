require './Inspectors/Inspector.rb'

class InputInspector < Inspector

	def initialize(d, t)
		super(d, t)
		@attrList = getAttributeList
		@formAtt = 'action'
	end
	def inspect(url)
		inputResults = Array.new(0)
		formResults = Array.new(0)
		
		@driver.find_elements(:xpath, "//input").each do | tagelement |
			
			tagres = Hash.new(0)
			@attrList.each do | attr |
				temp = tagelement[attr]
				if(temp != nil && temp !="")
					 tagres[attr] = temp
				end	
			end
			inputResults << tagres
		end

		return inputResults
	end
	
	def getAttributeList
		file = File.new("./Confs/attributeList.txt")
		attrList = Array.new(0)
		while(line = file.gets)
			attrList << line.chomp	
		end
		file.close
		return attrList
	end
end