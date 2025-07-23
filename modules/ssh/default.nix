{ config, ... }:
{
  users.users.qdl.openssh.authorizedKeys.keyFiles = [
    ./id_rsa.pub
    ./id_rsa_oracle.pub
    ./id_25519.pub
    ./desktop.pub
    ./vw-ssh.pub
  ];
}
