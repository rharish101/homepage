# SPDX-FileCopyrightText: 2026 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT
{
  description = "Personal homepage of Harish Rajagopal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system: function (import nixpkgs { inherit system; }));
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.stdenvNoCC.mkDerivation {
          pname = "rharish-homepage";
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = [ pkgs.hugo ];

          buildPhase = ''
            rm -rf public
            hugo
          '';

          installPhase = ''
            mkdir -p $out
            cp -r public/. $out/
          '';

          meta = with pkgs.lib; {
            description = "Personal homepage of Harish Rajagopal";
            homepage = "https://rharish.dev/";
            repository = "https://github.com/rharish101/homepage";
            license = licenses.mit;
            platforms = platforms.all;
          };
        };
      });
    };
}
