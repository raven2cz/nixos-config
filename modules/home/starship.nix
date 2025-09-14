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
      # Import Catppuccin Mocha palette from the input (repo stores it under themes/)
      catpp_mocha =
        builtins.fromTOML
        (builtins.readFile "${inputs."catppuccin-starship"}/themes/mocha.toml");
    in (
      {
        # UI tweaks
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

        # Force our palette name to override any other module (conflict with "base16")
        palette = lib.mkForce "catppuccin_mocha";
      }
      # Merge in the actual palette tables ([palettes.catppuccin_mocha = { ... }])
      // catpp_mocha
    );
  };
}
