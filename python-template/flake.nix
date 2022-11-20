

{
  description = "Python application flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    mach-nix.url = "github:davhau/mach-nix/3.5.0";
  };

  outputs = {self, nixpkgs, flake-utils, mach-nix, ...  }@inputs:
    flake-utils.lib.eachSystem [ "x86_64-linux" ]  (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        mach = mach-nix.lib.${system};

        pythonVersion = "python39";

        requirements = builtins.readFile ./requirements.txt;

        pythonApp = mach.buildPythonApplication {
          src = ./.;
          python = pythonVersion;
          inherit requirements;
          };

        pythonEnv = mach.mkPython {
          python = pythonVersion;
          inherit requirements;
        };

        runCheckCommand = name: command:
          pkgs.runCommand "${name}-python_app" { } ''
          cd ${self}    
          ${command}
          mkdir $out
          '';
      in rec
      {

        packages.app = pythonApp;
        defaultPackage = self.packages.${system}.app;

        checks =  {
          black-check = runCheckCommand "black" ''
              ${pythonEnv.pkgs.black}/bin/black --check .
            '';
        };

        apps.pythonApp = flake-utils.lib.mkApp { drv = packages.app; };
        defaultApp = apps.pythonApp;

        devShell = pkgs.mkShellNoCC {
            nativeBuildInputs = [ pythonEnv ];
            buildInputs = with pkgs; [
            black
            ];

            shellHook = ''
              export PYTHONPATH="${pythonEnv}/bin/python"
            '';
          };

      });
}
