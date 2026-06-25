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
      '';

      # Custom scripts to avoid retyping transmission sequence
      # Ref: https://doc-en.rvspace.org/VisionFive2/Datasheet/VisionFive2_SDK_QSG/recovering_bootloader%20-%20vf2.html
      packages = [
        (pkgs.writeShellScriptBin "boot-usart-standard" ''
          export BUNDLE="${config.packages.bundle-standard}"
          export SPL_NAME="${config.packages.bundle-standard.splName}"
          export PAYLOAD_NAME="${config.packages.bundle-standard.payloadName}"

          exec ${./scripts/boot-usart.sh} "$@"
        '')
      ];
    };
  };
}
