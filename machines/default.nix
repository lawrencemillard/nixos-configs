{
  withSystem,
  inputs,
  ...
}: let
  inherit (inputs) self nixpkgs;
  inherit (inputs.self) lib; # I need mkService
  inherit (lib) mkNixosIso;
  # inherit (lib) mkNixosIso mkNixosSystem mkModuleTree';
  # inherit (lib.lists) concatLists flatten singleton;

  # Inputs
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4 and other quirky devices
  agenix = inputs.agenix.nixosModules.default; # secret encryption via age
  hm = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

  # Home-manager
  homesPath = ./home.nix;
  homes = [hm homesPath];

  # Default
  system = "x86_64-linux";
  modulesPath = "${nixpkgs}/nixos/modules";

  # Define role-specific module lists
  workstationRoles = [
    ../modules/roles/workstation
    ../modules/roles/graphical
  ];

  laptopRoles = [
    ../modules/roles/laptop
    ../modules/roles/workstation
    ../modules/roles/graphical
  ];

  serverRoles = [
    ../modules/roles/server
    ../modules/roles/headless
  ];

  isoRoles = [
    ../modules/roles/iso
    ../modules/roles/headless
  ];

  # Define a base configuration function
  baseSystemConfig = {
    hostname,
    roleModules,
    system ? "x86_64-linux",
    agenix,
    enableHome ? true,
  }:
    withSystem system ({
      inputs',
      self',
      ...
    }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          [
            {networking.hostName = hostname;}
            ./${hostname}
            ../modules/shared # modules shared across all hosts, enabled by default
            ../modules/exclusive/nixos # modules shared across all hosts, but need to be enabled
          ]
          ++ roleModules
          ++ [
            ../options
            agenix
          ]
          ++ (
            if enableHome
            then homes
            else []
          );
        specialArgs = {
          inherit (self) keys;
          inherit lib modulesPath;
          inherit inputs self inputs' self';
        };
      });
in {
  # LAPTOP
  # ASUS TUF FX505D laptop from 2019
  # equipped with Ryzen 7 7730U
  milkyway = baseSystemConfig {
    hostname = "milkyway";
    roleModules = laptopRoles;
    enableHome = true;
    inherit system agenix;
  };

  # DESKTOP
  andromeda = baseSystemConfig {
    hostname = "andromeda";
    roleModules = workstationRoles;
    enableHome = true;
    inherit system agenix;
  };

  # SERVER
  triangulum = baseSystemConfig {
    hostname = "triangulum";
    roleModules = serverRoles;
    enableHome = true;
    inherit system agenix;
  };

  # ISO - Portable Workstation
  messier = mkNixosIso {
    hostname = "messier";
    system = "x86_64-linux";
    specialArgs = {
      inherit lib;
    };
    modules =
      [
        ./messier
        ../modules/roles/iso
        # ./messier/home.nix
        # hm
        # (TODO: modules/shared also enables - apparmor, selinux, clamav, auditd, virtualization
        # so check the performance impact and disable accordingly)
        # ../modules/shared # modules shared across all hosts, enabled by default
        # ../modules/exclusive/nixos # modules shared across all hosts, but need to be enabled
        # inputs.home-manager.nixosModules.home-manager
        # {
        #   home-manager.useGlobalPkgs = true;
        #   home-manager.useUserPackages = true;
        # }
      ]
      # ++ isoRoles
      ++ [
        # ../options
        # agenix
      ]
      ++ [
        hm
        ./messier/home.nix
      ]; # (TODO: maybe also add shared home modules to iso)
  };

  iso = lib.nixosSystem {
    modules =
      [
        # provides options for modifying the ISO image
        "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"

        # bootstrap channels with the ISO image to avoid fetching them during installation
        "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"

        # make sure our installer can detect and interact with all hardware that is supported in Nixpkgs
        # this loads basically every hardware related kernel module
        "${nixpkgs}/nixos/modules/profiles/all-hardware.nix"
        ./iso
        ../options
      ]
      ++ homes;
    specialArgs = {
      inherit (self) keys;
      inherit lib modulesPath;
      inherit inputs self;
    };
  };
}
