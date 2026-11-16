{
  secrets,
}:
{
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 8080;

    settings = {
      server_url = "https://headscale.${secrets.domain}";

      derp = {
        server.enabled = false;
        urls = [ "https://controlplane.tailscale.com/derpmap/default" ];
        auto_update_enabled = true;
        update_frequency = "24h";
      };

      node.ephemeral.inactivity_timeout = "30m";

      dns = {
        magic_dns = true;
        base_domain = "qdl.box";
        nameservers.global = [
          "100.64.0.6"
          "https://dns10.quad9.net/dns-query"
          "100.64.0.2"
        ];
        search_domains = [ ];
        extra_records = [ ];
      };

      policy.mode = "file";
      logtail.enabled = false;
    };
  };

  services.headplane = {
    enable = true;
    settings = {
      server = {
        host = "0.0.0.0";
        port = 3000;
        # Secret lives outside the nix store; create it once on the host:
        # head -c 24 /dev/urandom | base64 | cut -c1-32 | sudo tee /var/lib/headplane/cookie_secret
        cookie_secret_path = "/var/lib/headplane/cookie_secret";
      };
      headscale = {
        url = "http://127.0.0.1:8080";
        public_url = "https://headscale.qdlbox.de";
      };
      # Login via headscale API key created with:
      #   headscale apikeys create --expiration 365d
    };
  };
}
