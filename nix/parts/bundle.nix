_: {
  perSystem =
    {
      pkgs,
      config,
      mkUBootPayload,
      ...
    }:
    let
      uboot-proper = mkUBootPayload {
        bundleName = "standard";
        sbiBinaryPath = "${config.packages.opensbi}/share/fw_dynamic.bin";
      };
    in
    {
      packages.default = pkgs.runCommand "vf2-bundle-standard" { } ''
        mkdir -p $out/flash-targets
        cp ${uboot-proper}/bootchain/u-boot-spl.bin.normal.out $out/flash-targets/phase1-spl.bin
        cp ${uboot-proper}/bootchain/u-boot.itb $out/flash-targets/phase2-payload.bin
      '';
    };
}
