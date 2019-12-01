# cloud_station_deployment
The instructions describe our setup process on an EC2 instance running Ubuntu 18.04 LTS. The steps should be similar if you 
use a server with Linux Distributions.

## Deployment Instructions:
1. Launch an EC2 instance on AWS with Ubuntu 18.04 LTS
    * t2.micro (free-tier eligible) is good enough to test the deployment.
    * Step 6: Configure Security Group (AWS EC2 Console)
      * SSH (TCP)   Port:22     Source:My IP
      * HTTP(TCP)   Port:80     Source:Anywhere
      * Custom UDP Rule  Port:14550  Source:Anywhere
        * MAVLink(vehilce messages) is routed to 14550 via UDP in the current configuration. Any available port can potentially
        be used for this configuration.
    * Create or use existing key pairs. This is used for SSH.
2. Associate an Elastic IP to the EC2
    * "An Elastic IP address is a static IPv4 address". It is a public address we use so the IP address of the deployed 
    CloudStation will stay the same. 
    > Learn more about it here: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html?icmpid=docs_ec2_console
    * This is only a temporary solution but it serves our testing purpose well.      
3. [Connect to Linux instance using an SSH client](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)
4. Set up EC2   
    run ```bash setup_server.sh```   
    The script does the following：   
        1. 
5. Configure NGINX and Daphne   
    run ```bash configure_web_serber.sh```   
    The script does the following:   
        1.    
6. Run server   
    run ```bash run_server.sh```   

## CI/CD

## Authors
    * Lyuyang Hu
    * Omkar Pathak
