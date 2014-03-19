#Allegro Scrapper
##Install

First, you must run:

        bundle install
This should setup all the dependencies. Now there is an executable console file you can tell bundle to run for testing purposes. Run this via:

        ENV=development bundle exec ./console
This will take you into the console enviroment. Now lets get started, create an Apartment::Scrapper object via:

        a = Apartment::Scrapper.new
Then, run:

        a.start # This will get the page data
Now you can run the scrapping methods! These include:

        # Returns the count of all available apartments in Allegro
        a.get_all_availability_count

        # Returns the count of 'filter' available apartments in Allegro. Filter must be an array
        a.get_availability_count(filter) # e.g. filter = ["Style D3"]

        # Get all the styles
        a.get_all_styles

        # Pretty prints (actually logs) all available rooms or rooms within a given filter array
        a.pretty_print
        a.pretty_print(["Style D1", "Style D3", "Style D5"])
Sending email:

        # Gets the data you want to send
        data = a.get_availability(["Style D1", "Style D3", "Style D5"])
        # or get all data
        data = a.get_all_availability

        # Get the file
        file = Apartment::Notifier.create_file(data)

        # Send the email (make sure credentials are added)
        Apartment::Notifier.send_email(file, ["test@test.com", "test2@test2.com", ...])
#TODO

Deploy this freaking thing somewhere (probz heroku)
Setup some sort of logging/mailing/noitification system (something very simple!)
Setup the schedule.rb file to run certain methods to notify us via the above ^^^
