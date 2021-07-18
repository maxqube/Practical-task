variable "region" {
	description = "Region to create resources in."
	default = "eu-central-1"
}

variable "secret_key" {
	description = "secret_key"
	default = "EqLXhQ/ShhHZPE1BbK6Lm3kTIDg7ooqHFPnV9Eqn"
	sensitive = true
}