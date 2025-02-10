{pkgs, config, ...}:
let
  unstableCallPackage = pkgs.lib.callPackageWith (pkgs.unstable);
  openhmd-thaytan = (unstableCallPackage ../../packages/openhmd-thaytan {});
  monado_latest = (unstableCallPackage ../../packages/monado_latest {}).override { openhmd = openhmd-thaytan;};
in {
  environment.systemPackages = with pkgs; [
    #monado_latest
    unstable.opencomposite
    openhmd-thaytan
  ];
  services.monado = {
    enable = true;
    package = monado_latest;
    defaultRuntime = true;
    highPriority = true;
  };
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
    WMR_HANDTRACKING = "0";
  };

  services.udev.packages = with pkgs; [
    xr-hardware
  ];
}
