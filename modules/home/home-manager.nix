{ config, pkgs, inputs, lib, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${config.home.username}";
  home.shell.enableShellIntegration = true;
  home.shell.enableBashIntegration = true;

  nixpkgs.config.allowUnfree = true;

  home.file = let
    # editable symlink
    link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dotfiles/${path}";
  in {
    ".emacs.d".source = link ".emacs.d";
    ".xinitrc" = {
      executable = true;
      text = ''
         # Source Home Manager's xsession script
         if [ -f "$HOME/.xsession" ]; then
            exec "$HOME/.xsession"
         fi
       '';
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.home-manager.path = "/home/gator/dormant/home-manager";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
