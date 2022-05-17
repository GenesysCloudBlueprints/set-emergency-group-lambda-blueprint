module "lambda_emergency_group" {
    source                  = "./modules/set_emergency_group_lambda"
    environment             = var.environment
    prefix                  = var.prefix
    organizationId          = var.organizationId
    aws_region              = var.awsRegion
    lambda_zip_file         = data.archive_file.lambda_zip.output_path
    lambda_source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

module "lambda_data_integration" {
    source                            = "git::https://github.com/GenesysCloudDevOps/integration-lambda-module.git?ref=main"
    environment                       = var.environment
    prefix                            = var.prefix
    data_integration_trusted_role_arn = module.lambda_emergency_group.data_integration_trusted_role_arn
}

module "lambda_data_action" {
    source                 = "git::https://github.com/GenesysCloudDevOps/data-action-lambda-module.git?ref=main"
    environment            = var.environment
    prefix                 = var.prefix
    secure_data_action     = false
    genesys_integration_id = module.lambda_data_integration.genesys_integration_id
    lambda_arn             = module.lambda_emergency_group.lambda_arn
    data_action_input      = file("${path.module}/../contracts/data-action-input.json")
    data_action_output     = file("${path.module}/../contracts/data-action-output.json")
}

module "genesyscloud_call_flow" {
    source                   = "./modules/genesyscloud_call_flow"
    secondary_flow_file_path = "./flows/spare_flow.yml"
    prefix                   = var.prefix
    environment              = var.environment
}