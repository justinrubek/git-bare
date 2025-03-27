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
        packages = {
          clone = pkgs.writeShellApplication {
            name = "git-bare-clone";
            runtimeInputs = [];
            text = builtins.readFile ./git-bareclone.sh;
          };

          init = pkgs.writeShellApplication {
            name = "git-bare-init";
            runtimeInputs = [];
            text = builtins.readFile ./git-bareinit.sh;
          };
        };
      };
    };
}
