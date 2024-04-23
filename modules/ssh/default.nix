{ config, ... }:
{
  users.users.qdl.openssh.authorizedKeys.keyFiles = [
    ./id_rsa.pub
    ./id_rsa_oracle.pub
    ./desktop.pub
  ];
}
