require 'net/http'
class SQLFuzzer < Fuzzer

	def inject(element, sqlStr)
		element.clear
		element.send_keys sqlStr
		sleep(2)
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
	
	def checkSQL(pageBefore)
		pageAfter = @driver.page_source
		if(pageBefore != pageAfter)
			@file.puts "SQL Injection detected"
		end
	end
	def fuzz(vector, input, url)

		if(input != nil && input != 0)
			if(@random == true)
				vectorKey = self.randomizer(vector)
				inputKey = self.randomizer(input)
				if input[inputKey].has_key? "type"
					if input[inputKey]["type"] == "text"
						ele = getElement(input[inputKey], input[inputKey]["type"])
						
						if(ele != nil)
							inject(ele, vector[vectorKey])
						end
					elsif input[inputKey]["type"] == "submit"
						submit = getElement(input[inputKey], input[inputKey]["type"])
					end
				end
				
				if(submit != nil)
					pageBefore = @driver.page_source
					self.submitInput(submit)
					self.getUrl(url)
					checkSQL(pageBefore)
				end
				
			else
				input.each do | jsonEle |
					vector.each do | sqlStr |
						if jsonEle.has_key? "type"
							if jsonEle["type"] == "text"
								ele = getElement(jsonEle, jsonEle["type"])

								if(ele != nil)
									inject(ele, sqlStr)
								end
							elsif ((jsonEle["type"] == "submit"))
								submit = getElement(jsonEle, jsonEle["type"])

							end
						end
						
						if(submit != nil)
							pageBefore = @driver.page_source
							self.submitInput(submit)
							self.getUrl(url)
							checkSQL(pageBefore)
						end
					end
				end
			end
		end

	end
end