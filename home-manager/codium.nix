{ config, pkgs, inputs, ... }:
let
  vscodeExts = inputs.nix-vscode-extensions.extensions.${pkgs.system};
in
{
  programs.vscodium = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        enkia.tokyo-night
        bbenoist.nix
        ms-python.python
        rust-lang.rust-analyzer
        vscodeExts.open-vsx.auricvex.flake-env
      ];
      userSettings = {
        "workbench.colorTheme" = "Tokyo Night";
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "python.defaultInterpreterPath" = "python";
        "python.locator" = "native";
      };
    };
  };
}