require './Fuzzers/Fuzzer.rb'
require 'test/unit'

class InputFuzzer < Fuzzer
	
	def initialize(d, t, c)
		super(d, t, c)
		@passwords = loadPasswords
		@usernames = loadUsernames
	end
	def fuzz(elements, url)  
	  
	  @url = url
	  #if(url.include? "login")

	    if(isElementPresent?(:xpath, "//input[@name='username']") and
	      !isElementPresent?(:xpath, "//input[@name='repeatedPassword']"))
	    
    	  @passwords.each do | key, p |
    	    p.each do |pass|
      	    @usernames.each do | key, u |
      	      u.each do | user |
            	  elements.each do | v |
            			v.each do | key, value |
            				if(key =="name")
            				  begin
            				    ele = @driver.find_element(:xpath, "//input[@#{key}='#{value}']")
            				  rescue
            				    return
            				  end
            				  
            					if(value =="username")
            						guessUserName(ele, user)
            					elsif(value == "password")
            						guessPassword(ele, pass)
            					end
            					
            				end
            				if(key =="type")
            					if(value =="submit")
            						begin
            						  @submit = @driver.find_element(:xpath, "//input[@value='Login']")
            						rescue
                          @submit = @driver.find_element(:xpath, "//input[@#{key}='#{value}']")
            						end
            					end
            				end			
            			end
            		end
            	  self.click(@submit)
            	  
      	        if(loginFailed?)
      	        else
      	          puts "login successful with username: #{user} and password #{pass}"
            	  end
            	    
                self.getUrl(url)      	      		  
              end
      	    end
    	    end
    	  end
  	  end 	  
	  #end
	end
	
	def guessUserName(element, user)
	  element.clear
		element.send_keys user
	end
	
	def guessPassword(element, pass)
	  element.clear
		element.send_keys pass
	end
	
	def loadPasswords
    File.open("./Confs/passwords.txt", "r") do |file|
      JSON.load(file)
    end
	end
	
	def loadUsernames
    File.open("./Confs/usernames.txt", "r") do |file|
      JSON.load(file)
    end
	end
	
  def isElementPresent?(type, selector)
    begin
      @driver.find_element(type, selector)
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
    end
  end
  
  def loginFailed?
    
    self.getUrl(@driver.current_url)
    
    if(@driver.find_element(:tag_name => "body").text.include?("failed") or
      @driver.find_element(:tag_name => "body").text.include?("incorrent"))
      return true
    elsif(@driver.current_url == @url)
      return true
    elsif(@driver.current_url == "http://127.0.0.1:8080/jpetstore/actions/Account.action")
      return true
    else
      return false
    end
  end

end