resource "genesyscloud_architect_ivr" "ivr" {
    name               = "${var.environment}-${var.prefix}-call-ivr"
    open_hours_flow_id = "${data.genesyscloud_flow.flow.id}"
    dnis               = var.did_numbers
    depends_on         = [genesyscloud_telephony_providers_edges_did_pool.did_pool]
}

resource "genesyscloud_telephony_providers_edges_did_pool" "did_pool" {
    start_phone_number = var.did_numbers[0]
    end_phone_number   = var.did_numbers[length(var.did_numbers)-1]
}