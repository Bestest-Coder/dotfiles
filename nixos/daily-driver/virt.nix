{pkgs, config, lib, ...}:
{
  options.daily-driver.virt = lib.mkEnableOption "Enable Virtualization";
  # everything needed for running VMs
  config = lib.mkIf config.daily-driver.virt {
      # setup for virtualization (specifically libvirtd and virtmanager)

      virtualisation.libvirtd.enable = true;
      programs.dconf.enable = true;
      programs.virt-manager.enable = true;
      home-manager.users.bestest = {
        dconf.settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
          };
        };
      };
  };
}
