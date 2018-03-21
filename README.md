# Description

Solution to a recruitment task for Statis.im.

# Task

Create `N` geth nodes in AWS that will mine ether in __Ropsten__ and it will be easy to scale the number of nodes and monitor them.
Monitoring can be ad hoc, no need to get deep into visualization/graphs. 
Document your solution so anyone can scale this up given access to the machine.

# Usage

In order to create the mining infractructure you will need to provide the required variables.
You can do that by creating a `terraform/terraform.tfvars` file.

Example:
```tfvars
pub_key_path = "~/.ssh/id_rsa.pub"
private_key_path = "~/.ssh/id_rsa"
key_name = "miner-admin"
domain = "mydomain.com"
etherbase = "Ethereum address for receiving mining rewards"

# number and type of miner instances to start
miner_params {
  type = "t2.small"
  count = "2"
}
```

Once that exists you can simple run `terraform plan` and then `terraform apply` if you like what you see.

# Resources

* Infrastructure
    - https://www.terraform.io/
* Provisioning
    - http://ansible.com/
* Terraform Inventory
    - https://github.com/mantl/terraform.py
