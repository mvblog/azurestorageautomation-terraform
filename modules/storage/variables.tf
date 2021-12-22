variable "rgname" {
  type = string
} 

variable "location" {
  type = string
}

variable "objectid" {
  type = map
}

variable "subnetid" {
  type = list(string)
}

variable "saname" {
  type = string
}

variable "fs" {
  type = list(string)
}

variable "sa" {
  description = "List of filesystems to create"
  type        = map
  default     = {
    sa1 = ["fs1","fs2"],
    sa2 = ["fs1","fs2"]
  }
}

variable "keyvault" {
  type = string
}

variable "keyvaultresourcegroup" {
  type = string
}

variable "fsacl" {
  description = "List of acl to create for each fs"
  type        = map(object({
    grpread: list(string),
    grpwrite: list(string),
    usrread: list(string),
    usrwrite: list(string)
  }))
  default     = {
    "fs" = { 
       grpread = null
       grpwrite = null
       usrread = null
       usrwrite = null
    } 
  }
}

variable "enckeyname" {
type = string
}

variable "enckeyversion" {
type  = string 
}

variable "salockname" {
  type = string
}

variable "tagsmap" {
  type = map
}





