output "url" {
  value = "http://${google_compute_instance.ldap.network_interface[0].access_config[0].nat_ip}/ldapadmin/"
}