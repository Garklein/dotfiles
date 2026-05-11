{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    gnupg.home = "${config.home.homeDirectory}/.gnupg";

    secrets = {
      # PULUMI_CONFIG_PASSPHRASE = {};
    };
  };
}
