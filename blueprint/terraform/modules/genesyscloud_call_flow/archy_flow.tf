resource "genesyscloud_flow" "secondary_flow" {
    filepath = "${var.secondary_flow_file_path}"
}