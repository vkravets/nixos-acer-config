# /etc/nixos/flake.nix
{
  description = "My flake configuration for acer-v3";

  nixConfig = {
    extra-substituters = [
      "https://vicinae.cachix.org"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
      # url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    #nixpkgs-unstable = {
    #  url = "github:NixOS/nixpkgs/nixos-unstable";
    #};

    #ghostty = {
    #  url = "github:ghostty-org/ghostty";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #wezterm-flake = {
    #  url = "github:wez/wezterm/main?dir=nix";
    #  inputs.nixpkgs.follows = "nixpkgs-unstable";
    #};

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae";

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      #nixpkgs-unstable,
      #ghostty,
      nixos-hardware,
      grub2-themes,
      nix-index-database,
      vicinae,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-gpu-nvidia-disable
            nixos-hardware.nixosModules.common-gpu-intel
            nixos-hardware.nixosModules.common-pc-laptop
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            grub2-themes.nixosModules.default
            ./configuration.nix
            nix-index-database.nixosModules.nix-index
          ];
        };
      };
    };
}
