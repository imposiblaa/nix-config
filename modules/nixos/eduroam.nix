# Eduroam (UW) WiFi configuration using EAP-TLS
# Prerequisites (one-time manual setup):
#   sudo mkdir -p /etc/ssl/eduroam
#   nix-shell -p openssl --run "openssl pkcs12 -in ~/Downloads/colinjn@uw.edu.p12 -nokeys -clcerts -passin 'pass:a7H@T*XDIG2i#6' -out /tmp/client.pem"
#   nix-shell -p openssl --run "openssl pkcs12 -in ~/Downloads/colinjn@uw.edu.p12 -nocerts -nodes -passin 'pass:a7H@T*XDIG2i#6' -out /tmp/private.pem"
#   sudo mv /tmp/client.pem /tmp/private.pem /etc/ssl/eduroam/
#   sudo chmod 600 /etc/ssl/eduroam/private.pem
{...}: {
  networking.networkmanager.ensureProfiles.profiles.eduroam = {
    connection = {
      id = "eduroam";
      type = "wifi";
    };
    wifi = {
      ssid = "eduroam";
      mode = "infrastructure";
    };
    "wifi-security" = {
      "key-mgmt" = "wpa-eap";
      "auth-alg" = "open";
    };
    "802-1x" = {
      eap = "tls";
      identity = "colinjn@uw.edu";
      "anonymous-identity" = "anonymous@uw.edu";
      "ca-cert" = "/etc/ssl/certs/ca-certificates.crt";
      "client-cert" = "/etc/ssl/eduroam/client.pem";
      "private-key" = "/etc/ssl/eduroam/private.pem";
      "private-key-password-flags" = 4;
      "domain-suffix-match" = "radius.uw.edu";
    };
    ipv4 = {
      method = "auto";
    };
    ipv6 = {
      "addr-gen-mode" = "stable-privacy";
      method = "auto";
    };
  };
}
