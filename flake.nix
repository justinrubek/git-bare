{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      perSystem = {
        config,
        pkgs,
        system,
        inputs',
        self',
        ...
      }: {
        packages = rec {
          default = git-bareclone;

          git-bareclone = pkgs.writeShellApplication {
            name = "git-bareclone";
            runtimeInputs = [];
            text = builtins.readFile ./git-bareclone.sh;
          };
        };
      };
    };
}
