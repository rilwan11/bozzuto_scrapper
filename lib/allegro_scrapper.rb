require 'logbert'

LOG = Logbert[self]

module Appartment
  class Scrapper

  	attr_accessor :agent, :search_url, :page

  	def initialize(options = {})
      # Required params
      # Right now this link is for Allegro only. In the future, add feature to scrape multiple
      # site of Bozzuto
      @search_url = "http://units.realtydatatrust.com/unittype.aspx?ils=345&propid=45386"

      # Optional params
      @agent = Mechanize.new
    end

    def start
    	# Fetch the page data!
    	@page = agent.get(search_url)
    end

    def get_price_range(entry)
    	price = entry.search("td[class='price']").text rescue "Could not find price :-("
    	LOG.info("Price found: #{price}")

    	return price
    end

    def get_sq_ft(entry)
    	space = entry.search("td[class='sqft']").text rescue "Could not find sq. ft. :-("
    	LOG.info("Bed count found: #{space}")

    	return space
    end

    def get_style(entry)
    	style = entry.search("td[class='floorPlan']").text rescue "Could not find style :-("
    	LOG.info("Bed count found: #{style}")

    	return style
    end

    def get_bed(entry)
    	bed_count = entry.search("td[class='bed']").text rescue "Could not find bed count :-("
    	LOG.info("Bed count found: #{bed_count}")

    	return bed_count
    end

    def get_bath(entry)
    	bath_count = entry.search("td[class='bath']").text rescue "Could not find bath count :-("
    	LOG.info("Bed count found: #{bath_count}")

    	return bath_count
    end

    def get_availabilities
    	# Hopefully this DOM element is consistent is does not change each time you visit the site lol
    	table 	= page.search(".//table[@id='ctl00_contentMain_uaGrid']/tbody")
    	entries = table.search("tr")

    	a = entries.select{|e| e.search("td[class='button']").search("a").text == "View Availability"}
    	LOG.info("Found #{a.count} available rooms")

    	return a
    end

    def get_all_availability_count
    	return get_availabilities.count
    end

    def get_availability_count(filter)
    	available = get_availabilities

    	e = available.select{|a| get_style(a) == filter }
    	LOG.info("Found #{e.count} available rooms with filter: #{filter}")

    	return e.count
    end

    def is_available?(entry)
    	return entry.search("td[class='button']").search("a").text == "View Availability"
    end

  end
end
