{ configs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
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
      ];
      allowedUDPPorts = [
        3702 # wsdd
      ];
    };
  };

  services =
    {
      openssh.enable = true;
      samba-wsdd.enable = true;
      samba = {
        enable = true;
        openFirewall = true;
        securityType = "user";
        extraConfig = ''
          workgroup = WORKGROUP
          server string = micro
          netbios name = micro
          security = user
          guest account = smb
          map to guest = bad user
          local master = yes
          preferred master = yes
        '';
        shares = {
          public = {
            path = "/home/smb";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "yes";
            "create mask" = "0644";
            "directory mask" = "0755";
          };
        };
      };
    };

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
