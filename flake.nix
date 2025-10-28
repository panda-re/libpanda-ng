{
  description = "PANDA: Platform for Architecture-Neutral Dynamic Analysis";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    panda-qemu = {
      url = "github:rehostingdev/qemu?ref=nix-flake-init";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs, panda-qemu, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          panda-qemu-pkg = panda-qemu.packages.${system}.default;
          python = pkgs.python3.withPackages (ps: with ps; [
            cffi
            tree-sitter
            tree-sitter-grammars.tree-sitter-c
          ]);
          libpanda-ng = pkgs.stdenv.mkDerivation (finalAttrs: {
            name = "panda-ng";
            src = ./.;
            nativeBuildInputs = [
              python
            ] ++ (with pkgs; [
              gdb
              breakpointHook # TODO remove
            ]);
            PYTHONPATH="${python}/${python.sitePackages}";
            buildCommand = ''
              cp -r $src src
              cp -r ${panda-qemu-pkg} panda-qemu
              cd src
              bash ./run_all.sh ../panda-qemu
              mkdir -pv $out
              # cp ...
            '';
          });
        in
        {
          default = libpanda-ng;
        }
      );
    };
}
