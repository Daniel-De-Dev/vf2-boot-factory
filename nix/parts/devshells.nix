_: {
  perSystem = { config, pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "vf2-boot-factory-env";
      nativeBuildInputs = with pkgs; [
        tio
        lrzsz
      ];
      shellHook = ''
        echo "VisionFive 2 Boot Factory Environment"
        echo "Run 'boot-usart' to start flash."
      '';
      packages = [
        (pkgs.writeShellScriptBin "boot-usart" ''
          export BUNDLE="${config.packages.default}"
          exec ${./scripts/boot-usart.sh} "$@"
        '')
      ];
    };
  };
}
