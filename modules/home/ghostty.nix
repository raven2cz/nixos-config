{
  inputs,
  pkgs,
  host,
  ...
}: let
  ghostty = inputs.ghostty.packages.${pkgs.system}.default;
in {
  home.packages = [ghostty];

  xdg.configFile."ghostty/config".text = ''
    # Font
    font-family = "Maple Mono"
    font-size = ${
      if (host == "laptop")
      then "12"
      else "14"
    }
    font-feature = calt
    font-feature = ss03

    bold-is-bright = false
    selection-invert-fg-bg = true

    # Theme
    theme = "catppuccin-mocha"
    background-opacity = 0.66

    cursor-style = bar
    cursor-style-blink = false
    adjust-cursor-thickness = 1

    resize-overlay = never
    copy-on-select = false
    confirm-close-surface = false
    mouse-hide-while-typing = true

    window-theme = ghostty
    # window-padding-x = 4
    # window-padding-y = 6
    window-padding-balance = true
    window-padding-color = background
    window-inherit-working-directory = true
    window-inherit-font-size = true
    window-decoration = false

    gtk-titlebar = false
    gtk-single-instance = false
    gtk-tabs-location = bottom
    gtk-wide-tabs = false

    auto-update = off
    term = ghostty
    clipboard-paste-protection = false

    keybind = shift+end=unbind
    keybind = shift+home=unbind
    keybind = ctrl+shift+left=unbind
    keybind = ctrl+shift+right=unbind
    keybind = shift+enter=text:\n
  '';
}
