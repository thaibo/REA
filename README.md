# Simple Sinatra App Deployment

Deployment of a simple sinatra web application to an AWS instance

## Getting Started

These instructions will get you a copy of the required files and deploy the web application to an AWS EC2 instance.

### Prerequisites

What you will need to deploy the webapp:


- local machine running Linux operating system preferably RHEL 7 or CentOS 7
- required software/packages installed:
```
git
terraform
aws cli
```
- Install Guides:
	* [GIT](https://www.digitalocean.com/community/tutorials/how-to-install-git-on-centos-7)
	* [Terraform](https://www.terraform.io/downloads.html)
	* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html)
- AWS account and an IAM user account with permissions to deploy ec2 instances and create security groups.
- Required environment variables set on your local with values of IAM user account key and secret key
	* AWS_ACCESS_KEY
	* AWS_SECRET_KEY
- You need to create a security group in aws ec2 given the name "sinatra" with only inbound ports 22(SSH) and 80(HTTP) allowed.


### Deployment Steps

Please run the below commands to set the environment variables and create the security group in AWS

```
export AWS_ACCESS_KEY=<key value>
export AWS_SECRET_KEY=<secret key value>
```

```
aws ec2 create-security-group --group-name sinatra --description "Security group for sinatra app"
aws ec2 authorize-security-group-ingress --group-name sinatra --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name sinatra --protocol tcp --port 80 --cidr 0.0.0.0/0
```
Note that the above steps only need to be run once off in this deployment setup


Please run the below commands on local to deploy the webapp

```
git clone https://github.com/thaibo/REA.git
```

```
terraform init
```
 - make sure that the init outputs "Terraform has been successfully initialized!"

```
terraform plan
```

``` 
terraform apply
```
 - type 'yes' when prompted to apply the plan and wait for the output "Apply complete! Resources: 1 added, 0 changed, 0 destroyed." 

### Running the webapp

- After you have completed the above steps to deploy, go to AWS console and observe the instance status until fully started. 
- Take note of the public dns (ipv4) url. It should look something similar to "ec2-13-236-94-71.ap-southeast-2.compute.amazonaws.com"
- It will take around 10 minutes for the user-data scripts to fully complete
- Once 10 minutes has passed, paste the url into a browser to see the webapp running

### Break down of deployment

Required files:

```
main.tf
user-data
```

This terraform template (main.tf) enables us to deploy an AWS EC2 instance.
Using the AWS environment variables set, we are able to connect to AWS and create the instance using the IAM user credentials.
In the template we need to provide the correct information such as:

- A provider which is AWS.
- A region, which I have chosen Asia Pacific (Syndey) for latency reasons.
- An AMI id - I have chosen a free CentOS 7 version from the AWS market place.
- Instance type - t2.micro was chosen as it is a free tier.
- We can also include a user-data script that runs on initial start up of the EC2 instance.

In the user-data bash script, we can configure the server, pull the Sinatra web app from the provided repo and start the application.
- The script first installs all the required packages e.g. developer tools, git, ruby
- Then clones the Sinatra web app repo provided by REA
- Uses bundle to install and start the application on port 80.


### Observations and alternatives

For simplicity sake, configuration such as installing developer tools, ruby, pulling the sinatra app repo, was all done in a user-data bash script which is run initially when the ec2 instance is created and deployed.
This could have also been acheived with a configuration tool such as Ansible, Chef, Puppet or the likes.
So after the instance is deployed we can apply the configuration using mentioned tools.

The user-data script also starts the webapp using port 80 on creation. The only downside to this is that the app will not automatically start on reboot. 
To resolve this we could create a systemctl start script which would start the app on reboot when enabled.
This could have been created as part of the configuration scripts in either above mentioned tools or even user-data bash script.

The security group created only allows SSH and HTTP inbound traffic (port 22 and 80).
To increase security we could have implemented the webapp using HTTPS with SSL certs configured perhaps on nginx web server and then opening up port 443.
We could also create a new DNS entry in Route53 to use a domain name that the SSL certs are created for. 

The AMI used to deploy is a free centOS 7 image from the aws market place.
We could have used a more secure AMI, perhaps a hardened version from another source which would have costed money to use.
Another alternative is to harden the AMI ourselves using "packer" which allows you to perform changes to the original AMI e.g. welcome notes, ssh config changes to disable password authenitcation, disable root login, configure firewall/IPtables etc. Then creates a new AMI which is pushed your EC2 console.
From the new hardened AMI created, we can use this AMI-id in our terraform template and deploy the EC2 instance.

## Built With

* [Terraform](https://www.terraform.io/) - Infrastructure as code service
* [GitHub](https://github.com/) - Development repository platform
* [AWS](https://aws.amazon.com/) - AWS Cloud services provider

## Authors

* **Thai Truong** - *Systems Engineer* - [thaibo](https://github.com/thaibo/REA)


