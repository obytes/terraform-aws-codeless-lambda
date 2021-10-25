variable "prefix" {}

variable "common_tags" {
  type = map(string)
}

variable "description" {
  default = "Codeless lambda so code CI CD can be managed externally"
}

variable "runtime" {
  default = "python3.7"
}

variable "handler" {
  default = "app.runtime.lambda.main.handler"
}

variable "memory_size" {
  default = 512
}

variable "timeout" {
  default = 29
}

variable "envs" {
  type = map(string)
}

variable "policy_json" {
  type    = string
  default = null
}

variable "logs_retention_in_days" {
  default = 1
}
