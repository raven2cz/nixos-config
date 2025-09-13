{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.vscode;
  marketplace = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
  marketplace-release = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace-release;
in {
  options.modules.vscode = {enable = mkEnableOption "vscode";};

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;

      mutableExtensionsDir = true;

      profiles.default = {
        extensions =
          (with pkgs.vscode-extensions; [
            # Nix tooling
            bbenoist.nix
            kamadorueda.alejandra
          ])
          ++ (with marketplace; [
            # Useful extensions
            vivaxy.vscode-conventional-commits
            eamodio.gitlens
            dbaeumer.vscode-eslint
            esbenp.prettier-vscode

            # THEME & ICONS: Catppuccin
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
          ])
          ++ (with marketplace-release; [
            # github.copilot-chat
          ]);

        userSettings = {
          "update.mode" = "none";

          "editor.fontLigatures" = true;
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnType" = false;

          "editor.codeActionsOnSave" = {
            "source.fixAll.eslint" = "explicit";
          };

          "editor.minimap.enabled" = true;
          "editor.mouseWheelZoom" = true;
          "editor.renderControlCharacters" = false;
          "editor.scrollbar.horizontalScrollbarSize" = 5;
          "editor.scrollbar.verticalScrollbarSize" = 5;

          "explorer.confirmDragAndDrop" = false;
          "explorer.openEditors.visible" = 0;

          "extensions.autoUpdate" = false; # This stuff fixes vscode freaking out when theres an update

          "files.autoSave" = "onWindowChange";
          "terminal.integrated.fontFamily" = "'Maple Mono', 'SymbolsNerdFont'";
          "vsicons.dontShowNewVersionMessage" = true;

          "window.customTitleBarVisibility" = "auto";
          "window.menuBarVisibility" = "toggle";

          "workbench.activityBar.location" = "top";
          "workbench.colorTheme" = mkForce "Catppuccin Mocha";
          "workbench.iconTheme" = "Catppuccin Icons";

          "workbench.editor.limit.enabled" = true;
          "workbench.editor.limit.perEditorGroup" = true;
          "workbench.editor.limit.value" = 10;
          "workbench.layoutControl.enabled" = false;
          "workbench.layoutControl.type" = "menu";
          "workbench.startupEditor" = "none";
          "workbench.statusBar.visible" = true;
          "workbench.panel.showLabels" = false;

          # Recommended for Catppuccin
          "editor.semanticHighlighting.enabled" = true;
          "terminal.integrated.minimumContrastRatio" = 1;
          "window.titleBarStyle" = "custom";

          # formatting
          "alejandra.program" = "alejandra";
          "gitlens.rebaseEditor.ordering" = "asc";
          "github.copilot.nextEditSuggestions.enabled" = true;

          # Lang specific
          "[nix]" = {
            "editor.defaultFormatter" = "kamadorueda.alejandra";
            "editor.formatOnPaste" = true;
            "editor.formatOnSave" = true;
            "editor.formatOnType" = false;
          };
          "[json]" = {"editor.defaultFormatter" = "vscode.json-language-features";};
          "[typescript]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
          "[javascript]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
          "[typescriptreact]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
          "[css]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
        };

        # Keybindings
        keybindings = [
          {
            "command" = "workbench.action.files.saveFiles";
            "key" = "ctrl+s";
          }
          {
            "command" = "workbench.action.terminal.killAll";
            "key" = "ctrl+alt+meta+delete";
          }
        ];
      };
    };
  };
}
