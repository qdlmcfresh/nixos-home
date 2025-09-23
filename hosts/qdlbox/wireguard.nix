{
  config,
  pkgs,
  sops-nix,
  secrets,
  ...
}:
{
  sops.secrets."wireguard/qdlbox" = {
    owner = config.users.users.root.name;
    group = config.users.groups.systemd-network.name;
    mode = "0440";
  };
  networking.wireguard.interfaces = {
    wg0 = {
      privateKeyFile = config.sops.secrets."wireguard/qdlbox".path;
      ips = [ "10.13.13.1/24" ];
      listenPort = 51820;
      peers = secrets.wireguard_peers.qdlbox;
    };
  };
  networking.firewall.allowedUDPPorts = [ 51820 ];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.src_valid_mark" = 1;
  };
}
