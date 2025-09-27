{...}: {
  monitors.hyprland = {
    enable = true;
    config = ''
      monitor = DP-2, 3840x2160@144, 0x0, 1.0
    '';
    workspaces = [
      "1,  monitor:DP-2"
      "2,  monitor:DP-2"
      "3,  monitor:DP-2"
      "4,  monitor:DP-2"
    ];
  };

  # Audio configuration for desktop
  audio.pipewire = {
    enable = true;

    cards = {
      # NVIDIA AD104 HDMI/DP audio
      "alsa_card.pci-0000_01_00.1" = {profile = "off";};

      # Radeon HDA (Rembrandt/Strix)
      "alsa_card.pci-0000_0d_00.1" = {profile = "off";};

      # Trust Webcam (mikrofon)
      "alsa_card.usb-Trust_Webcam_Trust_Webcam_20200907-02" = {profile = "off";};

      # USB zvukovka (Generic USB Audio)
      "alsa_card.usb-Generic_USB_Audio-00" = {profile = "HiFi";};
      # Pokud chceš nízkou latenci a víc kanálů: { profile = "pro-audio"; } (ale změní se názvy sink/source)
    };

    # Výchozí zařízení – přesně podle tvých názvů z pactl
    defaultSink = "alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink";
    defaultSource = "alsa_input.usb-Generic_USB_Audio-00.HiFi__Mic1__source";
  };

  modules = {
    # Browser
    zen-browser.enable = true;

    # Code editors
    vscode.enable = true;

    # File managers
    nautilus.enable = true;

    # Misc
    spicetify.enable = true;
    legcord.enable = true;
    obs-studio.enable = true;
    cura.enable = true;
  };
}
