# cloud_station_deployment
The instructions describe our setup process on an EC2 instance running Ubuntu 18.04 LTS. The steps should be similar if you 
use a server with Linux Distributions.  
> [Source code of the CloudStation web app](https://github.com/CloudStationTeam/cloud_station_web)

## Deployment Instructions:
1. Launch an EC2 instance on AWS with Ubuntu 18.04 LTS
    * t2.micro (free-tier eligible) is good enough to test the deployment.
    * Step 6: Configure Security Group (AWS EC2 Console)
      * SSH (TCP)   Port:22     Source:My IP
      * HTTP(TCP)   Port:80     Source:Anywhere
      * Custom UDP Rule  Port:14550  Source:Anywhere
        * MAVLink(vehilce messages) is routed to 14550 via UDP in the current configuration. Any available port can be used instead of 14550.
    * Create or use existing key pairs. This is used for SSH.
2. Associate an Elastic IP to the EC2
    * "An Elastic IP address is a static IPv4 address". It is a public address we use so the IP address of the deployed 
    CloudStation will stay the same. 
    > Learn more about it here: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html?icmpid=docs_ec2_console
    * This is only a temporary solution but it serves our testing purpose well.      
3. [Connect to Linux instance using an SSH client](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)
4. Set up EC2 (run only once)  
    run ```bash setup_server.sh```   
    The script does the following：   
      1. Update Ubuntu  
      2. Install NGINX and docker  
      3. Clone cloud_station_web source code  
      4. Set up Python virtual environment (install dependencies)  
5. Modify cloud_station_web/webgms/settings.py  
    * Add EC2 IP address to ALLOWED_HOST  
    * Set DEBUG to False  
6. Configure NGINX, Daphne and Django (run only once)  
    run ```bash configure_web_server.sh```      
    The script does the following:     
      1. Write database migrations  
      2. Collect staticfiles to ~cloud_station_web/static  
      3. Configure NGINX with nginx.conf  
      4. Configure systemctl to automatically run Daphne as a service(daphne.service)  
      5. Download redis and start running redis in a docker container  
6. Reload server (after a code update)    
    run ```bash reload_server.sh```  
    The script does the following:  
      1. Write database migrations  
      2. Collect staticfiles  
      3. Reload NGINX and Daphne  
      4. Run django_background_tasks  

## CI/CD

## Authors
  * Lyuyang Hu
  * Omkar Pathak

## Troubleshooting 
