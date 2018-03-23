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
# prefix for domain before hostnames, ex: miner-01.geth.mydomain.com
env = "geth"
# ethereum address for receiving mining rewards
etherbase = "CHANGE ME PLZ"

# number and type of miner instances to start
miner_params {
  type = "t2.small"
  count = "2"
}
```

Once that exists you can simply go into the `terraform` directory and run `terraform plan` and then `terraform apply` if you like what you see.

To configure __miner__ hosts separately you can run `ansible`:
```bash
cd ansible && ansible-playbook miner.yml -e "etherbase=CHANGE_ME"
```

Same can be done for the __sentry__ host:
```bash
cd ansible && ansible-playbook sentry.yml
```

# Details

The repo is divided into two sections:

* `terraform` - Contains configuration that creates the AWS infrastructure
* `ansible` - Contains provisioning for mining instances in AWS.

## Infrastructure

There are two types of hosts this creates:

* `miners` - Hosts that run `geth` for mining.
* `sentry` - Hosting Graphite and Grafana for metrics.

The __miners__ are mining in Ropsten Proof-of-Work chain using CPU.
This is inefficient but good enough for a test.

The __sentry__ is there to collect metrics and provide a UI for exploring them.

## Provisioning

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

## Configuration

Using `ansible` provisioned hosts are configured for their respective roles using playbooks:

* `ansible/miner.yml` - Configures __miners__ to run `geth` and send metrics.
* `ansible/sentry.yml` - Configures __sentry__ to run [Graphite](https://graphiteapp.org/) and [Grafana](https://grafana.com/)

A set of roles configures the necessary services:

* `ansible/roles/common` - Installs common utilities like `htop` or `netstat`.
* `ansible/roles/docker` - Installs [Docker](https://www.docker.com/) to enable use of containers
* `ansible/roles/miner` - Configures [`go-ethereum`](https://github.com/ethereum/go-ethereum/) client
* `ansible/roles/monitoring-client` - Configures [netdata](https://my-netdata.io/) for monitoring miners
* `ansible/roles/monitoring-server` - Configures [Graphite](https://graphiteapp.org/) and [Grafana](https://grafana.com/)



# TODO

* SSL certificates for web services like Grafana
* Auth for netdata running on __miners__
* Backups of Grafana dashboards
* Backups of `geth` blockchain to reduce sync time
* Find why metrics not starting with `eth` don't get saved in graphite

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
    - https://github.com/firehol/netdata
    - https://github.com/titpetric/netdata
* Metrics
    - https://statsd.readthedocs.io/
    - https://github.com/firehol/netdata/wiki/statsd
    - https://github.com/ethereum/go-ethereum/wiki/Metrics-and-Monitoring
