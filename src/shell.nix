{ pkgs ? (import <nixpkgs> {}), ... }:
pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (ps: [
      ps.jedi-language-server
    ]))

    pkgs.curl
    pkgs.jq
  ];
}
