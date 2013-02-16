 class XSSFuzzer < Fuzzer
	
	def createXSS(element, xssStr)
		element.clear
		element.send_keys xssStr
	end
	
	def checkForXSS()
		count = 0
		begin	
			while((a = @driver.switch_to.alert))
				if(a.text == "XSS")
					count += 1
				end
				a.dismiss
			end
			
			return count
		rescue Selenium::WebDriver::Error::NoAlertOpenError
		end
	end
	
	def getElement(elem, type)
		element = nil
		
		begin
			if elem.has_key? "name"
				name = elem["name"]
				element = @driver.find_element(:name, name)
			else
				element = @driver.find_element(:xpath,
					"//input[type='@{type}']")
			end
		rescue
			puts "error retrieving #{type} element:"
			puts elem
		end
		
		return element
	end
	
	def fuzz(vector, input, url)
		if(input != nil && input != 0)
			if(@random == true)
				vectorKey = randomizer(vector)
				inputKey = randomizer(input)
				if input[inputKey]["type"] == "text"
					ele = getElement(input[inputKey], input[inputKey]["type"])
					
					if(ele != nil)
						createXSS(ele, vector[vectorKey])
					end
				elsif input[inputKey]["type"] == "submit"
					submit = getElement(input[inputKey], input[inputKey]["type"])
				end
				if(submit != nil)
					self.submitInput(submit)
					self.getUrl(url)
				end
				puts checkForXSS()
					
			else
				input.each do | jsonEle |
					vector.each do | xssStr |
					
						
						if jsonEle.has_key? "type"
							if jsonEle["type"] == "text"
								ele = getElement(jsonEle, jsonEle["type"])
								
								if(ele != nil)
									createXSS(ele, xssStr)
								end
							elsif jsonEle["type"] == "submit"
								submit = getElement(jsonEle, jsonEle["type"])
							end
						end
					end
					
					if(submit != nil)
						self.submitInput(submit)
						self.getUrl(url)
					end
					puts checkForXSS()
				end
			end
		end
	end
 end
 
 