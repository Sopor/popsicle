{
  description = "System76 Keyboard Configurator";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    naersk.url = "github:nix-community/naersk";
  };

  outputs = { self, nixpkgs, flake-utils, naersk }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = naersk.lib."${system}";
        cargo = pkgs.cargo;
      in {
        defaultPackage = naersk-lib.buildPackage {
          name = "popsicle";
          version = "1.3.1";
          src = ./.;
          buildInputs =
            (with pkgs; [ pkg-config rustc cargo help2man clang gtk3 ]);
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ pkg-config rustc cargo help2man clang gtk3 ];
        };
        formatter = nixpkgs.legacyPackages."${system}".nixfmt;
      });
}


