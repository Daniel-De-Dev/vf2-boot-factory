_: {
  perSystem =
    {
      pkgs,
      config,
      mkUBootPayload,
      ...
    }:
    {
      packages =
        let

          /**
            Helper function to grab the right files for flashing

            @param bundleName Name suffix for the bundle derivation
            @param splPath Path to the Phase 1 SPL binary
            @param payloadPath Path to the Phase 2 payload binary
            @param splName Name for the SPL program in bundle
            @param payloadName Short name for what the payload contains
          */
          mkBootBundle =
            {
              bundleName,
              splPath,
              payloadPath,
              splName,
              payloadName,
            }:
            pkgs.runCommand "vf2-bundle-${bundleName}"
              { passthru = { inherit splName payloadName; }; }
              ''
                mkdir -p $out/flash-targets
                cp ${splPath} $out/flash-targets/phase1-spl.bin
                cp ${payloadPath} $out/flash-targets/phase2-payload.bin
              '';

          ubootspl-opensbi-uboot = mkUBootPayload {
            bundleName = "opensbi";
            sbiBinaryPath = "${config.packages.opensbi}/share/fw_dynamic.bin";
          };
        in
        {
          # Various combinations of implementations for the different phases
          # of boot for VF2

          # FV2 Standard (What VF2 has pre-flashed from factory)
          bundle-standard = mkBootBundle {
            bundleName = "standard";
            splPath = "${ubootspl-opensbi-uboot}/bootchain/u-boot-spl.bin.normal.out";
            payloadPath = "${ubootspl-opensbi-uboot}/bootchain/u-boot.itb";
            splName = "U-Boot SPL";
            payloadName = "OpenSBI + U-Boot Proper";
          };
        };
    };
}
