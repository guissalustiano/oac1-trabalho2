{ pkgs ? (import <nixpkgs> {}), ... }:
pkgs.mkShell {
  packages = with pkgs; [
    gnumake

    gcc

    (python3.withPackages (ps: [
      ps.jedi-language-server
      ps.cython
    ]))
    pypy3
  ];
}
