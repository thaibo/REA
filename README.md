# Simple Sinatra App Deployment

Deployment of a simple sinatra web application to an AWS instance

## Getting Started

These instructions will get you a copy of the required files and deploy the web application to an AWS EC2 instance.

### Prerequisites

What you will need to deploy the webapp:


- local machine running Linux operating system preferably RHEL 7 or CentOS 7
- required software/packages installed:
	git
	terraform
        aws cli
- Install Guides:
* [GIT](https://www.digitalocean.com/community/tutorials/how-to-install-git-on-centos-7)
* [Terraform](https://www.terraform.io/downloads.html)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html)
- aws account and an IAM user account with permissions to deploy ec2 instances and create security groups.
- required environment variables set on your local with values of IAM user account key and secret key
	AWS_ACCESS_KEY
	AWS_SECRET_KEY
- you need to create a security group in aws ec2 given the name "sinatra" with only inbound ports 22(SSH) and 80(HTTP) allowed.


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

After you have completed the above steps to deploy, go to AWS console and observe the instance status until fully started
Take note of the public dns (ipv4) url
It will take around 10 minutes for the user-data scripts to fully complete
Once 10 minutes has passed, paste the url into a browser to see the webapp

### Break down of deployment



### Observations and alternatives



## Built With

* [Terraform](https://www.terraform.io/) - Infrastructure as code service
* [GitHub](https://github.com/) - Development repository platform
* [AWS](https://aws.amazon.com/) - AWS Cloud services provider

## Authors

* **Thai Truong** - *Initial work* - [thaibo](https://github.com/thaibo/REA)

