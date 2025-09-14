{
  lib,
  inputs,
  ...
}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = let
      catpp_mocha =
        builtins.fromTOML
        (builtins.readFile "${inputs."catppuccin-starship"}/themes/mocha.toml");
    in
      {
        directory = {
          format = "[ ](bold #89b4fa)[ $path ]($style)";
          style = "bold #b4befe";
        };
        character = {
          success_symbol = "[ ](bold #89b4fa)[ ➜](bold green)";
          error_symbol = "[ ](bold #89b4fa)[ ➜](bold red)";
        };
        cmd_duration = {
          format = "[󰔛 $duration]($style)";
          disabled = false;
          style = "bg:none fg:#f9e2af";
          show_notifications = false;
          min_time_to_notify = 60000;
        };

        palette = "catppuccin_mocha";
      }
      # combine pallete tables Catppuccin (includes [palettes.catppuccin_mocha])
      // catpp_mocha;
  };
}
