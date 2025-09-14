{
  pkgs,
  lib,
  ...
}: let
  # Build the Catppuccin GTK theme we want
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    variant = "mocha";
    accents = ["mauve"];
    size = "standard";
    tweaks = ["rimless"];
  };

  themeName = "Catppuccin-Mocha-Standard-Mauve-Dark";
in {
  # Optional: have the theme in the user profile too (handy for other pickers)
  home.packages = [catppuccinGtk];

  gtk = {
    enable = true;

    # Select by name only; DO NOT set gtk.theme.package here
    theme = lib.mkForce {
      name = themeName;
      # package = <unset on purpose>;
    };

    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  # Manually provide the source for ~/.themes/<name> so HM doesn't produce null
  home.file.".themes/${themeName}".source =
    lib.mkForce "${catppuccinGtk}/share/themes/${themeName}";
}
