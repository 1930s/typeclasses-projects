rec {

    pkgs =
        import (import ./nixpkgs.nix) {};

    ghc =
        pkgs.haskell.packages.ghc844.override {
            overrides =
                self:
                super:
                {
                    # Any version overrides can go here.
                    # They'll look like this:
                    #
                    #     foo = self.callPackage ./foo.nix {};
                    #
                    # where foo.nix is generated by cabal2nix.
                };
        };

    haskell =
        ghc.ghcWithPackages (p: [
            p.cairo
            p.gtk3
            p.linear
            p.pango
            p.stm
            p.time
            p.unix
        ]);

    ghcid =
        pkgs.haskell.lib.justStaticExecutables
            pkgs.haskellPackages.ghcid;

    fonts =
        pkgs.makeFontsConf {
            fontDirectories = [ pkgs.fira-mono ];
        };

    clock =
        pkgs.writeShellScriptBin "clock"
        ''
            export FONTCONFIG_FILE="${fonts}"
            ${haskell}/bin/runhaskell Main.hs
        '';

}
