{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        {
          pkgs,
          config,
          lib,
          ...
        }:
        let
          inherit (pkgs.darwin.apple_sdk.frameworks) SystemConfiguration;
          toolchain = pkgs.rustPlatform;
        in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              (with toolchain;
              [
                rustc 
                cargo
              ])
              clippy
              rustfmt
              rust-analyzer-unwrapped
              darwin.libobjc
              libiconv
            ] ++ lib.optionals stdenv.isDarwin [
              SystemConfiguration
            ];
            RUST_SRC_PATH = "${toolchain.rustLibSrc}";
          };
        };
    };
}