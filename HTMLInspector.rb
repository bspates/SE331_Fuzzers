require 'selenium-webdriver'

class HTMLInspector
  #attr_accessor :page, :hrefs, :inputs
  
  def initialize(driver)
    @inputs = Array.new
		@driver = driver
		@attrList = getAttributeList
  end
  
  def scanForLinks(url)
		links = Array.new(0)
    @driver.get url
		@driver.find_elements(:tag_name, "a").each do | value |
			links << value.attribute("href")
		end
		return links
  end
  
  def scanForInputs(url) 
    @driver.get url 
		inputResults = Array.new(0)
		formResults = Array.new(0)
		
		@driver.find_elements(:tag_name, "form").each do | formelement |
			formres = Hash.new(0)
			@attrList.each do | attr |
				temp = formelement[attr]
				if(temp != nil && temp !="" )
					 formres[attr] = temp
				end	
			end
			@driver.find_elements(:tag_name, "input").each do | tagelement |
				tagres = Hash.new(0)
				@attrList.each do | attr |
					temp = tagelement[attr]
					if(temp != nil && temp !="" )
						 tagres[attr] = temp
					end	
				end
				inputResults << tagres
				formres["inputs"] = inputResults
			end
			formResults << formres
		end
		return formResults
  end
	
	def getAttributeList
		file = File.new("attributeList.txt")
		attrList = Array.new(0)
		while(line = file.gets)
			attrList << line.chomp	
		end
		file.close
		return attrList
	end

end

