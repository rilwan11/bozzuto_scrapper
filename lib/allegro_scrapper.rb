require 'logbert'
require 'base64'
require 'csv'
require 'mail'

LOG = Logbert[self]

module Apartment
  class Scrapper

    attr_accessor :agent, :search_url, :page

    def initialize(options = {})
      # Right now this link is for Allegro only. In the future, add feature to scrape multiple
      # sites of Bozzuto

      @search_url = "http://units.realtydatatrust.com/unittype.aspx?ils=345&propid=45386"
      @agent = Mechanize.new
    end

    def start
      # Fetch the page data!
      @page = agent.get(search_url)
    end

    def self.get_number_available(entry)
      raw_text = entry.search(".//td[@class='button']/span").text
      available = raw_text.match(/^[o|O]nly\s?(\d)\s?[l|L]eft$/)[1]
      return available
    end

    def self.get_price_range(entry)
      price = entry.search("td[class='price']").text rescue "Could not find price :-("
      return price
    end

    def self.get_sq_ft(entry)
      space = entry.search("td[class='sqft']").text rescue "Could not find sq. ft. :-("
      return space
    end

    def self.get_style(entry)
      style = entry.search("td[class='floorPlan']").text rescue "Could not find style :-("
      return style
    end

    def self.get_bed(entry)
      bed_count = entry.search("td[class='bed']").text rescue "Could not find bed count :-("
      return bed_count
    end

    def self.get_bath(entry)
      bath_count = entry.search("td[class='bath']").text rescue "Could not find bath count :-("
      return bath_count
    end

    def get_all_availability
      # Hopefully this DOM element is consistent is does not change each time you visit the site lol
      table   = page.search(".//table[@id='ctl00_contentMain_uaGrid']/tbody")
      entries = table.search("tr")
      a = entries.select{|e| is_available?(e) }

      return a
    end

    def get_all_availability_count
      count = get_all_availability.count
      LOG.info("Found #{count} available rooms!!!")

      return count
    end

    def get_availability(filter)

      raise "Invalid argument. Must use an array!" if not filter.is_a?(Array)

      available = get_all_availability
      e = available.select{|a| filter.include? self.class.get_style(a) }

      return e
    end

    def get_availability_count(filter)
      count = get_availability(filter).count
      LOG.info("Found #{count} available room(s) with filter(s): #{filter}")

      return count
    end

    def get_all_styles
      styles = get_all_availability
      return styles.map{|s| self.class.get_style(s) }
    end

    def is_available?(entry)
      return entry.search("td[class='button']").search("a").text == "View Availability"
    end

    def pretty_print(filter = nil)

      if filter
        styles = get_availability(filter)
        get_availability_count(filter)
      else
        styles = get_all_availability
        get_all_availability_count
      end

      LOG.info("----------------------------\n")
      styles.each do |s|
        LOG.info "Style: #{self.class.get_style(s)}"
        LOG.info "Number Available: #{self.class.get_number_available(s)}"
        LOG.info "Number of Beds: #{self.class.get_bed(s)}"
        LOG.info "Number of Baths: #{self.class.get_bath(s)}"
        LOG.info "Prince Range: #{self.class.get_price_range(s)}"
        LOG.info "Square Feet: #{self.class.get_sq_ft(s)}"
        LOG.info("----------------------------\n")
      end

      true
    end

  end

  class Notifier

    # Creates a CSV file with the data we need
    def self.create_file(data)

      curr_time = Time.now.strftime('%m_%d_%Y')
      log_file = "Allegro Apartment Status - #{curr_time}.csv"

      CSV.open(log_file, "wb") do |csv|
        data.each do |d|
          style     = Apartment::Scrapper.get_style(d)
          price     = Apartment::Scrapper.get_price_range(d)
          bed       = Apartment::Scrapper.get_bed(d)
          available = Apartment::Scrapper.get_number_available(d)

          csv << ["Style: #{style}", "Price: #{price}", "Beds: #{bed}", "Number Available: #{available}"]
        end
      end

      return log_file
    end

    def self.send_email(file, emails)

      if File.exists?(file)

        options = {
          :address              => "smtp.gmail.com",
          :port                 => 587,
          :domain               => 'localhost',
          :user_name            => 'test',
          :password             => 'test',
          :authentication       => 'plain',
          :enable_starttls_auto => true
        }

        Mail.defaults do
          delivery_method :smtp, options
        end

        csv = File.open(file, "rb")
        options = {:file_name => file, :file_contents => csv.read}

        e = ['rilwan11@gmail.com','abezobchuk90@gmail.com']

        emails.each do |e|
          Mail.deliver do
            from      'robot@mailinator.com'
            to        e
            subject  'Allegro Apartment Update'
            body     'Attached is the latest Scrapped Update'
            add_file :filename => options[:file_name], :content => options[:file_contents]
          end
        end

        LOG.info("Closing csv file and deleting it!")
        csv.close
        File.delete(csv)
      else
        LOG.info "File: #{file} does not exist!"
      end
    end

  end
end
