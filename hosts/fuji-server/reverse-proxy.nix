{
  secrets,
  ...
}:
{
  users.users.nginx.extraGroups = [ "acme" ];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "1000M";
    virtualHosts = {
      "paperless.${secrets.domain} paperless.lan" = {
        useACMEHost = "${secrets.domain}";
        addSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:28981";
          proxyWebsockets = true;
        };
      };
      "mealie.${secrets.domain} mealie.lan" = {
        useACMEHost = "${secrets.domain}";
        addSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000";
          proxyWebsockets = true;
        };
      };
      "adguard.${secrets.domain} adguard.lan" = {
        useACMEHost = "${secrets.domain}";
        addSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };
      "books.${secrets.domain} bookshelf.lan" = {
        useACMEHost = "${secrets.domain}";
        addSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8000";
          proxyWebsockets = true;
        };
      };
      "notes.${secrets.domain} notes.lan" = {
        useACMEHost = "${secrets.domain}";
        addSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:6806";
          proxyWebsockets = true;
        };
      };
      "papers.${secrets.domain} papers.lan" = {
        useACMEHost = "${secrets.domain}";
        addSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8474";
          proxyWebsockets = true;
        };
      };
      "dawarich.${secrets.domain} dawarich.lan" = {
        useACMEHost = "${secrets.domain}";
        addSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3123";
          proxyWebsockets = true;
        };
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = secrets.acme_email;
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      environmentFile = "/run/secrets/cloudflare_env";
    };
    certs = {
      "${secrets.domain}" = {
        extraDomainNames = [ "*.${secrets.domain}" ];
      };
    };
  };
}
