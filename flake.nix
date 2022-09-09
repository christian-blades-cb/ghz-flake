{
  description = "ghz a gRPC load testing tool";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib; eachSystem defaultSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          packages = flattenTree rec {
            ghz = pkgs.buildGoModule rec {
              pname = "ghz";
              version = "0.109.0";

              src = pkgs.fetchFromGitHub {
                owner = "bojand";
                repo = "ghz";
                rev = "v${version}";

                sha256 = "5l2PeN+VxTaORAkmAfI9TCGd4W6y8BFs/eY4T9nYJuc=";
              };

              vendorSha256 = "sha256-qZD+qxjjFgyQDtjOQcilS4w2sS9I+7iCK2/ThaAJTy4=";

              doCheck = false;
            };

            default = ghz;
          };

          overlays = rec {
            ghz = final: prev: { ghz = self.packages.${system}.ghz; };
            default = ghz;
          };
        }
    );
}
