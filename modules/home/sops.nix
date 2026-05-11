{
  config,
  inputs,
  ...
}:
{
#  imports = [
#    inputs.sops-nix.homeManagerModules.sops
#  ];
#
#  sops = {
#    # defaultSopsFile = "${flake.self}/secrets.yaml";
#    defaultSopsFile = "${config.home.homeDirectory}/dotfiles/secrets.yaml";
#    gnupg.home = "${config.home.homeDirectory}/.gnupg";
#
#    secrets = {
#      PULUMI_CONFIG_PASSPHRASE = {};
#    };
#  };
}
