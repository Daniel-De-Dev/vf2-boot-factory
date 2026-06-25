{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages =
      let
        crossPkgs = pkgs.pkgsCross.riscv64;

        # VF2 DDR memory base address.
        # Ref: https://doc-en.rvspace.org/JH7110/TRM/JH7110_TRM/system_memory_map.html
        startDDR = "0x40000000";
      in
      {
        /**
          OpenSBI (Dynamic).

          Build fw_dynamic.bin instead of baking U-Boot payload (fw_payload)
          directly.
          This is a more modular approach that allows for swapping boot phase
          implementations without recompiling OpenSBI.

          Ref: https://doc-en.rvspace.org/VisionFive2/SWTRM/VisionFive2_SW_TRM/compiling_opensbi%20-%20vf2.html
        */
        opensbi = crossPkgs.stdenv.mkDerivation {
          pname = "opensbi-dynamic";
          version = inputs.src-opensbi.shortRev or "dirty";
          src = inputs.src-opensbi;

          nativeBuildInputs = with pkgs; [ python3 ];

          postPatch = ''
            patchShebangs scripts
          '';

          makeFlags = [
            "ARCH=riscv"
            "CROSS_COMPILE=${crossPkgs.stdenv.cc.targetPrefix}"
            "PLATFORM=generic"
            "FW_TEXT_START=${startDDR}"
          ];

          installPhase = ''
            mkdir -p $out/share
            cp build/platform/generic/firmware/fw_dynamic.bin $out/share/
          '';
        };
      };
  };
}
