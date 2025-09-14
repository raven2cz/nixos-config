{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    (catppuccin-gtk.override {
      variant = "mocha";
      accents = ["mauve"];
      size = "standard";
      tweaks = ["rimless"];
    })
  ];

  gtk = {
    enable = true;

    # Only select the theme by name; DO NOT set gtk.theme.package here
    theme = lib.mkForce {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
    };

    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };
}
