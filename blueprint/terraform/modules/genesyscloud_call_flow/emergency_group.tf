resource "genesyscloud_architect_emergencygroup" "emergency-group" {
    name    = "${var.environment}-${var.prefix}-emergency-group"
    enabled = false
    emergency_call_flows {
        emergency_flow_id = "${genesyscloud_flow.secondary_flow.id}"
        ivr_ids           = ["${genesyscloud_architect_ivr.emergency_ivr.id}"]
    }
}