{...}: {
  # Desktop Environment Power Management
  powerManagement.cpuFreqGovernor = "performance";

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = false;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      useOSProber = false;
      efiSupport = true;
    };
  };
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

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
