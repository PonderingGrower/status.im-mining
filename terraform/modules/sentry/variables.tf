variable pub_key_path {
  description = "Path to ssh public key used to create this key on AWS"
}

variable ssh_user {
  description = "User used to log in to instance"
}

variable private_key_path {
  description = "Path to the private key used to connect to instance"
}

variable env {
  description = "Environment prefix"
}

variable zone_id {
  description = "Zone ID of DNS domain to update"
}

variable domain {
  description = "DNS domain to update"
}

variable ami {
  description = "Instance AMI"
}

variable instance_type {
  description = "Instance type"
  default     = "t2.micro"
}

variable sg_id {
  description = "Base security group"
}

variable key_name {
  description = "Name of ssh key for instance access"
}

variable miner_sec_group {
  description = "Security group used by miners that will send metrics"
}

variable count {
  description = "Number of instances to create"
  default     = "1"
}

variable name {
  description = "Server name"
  default     = "miner"
}

variable default_tags {
  description = "Default tags"
  type        = "map"
}
