{ config, pkgs, inputs, ... }:
{
  # Home manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    extraSpecialArgs = { inherit inputs; };
    users = {
      "bwopp" = {
        home.username = "bwopp";
        home.homeDirectory = "/home/bwopp";
        home.stateVersion = "25.11";

        programs.home-manager.enable = true;

        # Music
        services.mpris-proxy.enable = true;

        imports = [
          # inputs.niri.homeModules.niri
          # inputs.noctalia.homeModules.default
          # ./alacritty.nix
          # ./noctalia-shell.nix
          # ./niri.nix
          ./vscode.nix
          ./floorp.nix
        ];
      };
    };
  };
}
