{ inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {

    /**
      Build U-Boot bootchain for VisionFive 2.

      @param sbiBinaryPath Path to compiled M-Mode SBI
      @param bundleName Suffix for derivation naming

      Note:
      U-Boot SPL is automatically prefixed with the required BootROM header
      during compilation because it's specifically targeting the VF2.

      Ref: https://doc-en.rvspace.org/VisionFive2/SWTRM/VisionFive2_SW_TRM/compiling_the_u-boot%20-%20vf2.html
    */
    _module.args.mkUBootPayload =
      { sbiBinaryPath, bundleName }:
      let
        crossPkgs = pkgs.pkgsCross.riscv64;
      in
      crossPkgs.stdenv.mkDerivation {
        pname = "uboot-with-${bundleName}";
        version = inputs.src-uboot.shortRev or "dirty";
        src = inputs.src-uboot;

        postPatch = ''
          patchShebangs tools
          patchShebangs scripts
        '';

        nativeBuildInputs = with pkgs; [
          bison
          flex
          (python3.withPackages (ps: [ ps.libfdt ]))
          stdenv.cc
          perl
        ];

        buildInputs = with pkgs; [
          openssl
          gnutls
        ];

        enableParallelBuilding = true;

        # Inject phase 1 payload into phase 2 build
        env.OPENSBI = sbiBinaryPath;

        makeFlags = [
          "ARCH=riscv"
          "CROSS_COMPILE=${crossPkgs.stdenv.cc.targetPrefix}"
          "DTC=${lib.getExe pkgs.dtc}"
          "HOSTCFLAGS=-fcommon"
        ];

        configurePhase = ''
          runHook preConfigure

          make -j$NIX_BUILD_CORES starfive_visionfive2_defconfig

          runHook postConfigure
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bootchain
          cp spl/u-boot-spl.bin.normal.out $out/bootchain/
          cp u-boot.itb $out/bootchain/

          runHook postInstall
        '';
      };
  };
}
