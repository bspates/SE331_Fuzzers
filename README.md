SE331_Fuzzers
=============
To run the script call ruby driver.rb in a terminal.
The script requires the selenium webdriver gem which can be installed by: 
gem install selenium-webdriver

The first line of the config.txt file determines which browser the web 
driver will use, the only compatable browser choices are Firefox and Chrome. 

Every subsquent line in the config.txt file is considered a URL for the 
script to Fuzz.

Currently Script only enumerates the attack surface of the urls supplied.
The Attack surface report is generated as a JSON text file called FuzzRep.txt

