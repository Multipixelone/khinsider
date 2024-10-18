{
  description = "Script to download soundtracks from khinsider";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      app = pkgs.python3Packages.buildPythonApplication rec {
        pname = "khinsider";
        version = "1.0";
        format = "other";
        src = ./.;

        propagatedBuildInputs = with pkgs.python3Packages; [
          requests
          beautifulsoup4
        ];

        dontUnpack = true;
        doCheck = false;
        pytestCheckHook = false;

        installPhase = ''
          install -Dm755 ${src}/khinsider.py $out/bin/${pname}
        '';
        meta.mainProgram = "khinsider";
      };
    in {
      packages = {
        khinsider = app;
        default = self.packages.${system}.khinsider;
      };
    });
}
