output "ldapadmin" {
  value = "http://${google_compute_instance.ldap-server.network_interface[0].access_config[0].nat_ip}/ldapadmin/"
}

output "ssh" {
  value = "ssh my_user@${google_compute_instance.ldap-client.network_interface[0].access_config[0].nat_ip}"
}

/*output "internalIP" {
  value = google_compute_instance.ldap-server.network_interface.0.network_ip
}*/