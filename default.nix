with (import <nixpkgs> {});

stdenv.mkDerivation {
     name = "MyProject";
     version = "0.0.1";

     buildInputs = [
        stdenv
        git
        # ruby deps
        ruby
        bundler
        # Rails deps
        clang
        libxml2
        libxslt
        readline
        sqlite
        openssl
        mysql
        imagemagick
     ];

     shellHook = ''
        export LIBXML2_DIR=${pkgs.libxml2}
        export LIBXSLT_DIR=${pkgs.libxslt}
        export MYSQL_DIR=${pkgs.mysql}
     '';
   }
