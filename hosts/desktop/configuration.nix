{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    solaar
  ];

  # Desktop Environment Power Management
  powerManagement.cpuFreqGovernor = "performance";

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = ["nodev"];
  boot.loader.grub.useOSProber = false;

  # Driver Options
  drivers = {
    amdgpu.enable = false;
    nvidiagpu.enable = true;
  };

  core = {
    steam.enable = true;
    star-citizen.enable = false;
  };
}
