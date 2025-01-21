{pkgs, config, ...}:
let
  unstableCallPackage = pkgs.lib.callPackageWith (pkgs.unstable);
  openhmd-thaytan = (unstableCallPackage ../../packages/openhmd-thaytan {});
  monado_latest = (unstableCallPackage ../../packages/monado_latest {}).override { openhmd = openhmd-thaytan;};
in {
  environment.systemPackages = with pkgs; [
    monado_latest
    unstable.opencomposite
    openhmd-thaytan
  ];

  services.udev.packages = with pkgs; [
    xr-hardware
  ];
}
