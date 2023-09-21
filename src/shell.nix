{ pkgs ? (import <nixpkgs> {}), ... }:
pkgs.mkShell {
  packages = with pkgs; [
    gcc

    (python3.withPackages (ps: [
      ps.jedi-language-server
    ]))
    pypy3

    jdk17
    jdt-language-server

    linuxKernel.packages.linux_6_1.perf
  ];
}
