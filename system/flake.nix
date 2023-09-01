{
  description = "Gramdalf's NixOS system configuration flake";
  
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  
  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      conig = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations.aerwiar = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./configuration.nix ./hardware-configuration.nix ];
    };
  };
}
