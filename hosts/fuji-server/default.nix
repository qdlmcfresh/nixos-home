{
  config,
  pkgs,
  secrets,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/steam-cmd.nix
    ./reverse-proxy.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      devices = [ "/dev/sda" ];
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  networking = {
    hostName = "fuji-server";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22 # ssh
        5357 # wsdd
        28981 # paperless
        80 # nginx
        443 # nginx
        53 # dns
      ];
      allowedUDPPorts = [
        3702 # wsdd
        53 # dns
      ];
    };
  };

  virtualisation.docker.enable = true;
  environment.systemPackages = [ pkgs.zulu17 ];

  services = {
    openssh.enable = true;
    samba-wsdd.enable = true;
    samba = {
      enable = true;
      openFirewall = true;
      securityType = "user";
      settings = {
        global = {
          workgroup = "WORKGROUP";
          security = "user";
          "server string" = "micro";
          "netbios name" = "micro";
          "guest account" = "smb";
          "map to guest" = "bad user";
          "local master" = "yes";
          "preferred master" = "yes";
        };
        public = {
          browseable = "yes";
          path = "/home/smb";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
      };
    };
    paperless = {
      enable = true;
      package = pkgs.stable.paperless-ngx;
      consumptionDir = "/home/smb/scans";
      consumptionDirIsPublic = true;
      address = "0.0.0.0";
      settings = {
        PAPERLESS_AUTO_LOGIN_USERNAME = "admin";
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_FORCE_SCRIPT_NAME = "/paperless";
        PAPERLESS_STATIC_URL = "/paperless/static/";
        PAPERLESS_USE_X_FORWARD_HOST = "true";
        PAPERLESS_USE_X_FORWARD_PORT = "true";
        PAPERLESS_OCR_ROTATE_PAGES_THRESHOLD = "7";
      };
    };
    adguardhome = {
      enable = true;
      openFirewall = true;
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "server";
    };
    audiobookshelf = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
    };
    mealie = {
      enable = true;
      package = pkgs.stable.mealie;
    };
    openvpn = {
      servers = {
        hs-vpn = {
          config = ''config /run/secrets/openvpn/hs-openvpn-config '';
        };
      };
    };
    cloudflare-dyndns = {
      enable = true;
      apiTokenFile = config.sops.secrets.cloudflare_dns_api_qdlbox.path;
      domains = [ secrets.home_domain ];
      ipv4 = true;
    };
  };
  systemd.services.vaultwarden_backup = {
    description = "Rsync backup service";
    wantedBy = [
      "multi-user.target"
      "network-online.target"
    ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.rsync}/bin/rsync -avz --chown=qdl:users -e '${pkgs.openssh}/bin/ssh' qdl@vps.qdlbox.de:~/docker/backup /home/qdl/vaultwarden_backup";
    };
  };
  systemd.timers.vaultwarden_backup = {
    description = "Rsync backup timer";
    timerConfig = {
      OnCalendar = "08:00";
      Unit = "vaultwarden_backup.service";
    };
    enable = true;
  };
  powerManagement.powertop.enable = true;
  users.users.smb = {
    isNormalUser = true;
    home = "/home/smb";
    homeMode = "777";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGvUpLK6QzRtX5FHfdLrt37cQZcGFXmOmkQmWOv5YH7irOVVpj+/MeN6KWziTGPvdYmq1SOVbYnCrEoCgSlChE4ZUt9DFcpPhgKDzkVZVK2y25EEVEnxO2p64J0OtTt54rl3ODvzc0a5wSI5aVJSGaVVtaUWlwRESs3DdD9Y0XxmpW2vxP+z7SOrNFQqfGLOXp9PXu3BPF6G6ZeGxu5fBhoiInX6dKf3NvLYwaT9ZXy0Ur279LowCw4R9kMDzNb4KPJcC7Q04VsFtzyf83uxOmpFwFOWfXKIWd+/8RdfjJrVR+7SWXiuH4x9Fsb0ofmis7vg7sud1Hp/xI/ZRbk6W3"
  ];

  system.stateVersion = "23.05";
  nix.settings.trusted-users = [ "nixremote" ];
}
