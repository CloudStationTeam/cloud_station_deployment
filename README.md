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
2. Associate an Elastic IP to the EC2 (**Please take note of the IP/DNS address, you will need it in step 3 and 6) 
    * "An Elastic IP address is a static IPv4 address". It is a public address we use so the IP address of the deployed 
    CloudStation will stay the same. 
    > Learn more about it here: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html?icmpid=docs_ec2_console
    * This is only a temporary solution but it serves our testing purpose well. This step is optional but if elastic IP is not used, the server
    IP address will change from time to time.      
3. [Connect to Linux instance using an SSH client](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)
4. Set up EC2 (run only once)  
    run 
    ```
    cd ~
    git clone https://github.com/CloudStationTeam/cloud_station_deployment.git
    bash ~/cloud_station_deployment/setup_server.sh
    ```   
    The script does the following：   
      1. Update Ubuntu  
      2. Install NGINX and docker  
      3. Clone cloud_station_web source code  
      4. Set up Python virtual environment (install dependencies)  
5. Modify cloud_station_web/webgms/settings.py  
    * Add EC2 IP address/DNS to ALLOWED_HOST 
      * DNS example: "ec2-xx-xx-xxx-xxx.us-west-1.compute.amazonaws.com" (it should be a string, please do not forget the quotation marks)
    * Set DEBUG to False  
6. Modify cloud_station_deployment/nginx.conf
    * add EC2 IP/DNS address to Line 68: server_name ec2-xx-xx-xxx-xxx.us-west-1.compute.amazonaws.com 
7. Configure NGINX, Daphne and Django (run only once)  
    run ```bash ~/cloud_station_deployment/configure_web_server.sh```      
    The script does the following:     
      1. Write database migrations  
      2. Collect staticfiles to ~cloud_station_web/static  
      3. Configure NGINX with nginx.conf  
      4. Configure systemctl to automatically run Daphne as a service(daphne.service)  
      5. Download redis and start running redis in a docker container  
8. Reload server (after a code update)    
    run ```bash ~/cloud_station_deployment/reload_server.sh```  
    The script does the following:  
      1. Pull latest version of the src code
      2. Write database migrations  
      3. Collect staticfiles  
      4. Reload NGINX and Daphne  
      5. Run django_background_tasks  

## CI/CD

## Authors
  * Lyuyang Hu
  * Omkar Pathak

## Troubleshooting 
