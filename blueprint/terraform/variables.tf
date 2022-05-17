variable "prefix" {
    type        = string
    description = "A name that is to be used as the resource name prefix. Usually it's the project name."
}

variable "environment" {
    type        = string
    description = "Name of the environment, e.g., dev, test, stable, staging, uat, prod etc."
}

variable "organizationId" {
    type        = string
    description = "Genesys Cloud Organization Id"
}

variable "clientId" {
    type        = string
    description = "The Genesys Cloud client ID."
}

variable "clientSecret" {
    type        = string
    description = "The Genesys Cloud client secret."
}

variable "awsRegion" {
    type        = string
    description = "AWS Region you are deploying the lambda to"
}

variable "genesysCloudAccountArn" {
    type        = string
    description = "The AWS arn for the Genesys Cloud environment"
    default     = "arn:aws:iam::765628985471:root" 
}

variable "did_numbers" {
    type        = list(string)
    description = "The phone numbers that route to our flow (should be defined in order)"
}