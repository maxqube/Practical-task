variable "region" {
	description = "Region to create resources in."
	default = "eu-central-1"
}

variable "secret_key" {
	description = "secret_key"
	default = "MKg9QekiQsTUi+CyCH8ogMhaxQ6KNH1U4OuSF7nJ"
	sensitive = true
}