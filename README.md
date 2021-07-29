# OpenVPN, NGINX and custom monitoring script with Terraform and Ansible on AWS

This repository provides fully automatic deployment to AWS account. It deploys a private VPN on one instance and sets up default NGINX server with monitoring script that monitors CPU usage & Disk space and sends emails in case treshold is reached on another instance, using Terraform and Ansible.

## Prerequisites

### 1) Install Git and clone current repositiry

- on Ubuntu: 
```bash
sudo apt install git
git clone https://github.com/maxqube/Practical-task.git
```

### 2) Install AWS CLI

 See following guide: https://docs.aws.amazon.com/cli/latest/userguide/installing.html

### 3) Configure an admin user

if user already exists - skip this step
1.  Go to https://console.aws.amazon.com/iamv2/home?#/users
2.  Choose a username _(e.g. terraform)_ and give programmatic access
3.  Add exiting policy: _AdministratorAccess_
4.  Download Key-Pair.csv file
5.  Configure aws-cli using Access & Secret keys

```bash
aws configure
AWS Access Key ID [None]: <Your Access Key>
AWS Secret Access Key [None]: <Your Secret Access Key>
Default region name [None]: <preferred region>
Default output format [None]: <>
```

### 4) Create and configure a ssh key-pair to access the EC2 instances.

1. Go to https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#KeyPairs:
2. Enter key name e.g. `terraform-key` and save it in .pem extension
3. Key name should be specified in _\terraform\modules\ec2\variables.tf_

### 5) Add *.pem file for ansible authentication

1. Create directory

```bash
mkdir ~/.ssh
cd ~/.ssh
vim terraform-key.pem
```
3. Copy-paste key contents, save the file
4. Change permissions and add identity

```bash
chmod 600 terraform-key.pem
ssh-add terraform-key.pem
```
5. Identity added confirmation should appear, in case message is not shown run `eval "$(ssh-agent -s)"`before ssh-add

### 6) Install Ansible

- On Ubuntu: `sudo apt install ansible`

For other operating systems see https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

### 7) Install Terraform and configure access keys

- On Ubuntu:

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

For other operating systems see https://learn.hashicorp.com/tutorials/terraform/install-cli

1. Add the AWS credentials from step 3.4 to your environment

```bash
export AWS_ACCESS_KEY_ID=YOUR_AWS_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_AWS_SECRET
export AWS_DEFAULT_REGION=YOUR_AWS_REGION
```

## Configuration

### 1) Terraform variables with description may be found in _variables.tf_ files under _/terrafrom_ root folder or in _terraform/modules_ folders

1. Modify those variables according to your needs, or stick with defauls.
- Key-Pair variable, created in Prerequisites step 4, is located under _terraform/modules/ec2/variables.tf_ 
2. Default user for ansible connection is located in _terraform\modules\ec2\variables.tf_

### 2) Modify the default variables of the openvpn ansible role as you wish _/ansible/roles/openvpn/defaults/main.yml_

note: Modify user for `ca_dir` variable if needed 

```yml
ovpn_cidr: 10.3.0.0/24
ovpn_network: 10.3.0.0 255.255.255.0
ovpn_push_routes:
  - 10.0.0.0 255.0.0.0

ca_dir: /home/ec2-user/ca

ca_key_country: UKR
ca_key_city: Lviv
ca_key_org: MyOrganization
ca_key_email: your.email@organization.org
ca_key_org_unit: MyOrganizationalUnit
ca_key_name: vpn_server
```

### 3) Define e-mail to receive monitoring notifications in _ansible\roles\monitoring\files\metrics.sh_ email variable

## Setup

### 1) Bootstrap the infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2) Wait till both EC2 instances are ready

1. Ansible inventory and custom .cfg files will be populated automatically

### 3) Install OpenVPN on the EC2 Instance

This will download a zip file with client openvpn configuration and keys to your host.

```bash
cd ansible

# This will also add a client
ansible-playbook -i inventory openvpn_install.yml -e "username=ec2-user" -e "output=/tmp/ec2_vpn.zip"
```

### 4) Install NGINX and set up monitoring script

```bash
ansible-playbook -i inventory nginx_and_monitoring.yml
```

## Verification

### 1) Verify that default NGIX web page is reachable

1. Open _/ansible/inventory_ file and copy IP under [webserver] node
2. Paste IP into the browser and set port to :80 _(e.g. xxx.xx.xx.xx:80)_
3. "Welcome to nginx on Amazon Linux!" web page should be displayed

### 2) Verify monitoring script and cron job

1. Using key *.pem created in Prerequisites 4.2 SSH to EC2 instance
2. Check that file _/home/monitoringscript/metrics.sh_ is present
3. Run
```bash
sudo crontab -e
```
4. Verify that cronjob is present and set to be run every 5 minutes

### 3) Verify VPN

1. Download OpenVPN client to your host
2. Unzip client VPN files from _/tmp/{username}.zip_ 
3. Import certificates to VPN config folder, connect
4. Ping EC2 private IP _can be obtained from inventory file, vpn-gateway value_