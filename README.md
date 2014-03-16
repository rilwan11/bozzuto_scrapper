# Allegro Scrapper

## Install
First, you must run:
        
        bundle install
    
This should setup all the dependencies. Now there is an executable console file you can tell bundle to run for testing purposes. Run this via:
    
    ENV=development bundle exec ./console
        
This will take you into the console enviroment. Now lets get started, create an Appartment::Scrapper object via:

    
    a = Appartment::Scrapper.new
    
Then, run:
    
    a.start # This will get the page data
    
Now you can run the scrapping methods! These include:
    # Returns the count of all available apartments in Allegro
    a.get_all_availability_count
    
    # Returns the count of 'filter' available apartments in Allegro
    a.get_availability_count(filter) # e.g. filter = "Style D3"