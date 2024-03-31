{
  inputs = {
    nixie.url = "git+ssh://git@github.com/majbacka-labs/nixie\?ref=jesse/bugs";
    nixobolus.url = "github:ponkila/nixobolus";
    nixpkgs-patched.url = "github:majbacka-labs/nixpkgs/patch-init1sh"; # stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs @ {
    self,
    sops-nix,
    nixie,
    nixobolus,
    nixpkgs,
    nixpkgs-patched,
    ...
  }: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      pxe-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixosConfigurations/pxe-server
          nixie.nixosModules.nixie
          nixobolus.nixosModules.homestakeros
          sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
