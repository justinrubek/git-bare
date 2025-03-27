{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      perSystem = {pkgs, ...}: {
        packages = {
          clone = pkgs.writeShellApplication {
            name = "git-bare-clone";
            runtimeInputs = [];
            text = builtins.readFile ./clone.sh;
          };

          init = pkgs.writeShellApplication {
            name = "git-bare-init";
            runtimeInputs = [];
            text = builtins.readFile ./init.sh;
          };
        };
      };
    };
}
