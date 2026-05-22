{

  description = "Thattemperature's NixOS template";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    thattem-nixpkgs-overlays = {
      url = "github:thattemperature/thattem-nixpkgs-overlays";
    };

    thattem-nixos = {
      url = "github:thattemperature/thattem-nixos-configurations";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        thattem-nixpkgs-overlays.follows = "thattem-nixpkgs-overlays";
      };
    };

    thattem-home-manager = {
      url = "github:thattemperature/thattem-home-manager-configurations";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        thattem-nixpkgs-overlays.follows = "thattem-nixpkgs-overlays";
      };
    };

  };

  outputs =
    {
      nixpkgs,
      thattem-nixos,
      thattem-home-manager,
      ...
    }:

    let

      dummyHardware = {
        boot.loader.grub.device = "nodev";
        fileSystems."/" = {
          device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
          fsType = "btrfs";
        };
      };

    in

    {
      nixosConfigurations = {

        default = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            dummyHardware
            {
              thattem.nixos.advanced.enable = true;
              thattem.nixos.programming.enable = true;
              thattem.nixos.type = "common";
            }
            thattem-nixos.nixosModules.default
            thattem-home-manager.nixosModules.default
          ];
        };

      };
    };

}
