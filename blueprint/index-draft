---
title: Enable an emergency group by calling an AWS Lambda via a Genesys Cloud Data Action
author: charlie.conneely
indextype: blueprint
icon: blueprint
image: images/diagram.png
category: 5
summary: |
  This Genesys Cloud Developer blueprint demonstrates how to trigger an AWS Lambda function from a Genesys Cloud data action in order to properly enable an emergency group.
---

This blueprint demonstrates how to:

* Build an AWS Lambda function to interact with the Genesys Cloud public API.
* Build the necessary AWS IAM Roles to allow for a data action to interact with AWS Lambda.
* Build a Genesys Cloud data action and integration, configured with the correct Amazon Role ARN.
* Deploy all of this infrastructure using Terraform and CX as Code. 

## Scenario

From your Architect flow, you want to trigger a data action that will enable or disable an emergency group by ID. However, the Architect API only provides a PUT method to accomplish this, which will overwrite the emergency group and disconnect all of its associated IVRs unless their GUIDs are provided in the request body. As a work-around, we will need to perform a GET operation on said emergency group, change the value of `enabled` in the response object, and use this JSON data as our request body in the PUT operation. However, since these operations can not be easily accomplished from within an Architect flow, we will need to export this logic elsewhere. 

## Solution

* Create an AWS Lambda function that will utilize the Genesys Cloud Go SDK to perform these GET and PUT operations. 
* Create the necessary IAM roles and policies.
* Create a Genesys Cloud lambda integration and data action to trigger our AWS lambda function.  

## Contents 

* [Solution Components](#solution-components "Goes to the Solution Components section")
* [Software Development Kits](#software-development-kits "Goes to the Software Development Kits section")
* [Prerequisites](#prerequisites "Goes to the Prerequisites section")

## Solution Components

* **Genesys Cloud** - A suite of Genesys Cloud services for enterprise-grade communications, collaboration, and contact center management. In this solution, you use a Genesys Cloud integration and data action.
* **CX as Code** - A Genesys Cloud Terraform provider that provides an interface for declaring core Genesys Cloud objects.
* **AWS Terraform Provider** - An Amazon supported Terraform provides an interface for declaring Amazon Web Services infrastructure.
* **AWS Lambda** - A serverless computing service for running code without creating or maintaining the underlying infrastructure. For more information, see [AWS Lambda](https://aws.amazon.com/lambda/ "Opens the Amazon AWS Lambda page") in the Amazon featured services website. 

## Software development kits

There are no required SDKs needed for this project.  This project contains everything you need to deploy the blueprint, including a pre-compiled version of the AWS lambda. 

If you wish to make changes to the AWS lambda, the source code can be found in the `lambda-code` directory.  To build this lambda, you will need the Golang SDK.  The latest Golang version of Golang can be found [here](https://go.dev/).  To rebuild the lambda from the source code:

1. Have the Golang SDK installed on the machine.
2. Change to the `blueprint/lambda-code` directory.
3. Issue the following build command: `GOOS=linux go build -o bin/main ./...`

This will build a Linux executable called `main` in the `bin` directory.  The CX as Code scripts will compress this executable and deploy the zip as part of the AWS Lambda deploy via Terraform.

**NOTE: The executable built above will only run on Linux. Golang allows you build Linux executables on Windows and OS/X, but you will not be able to run them locally.**

## Prerequisites

### Specialized knowledge

* Administrator-level knowledge of Genesys Cloud
* AWS Cloud Practitioner-level knowledge of AWS IAM and AWS Lambda
* Experience with Terraform

### Genesys Cloud account

* A Genesys Cloud license. For more information, see [Genesys Cloud Pricing](https://www.genesys.com/pricing "Opens the Genesys Cloud pricing page") in the Genesys website.
* Master Admin role. For more information, see [Roles and permissions overview](https://help.mypurecloud.com/?p=24360 "Opens the Roles and permissions overview article") in the Genesys Cloud Resource Center.
* CX as Code. For more information, see [CX as Code](https://developer.genesys.cloud/api/rest/CX-as-Code/ "Opens the CX as Code page").

### AWS account

* An administrator account with permissions to access the following services:
  * AWS Identity and Access Management (IAM)
  * AWS Lambda
  * AWS credentials. For more information about setting up your AWS credentials on your local machine, see [About credential providers](https://docs.aws.amazon.com/sdkref/latest/guide/creds-config-files.html "Opens the About credential providers page") in AWS documentation.

### Development tools running in your local environment

* Terraform (the latest binary). For more information, see [Download Terraform](https://www.terraform.io/downloads.html "Opens the Download Terraform page") in the Terraform website.
* Golang 1.16 or higher. For more information, see [Download Golang](https://go.dev/ "Opens the Golang website").

## Implementation steps

1. [Clone the GitHub repository](#clone-the-github-repository "Goes to the Clone the GitHub repository section")
2. [Setup your AWS and Genesys Cloud Credentials](#setup-your-aws-and-genesys-cloud-credentials "Goes to the Setup your AWS and Genesys Cloud Credentials section")
3. [Configure your Terraform build ](#configure-your-terraform-build "Goes to the Configure your Terraform build")
4. [Run Terraform](#run-terraform "Goes to the Run Terraform section")
5. [Test the deployment](#test-the-deployment "Goes to the Test the deployment section")

### Clone the GitHub repository

Clone the GitHub repository [set-emergency-group-lambda-blueprint](https://github.com/GenesysCloudBlueprints/set-emergency-group-lambda-blueprint "Opens the GitHub repository") to your local machine. The `set-emergency-group-lambda-blueprint/blueprint` folder includes solution-specific scripts and files in these subfolders:
* `lambda-code` - Source code for the lambda function.
* `terraform` - All Terraform files to deploy the application.

### Setup your AWS and Genesys Cloud Credentials

In order to run this project using the AWS and Genesys Cloud Terraform provider you must open a terminal window, set the following environment variables and then run Terraform in the window where the environment variables are set. These variable are listed below:

 * `GENESYSCLOUD_OAUTHCLIENT_ID` - This is the Genesys Cloud client credential grant Id that CX as Code executes against. 
 * `GENESYSCLOUD_OAUTHCLIENT_SECRET` - This is the Genesys Cloud client credential secret that CX as Code executes against. 
 * `GENESYSCLOUD_REGION` - This is the Genesys Cloud region in which your organization is located.
 * `AWS_ACCESS_KEY_ID` - This the AWS Access Key you must setup in your Amazon account to allow the AWS Terraform provider to act against your account.
 * `AWS_SECRET_ACCESS_KEY` - This the AWS Secret you must setup in your Amazon account to allow the AWS Terraform provider to act against your account.

**Note:** For the purposes of this project the Genesys Cloud OAuth Client was given the master admin role.

### Configure your Terraform build

There are a number of values that are specific to your AWS region and Genesys Cloud organization.  These values can be defined in the `blueprint/terraform/dev.auto.tfvars` file.

The values that need to be set include:

* `organizationId` - Your Genesys Cloud organization id.
* `clientId` - Your Genesys Cloud oauth client id.
* `clientSecret` - Your Genesys Cloud oauth client secret.
* `awsRegion` - The AWS region (e.g. us-east-1, us-west-2) where you are going to deploy the target AWS lambda. 
* `environment` - This a free-form field that will be combined with the prefix value to define the name of various AWS and Genesys Cloud artifacts. For example, if you set the environment name to be `dev` and the prefix to be `foo` your AWS Lambda, IAM roles, Genesys Cloud Integration and Data Actions will all begin with `dev-foo`.
* `prefix`- This a free-form field that will be combined with the environment value to define the name of various AWS and Genesys Cloud artifacts.
* `did_numbers` - The Direct Inward Dialing numbers that you want to associate with the call IVR.

The following is an example of the `dev.auto.tfvars` used by the author of this blueprint.

```
organizationId         = "011a0480-9a1e-4da9-8cdd-2642474cf92a"
clientId               = "1de2ef16-a1b2-5f9z-ae41-72p3a14037pl"
clientSecret           = "plR-123gtj3rIY2ecWpakmlaSgi622Ws2BAyixWbTre"
awsRegion              = "us-east-1"
environment            = "dev"
prefix                 = "enable-egroup"
genesysCloudAccountArn = "arn:aws:iam::123456789012:root"
did_numbers            = ["+12345678910"]
```

### Run Terraform

Once the environment variables and Terraform configuration from the previous steps has been set, you are now ready to run this blueprint against your organization. Change to the `blueprints/terraform` directory and issue the following commands:

1. `terraform plan` - This will execute a trial run against your Genesys Cloud organization and show you a list of all the AWS and Genesys Cloud resources that will be created. Review this list and make sure you are comfortable with the activity being undertake before continuing to the second step.

2. `terraform apply --auto-approve` - This will do the actual object creation and deployment against your AWS and Genesys Cloud accounts. The --auto--approve flag will step the approval step required before creating the objects.

Once the `terraform apply --auto-approve` command has completed you should see the output of the entire run along with the number of objects successfully created by Terraform. There are two things to keep in mind here:

1.  This project assumes you are running using a local Terraform backing state. This means that the `tfstate` files will be created in the same directory where you ran the project. Terraform does not recommend using local Terraform backing state files unless you are running from a desktop and are comfortable with the files being deleted.

2. As long as your local Terraform backing state projects are kept you can teardown the blueprint in question by changing to the `blueprint/terraform` directory and then issuing a `terraform destroy --auto-approve` command. This will destroy all objects currently managed by the local Terraform backing state.

### Test the deployment

Dial a phone number that was provided to the `did_numbers` variable and follow the instructions. From this call flow, you can enable or disable the emergency group using the dial pad. If all went well, you should notice that you can now enable or disable this emergency group, using the custom data action, without disconnecting any of its IVRs. 

Thanks for reading!

## Additional Resources

* [Genesys Cloud data actions integrations article](https://help.mypurecloud.com/?p=209478 "Opens the data actions integrations article") in the Genesys Cloud Resource Center
* [Genesys Cloud data actions/lambda integrations article](https://help.mypurecloud.com/articles/about-the-aws-lambda-data-actions-integration/ "Opens the data actions/lambda integrations article") in the Genesys Cloud Resource Center.
* [Terraform Registry Documentation](https://registry.terraform.io/providers/MyPureCloud/genesyscloud/latest/docs "Opens the Genesys Cloud provider page") in the Terraform documentation
* [Genesys Cloud DevOps Repository](https://github.com/GenesysCloudDevOps "Opens the Genesys Cloud DevOps Github"). 

