{ inputs, pkgs, ... }:


{
  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    addKeysToAgent = "yes";
    compression = true;
    extraConfig = ''
      IdentityFile ~/.ssh/id_ed25519
      User bdebotte
      '';
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identitiesOnly = true;
      };
    };
  };


  programs.git.signing.format = "openpgp";



  services.ssh-agent.enable = true;

  programs.google-chrome = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {cfg.enableTridactylNative = true;};
    profiles.bdebotte = {
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        darkreader
        tridactyl
        facebook-container
        i-dont-care-about-cookies
        proton-pass
        to-google-translate
        ublock-origin
        view-image
        youtube-shorts-block
      ];
      settings = {
        # Performance settings
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true;

        # Reader mode
        "reader.parse-on-load.force-enabled" = true;

        # WebRTC sharing indicator (annoying with tiling WMs)
        "privacy.webrtc.legacyGlobalIndicator" = false;

        # Mozilla Account & Sync
        "identity.fxaccounts.enabled" = true;          # <-- modifié
        "services.sync.engine.addons" = true;           # <-- ajouté
        "services.sync.engine.bookmarks" = true;        # <-- ajouté
        "services.sync.engine.history" = true;          # <-- ajouté
        "services.sync.engine.passwords" = true;        # <-- ajouté
        "services.sync.engine.prefs" = false;           # <-- ajouté (évite que la synchro écrase tes prefs NixOS)
        "services.sync.engine.tabs" = true;             # <-- ajouté
        "services.sync.engine.creditcards" = false;     # <-- ajouté

        # General settings
        "app.shield.optoutstudies.enabled" = false;
        "app.update.auto" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.contentblocking.category" = "strict";
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "browser.discovery.enabled" = false;
        "browser.laterrun.enabled" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.pinned" = false;
        "browser.protections_panel.infoMessage.seen" = true;
        "browser.quitShortcut.disabled" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.ssb.enabled" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.suggest.openpage" = false;
        "datareporting.policy.dataSubmissionEnable" = false;
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.pocket.enabled" = false;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
      };
    };
  };
}

