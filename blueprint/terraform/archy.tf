data "genesyscloud_flow" "flow" {
    name       = "${var.environment}-${var.prefix}-Call-Flow"
    depends_on = [genesyscloud_flow.flow]
}

resource "genesyscloud_flow" "flow" {
    filepath   = "./flows/main_flow.yaml"

    substitutions = {
        prefix       = "${var.environment}-${var.prefix}"
        clientId     = "${var.clientId}"
        clientSecret = "${var.clientSecret}"
        groupID      = "${module.genesyscloud_call_flow.emergency_group_id}"
    }

    depends_on = [
        module.lambda_data_action,
        module.genesyscloud_call_flow
    ]
}