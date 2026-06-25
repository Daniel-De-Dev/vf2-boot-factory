{
  description = "VisionFive 2 boot factory";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    standards = {
      url = "github:Daniel-De-Dev/flake-standards";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    src-opensbi = {
      url = "github:riscv-software-src/opensbi";
      flake = false;
    };

    src-uboot = {
      url = "github:u-boot/u-boot";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        inputs.standards.flakeModules.default
        ./nix/parts/devshells.nix
        ./nix/parts/opensbi.nix
        ./nix/parts/uboot.nix
        ./nix/parts/combinations.nix
      ];

      perSystem = _: { };
    };
}
