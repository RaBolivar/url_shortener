# Intial Setup

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc

# Algorithm used to generate the short code

    def generate_short_code(short_url_id)
    short_code = ""
     
    # for each digit find the base 62
    while (short_url_id > 0) do
      short_code += CHARACTERS[short_url_id % BASE]  
      short_url_id = short_url_id / BASE
	    end

    # reversing the short code
    short_code.reverse
	end
    
    The method takes the short_url_id and iterates until the id is equal to 0. 
    Find the character in the position of the result (id % 62) which is the base
    we are using and after that, it updates the value of the id, 
    once it has the string with the code should reverse it to show in ASC order.
