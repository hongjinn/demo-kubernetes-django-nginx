# Website from scratch

Create and deploy a Django website with a pretty domain name and https.
* Docker
* Django (Python framework)
* Nginx (a reverse proxy server)
* Gunicorn (Python server)
* SQLite
* AWS EC2 (virtual private machine)
* Google Domains (where you will buy your domain name)


## Strategy of this guide

* First deploy the site as is (simple hello world template) on Linode and see it live at your Linode ip address http://101.42.69.777

* Then buy a domain name like www.example.com on Google Domains

* Then set up https

* Then set up the site on your personal computer for local development

## Deploy on Linode

* Go to www.linode.com

* Create a Linode -> Marketplace -> Select "Docker"

* Select Region = Fremont and Linode Plan = Linode 2GB

* Enter a Linode Label such as example.com and Root Password

* Hit Create and wait for your Linode to boot up

```
# Starting from your local computer
scp -i ~/.ssh/linode_ssh_key_name ~/.ssh/github_key_name root@101.42.69.777:~/.ssh/       # Send your GitHub SSH key to your Linode
ssh -i ~/.ssh/github_key root@101.42.69.777                                               # SSH into your Linode
git clone git@github.com:hongjinn/myproject-docker-django-gunicorn-nginx.git              # Clone this repository into your Linode
cd myproject-docker-django-gunicorn-nginx                                                 # Go into the folder you just created

# Now let's edit the server name
nano nginx/default.conf
# Update this line: server_name example.com www.example.com;
# Using the name of the domain you're buying

docker-compose up -d                                                                  # Start docker containers

# Done! Open your browser and go to your Linode ip, http://101.42.69.777
```

* Now go to http://101.42.69.777/admin
  * Make sure you replace with your Linode ip
  * Login/password is admin/admin. Please change this right away

## Add a domain name

* Buy a domain name on Google Domains, for example www.example.com
  * In mid 2020 it was $12 a year
  
* Once you've purchased it... go to https://domains.google.com/m/registrar 
  * Click on My domains
  * Find your domain and click on it
  * In the left hand pane, click on "DNS"

* Scroll down to the bottom where it says "Custom resource records"
  * You want to add two rows that ultimately look like below
  * Do this by filling out the fields and hitting "Add"
```
@       A       1h     101.42.69.777
www     CNAME   1h     example.com.
```

* Wait a few hours for this to catch on. Note: if you had previously paired this domain name with another ip address you might have to flush the dns cache on your browser. Otherwise when you navigate to example.com you won't see your new page 
  * You can go to https://dnschecker.org/ and plug in your website name "www.example.com" to check if the association has been made yet between your EC2 ip and your site name

## Make it https

* From your Linode, run the command ```docker exec -it container_nginx certbot --nginx -d example.com -d www.example.com``` and replace example.com  with the domain you bought
  * Fill in your email address
  * Agree to the terms of service
  * Share your email if you want to (not necessary)
  * Choose option 2 to redirect http traffic to https
  
* To check which ports are open on your Linode ```sudo lsof -i -P -n | grep LISTEN```

## Local development

* Follow these steps to run your site on your local computer and start developing

```
# Clone this repository from your personal computer
git clone git@github.com:hongjinn/myproject-docker-django-gunicorn-nginx.git              

# Once cloned, feel free to change the name of the root folder only,
# from "myproject-docker-django-gunicorn-nginx" to "whateveryouwant"

# From the root folder, ie "myproject-docker-django-gunicorn-nginx" or "whateveryouwant"
source .env_local                                                         # Set environmental variables
python3 -m venv venv                                                      # Make a virtual environment
pip install -r requirements.txt                                           # Install dependencies like Django
source venv/bin/activate                                                  # Activate virtual environment
python myapp/manage.py runserver                                          # Open your browser and go to http://localhost:8000
```

## Container management commands
```
docker-compose up -d                                                     # Start running containers
docker-compose down                                                      # Stop containers
docker volume prune                                                      # Delete container data
docker exec -it container_nginx sh                                       # Access the container running Nginx
docker exec -it container_django_gunicorn bash                           # Access the container running Django and Gunicorn
# Location of data in container django_gunicorn: /var/lib/docker/volumes/
# Location of Sqlite data: /var/lib/docker/volumes/myproject-docker-django-gunicorn-nginx_db/_data
```

