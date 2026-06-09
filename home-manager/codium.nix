{ config, pkgs, inputs, ... }:
{
  programs.vscodium = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        enkia.tokyo-night
        bbenoist.nix
        ms-python.python
        rust-lang.rust-analyzer
        arrterian.nix-env-selector
      ];
      userSettings = {
        "workbench.colorTheme" = "Tokyo Night";
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
      };
    };
  };
}