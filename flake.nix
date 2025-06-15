# /etc/nixos/flake.nix
{
  description = "My flake configuration for acer-v3";

  inputs = {
    nixpkgs = {
      #url = "github:NixOS/nixpkgs/nixos-25.05";
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    #nixpkgs-unstable = {
    #  url = "github:NixOS/nixpkgs/nixos-unstable";
    #};

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    #wezterm-flake = {
    #  url = "github:wez/wezterm/main?dir=nix";
    #  inputs.nixpkgs.follows = "nixpkgs-unstable";
    #};

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };

    home-manager = {
      #url = "github:nix-community/home-manager/release-25.05";
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      #nixpkgs-unstable,
      ghostty,
      nixos-hardware,
      grub2-themes,
      nix-index-database,
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
            nixos-hardware.nixosModules.common-gpu-nvidia
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
