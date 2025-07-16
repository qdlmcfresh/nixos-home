{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems."/mnt/fuji" = {
    device = "//fuji-server/public";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [
        "${automount_opts},guest,uid=${toString config.users.users.qdl.uid},gid=100"
      ];
  };
}
