/* REQUIRED -------------------------------------*/

variable key_name {
  description = "Name of key used to access miner instances"
}

variable pub_key_path {
  description = "Path to ssh public key used to create this key on AWS"
}

variable private_key_path {
  description = "Path to the private key used to connect to instance"
}

variable etherbase {
  description = "Eth account for receiving mining rewards."
}

variable domain {
  description = "DNS Domain to update"
}

variable env {
  description = "Environment prefix"
}

/* OPTIONAL -------------------------------------*/

variable ssh_user {
  description = "User used to log in to instance"
  default     = "ubuntu"
}

variable region {
  description = "Region"
  default     = "eu-west-1"
}

variable sentry_params {
  description = "Paramaters controlling monitoring instances"

  default = {
    "type"  = "t2.small"
    "name"  = "sentry"
  }
}

variable miner_params {
  description = "Paramaters controlling miner instances"

  default = {
    "type"  = "t2.small"
    "name"  = "miner"
    "count" = "1"
  }
}

/* This is purely for easier costs tracking */
variable default_tags {
  description = "Default tags to add to resources"

  default = {
    "purpose" = "status-im-task"
  }
}
