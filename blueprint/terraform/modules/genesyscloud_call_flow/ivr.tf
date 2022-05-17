resource "genesyscloud_architect_ivr" "emergency_ivr" {
    name = "${var.environment}-${var.prefix}-emergency-call-ivr"
}