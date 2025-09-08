{ ... }: {
  programs.firefox = {
    enable = true;

    policies = {
      DisablePocket = true;
      # install extensions like this, since configurating them with
      # home-manager doesn't enable them by default.
      ExtensionSettings = {
        # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        "tridactyl.vim@cmcaine.co.uk" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
          installation_mode = "force_installed";
        };
        "authenticator@mymindstorm" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/auth-helper/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      SearchEngines = {
        Default = "DuckDuckGo";
        PreventInstalls = true;
      };
    };

    profiles.default = {
      settings = {
        # dark theme
        browser.theme.content-theme = 0;
        browser.theme.toolbar-theme-theme = 0;
        extensions.activeThemeID = "firefox-compact-dark@mozilla.org";

        browser.newtab.extensionControlled = true;

        # disable shortcuts on new tab page
        browser.newtabpage.activity-stream.feeds.topsides = false;
      };
    };
  };
}
