{
  description = "wikitext_wtp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = "${system}"; config.allowUnfree = true; };
      OPENGL_DRIVER="/run/opengl-driver/lib";
    in
    {
      devShells.${system}.default =
        pkgs.mkShell
          {
            LD_LIBRARY_PATH =
              "${OPENGL_DRIVER}:" +
                pkgs.lib.makeLibraryPath [
                  # for jupyter
                  pkgs.stdenv.cc.cc
                ];
            CUDA_PATH = "${pkgs.cudatoolkit}";

            buildInputs = with pkgs; [
              python312
              poetry

              cudatoolkit
            ];
            shellHook = ''
              export PS1="(wikitext_wtp)$PS1"
            '';
          };
    };
}
