# Description

Solution to a recruitment task for Statis.im.

# Task

Create `N` geth nodes in AWS that will mine ether in __Ropsten__ and it will be easy to scale the number of nodes and monitor them.
Monitoring can be ad hoc, no need to get deep into visualization/graphs. 
Document your solution so anyone can scale this up given access to the machine.

__NOTE:__ Only CPU mining is required.

# Usage

In order to create the mining infractructure you will need to provide the required variables.
You can do that by creating a `terraform/terraform.tfvars` file.

Example:
```tfvars
pub_key_path = "~/.ssh/id_rsa.pub"
private_key_path = "~/.ssh/id_rsa"
# name of key pair to create in AWS for SSH access
key_name = "miner-admin"
# domain to which entries for created hosts should be added
domain = "mydomain.com"
# ethereum address for receiving mining rewards
etherbase = "CHANGE ME PLZ"

# number and type of miner instances to start
miner_params {
  type = "t2.small"
  count = "2"
}
```

Once that exists you can simply go into the `terraform` directory and run `terraform plan` and then `terraform apply` if you like what you see.

# Structure

The repo is divided into two sections:

* `terraform` - Contains configuration that creates the AWS infrastructure
* `ansible` - Contains provisioning for mining instances in AWS.

## Infrastructure

Using `terraform` 4 types of resources are created:

* `aws_security_group` - One for SSH access and one for exposing `30303` port for Ethereum nodes.
* `aws_key_pair` - RSA key pair used to give remote SSH access to the created instances.
* `aws_instance` - Instances that will run the Geth processes for mining.
* `aws_route53_record` - Route53 DNS entries for easier access to the instances.

In the `modules` directory reside files defining these resources.

The main configuration files are:

* `terraform/main.tf` - Defines which modules to run and provisioning afterwards.
* `terraform/variables.tf` - Requried and optional variables for infrastructure. Some provided by `terraform.tfvars`.
* `terraform/data.tf` - Pulls information from AWS, in this case about AMI and Route53 zone ID.
* `terraform/output.tf` - Defines what information `terraform` will return after successful run.

__NOTE:__ If you wish to run `ansible` separately comment out the `null_resource` section in `terraform/main.tf`.

## Provisioning

# Resources

* Infrastructure
    - https://www.terraform.io/
* Provisioning
    - http://ansible.com/
* Terraform Inventory
    - https://github.com/mantl/terraform.py
* Mining
    - https://github.com/ethereum/go-ethereum/wiki/Mining
* Monitoring
    - https://github.com/ethereum/go-ethereum/wiki/Metrics-and-Monitoring

# Notes

Neat function for estimating sync progress:
```javascript
var lastPercentage = 0, lastBlocksToGo = 0, timeInterval = 10000;
setInterval(function(){
    var percentage = eth.syncing.currentBlock/eth.syncing.highestBlock*100;
    var percentagePerTime = percentage - lastPercentage;
    var blocksToGo = eth.syncing.highestBlock - eth.syncing.currentBlock;
    var bps = (lastBlocksToGo - blocksToGo) / (timeInterval / 1000)
    var etas = 100 / percentagePerTime * (timeInterval / 1000)

    var etaM = parseInt(etas/60,10);
    console.log(parseInt(percentage,10)+'% ETA: '+etaM+' minutes @ '+bps+'bps');

    lastPercentage = percentage;lastBlocksToGo = blocksToGo;
},timeInterval);
```
