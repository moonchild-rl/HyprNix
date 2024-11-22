# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Bigger console font
  boot.loader.systemd-boot.consoleMode = "2";

  boot.initrd.luks.devices."luks-f8308aa8-d0ec-4b68-af18-99d6d51b8f74".device = "/dev/disk/by-uuid/f8308aa8-d0ec-4b68-af18-99d6d51b8f74";
  # luksOpen will be attempted before LVM scan according to angristan
  boot.initrd.luks.devices."luks-f8308aa8-d0ec-4b68-af18-99d6d51b8f74".preLVM = true;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.networkmanager.enable = true; #from angristan but already defined

  # Display ownership notice before LUKS prompt
  boot.initrd.preLVMCommands = ''
	echo '---OWNERSHIP NOTICE---'
	echo 'This device is property of NAME'
	echo 'If lost please contact EMAIL'
	echo '---OWNERSHIP NOTICE---'
  '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.moon = {
    isNormalUser = true;
    description = "Moonchild";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
wget
neofetch
vim
neovim
firefox
git
stow
kitty
dolphin
where-is-my-sddm-theme # theme for display manager according to rjpc from nixos discourse for auto login to hyprland
waybar
hyprpaper
mpv
upower
ncdu #disk usage analyzer
gparted
file
htop
speedtest-cli
tree
nload #for network traffic monitoring
ethtool #monitoring network & hardware
python3
ipcalc #simple IP network calculator
netcat
unzip
libreoffice
onlyoffice-bin
fastfetch
freshfetch
# The following (until the end of systemPackages) is added according to josiahalenbrown
hyprland
swww # for wallpapers
xdg-desktop-portal-gtk
xdg-desktop-portal-hyprland
xwayland
# sound support
pavucontrol
pipewire
# common utilities
busybox
scdoc
gcc
# notification daemon
dunst
libnotify
# networking
networkmanagerapplet # GUI for networkmanager
#vscode # disabled cuz unfree license
# app launchers
# rofi-wayland
wofi   
  ];

  programs.hyprland = {
	# Install the packages from nixpkgs
	enable = true;
	# Whether to enable XWayland
	xwayland.enable = true;
  };
  # Hint Electon apps to use wayland
  environment.sessionVariables = {
	NIXOS_OZONE_WL = "1";
  };

  #environment.variables.EDITOR = "nvim"; #maybe try nvim

  # this is a test
  programs.waybar.enable = true;

  #fonts = {
	#enableDefaultFonts = true;
	# From angristan, idk what the following lines do
	#enableFontDir = true;
	#enableGhostscriptFonts = true;
	#fonts.packages = with pkgs; [
		#noto-fonts
		#noto-fonts-cjk
		#noto-fonts-emoji
		#noto-fonts-extra
		#fira-code
		#fira-code-symbols
		#hack-font
		#fira-mono
		#corefonts
		#nerdfonts
	#];
  #};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

 # The following block is intended to enable screensharing according to josiahalenbrown
 services.dbus.enable = true;
 xdg.portal = {
	enable = true;
	wlr.enable = true;
	extraPortals = [
		pkgs.xdg-desktop-portal-gtk
	];
 };	

 sound.enable = true;
 security.rtkit.enable = true;
 services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
 };

 # Auto start Hyprland; through display manager
 services.xserver.enable = true;
 services.xserver.displayManager.sddm.enable = true;
 services.xserver.displayManager.sddm.wayland.enable = true;
 services.xserver.displayManager.sddm.theme = "where_is_my_sddm_theme";

 # Following blocks according to angristan
 # Thermals and cooling
 services.thermald.enable = true;
 # support for suspend-to-RAM and powersave for laptops
 # powerManagment.enable = true; #powerManagment doesn't exist apparently
 # Enable powertop auto tuning on startup
 # powerManagment.powertop.enable = false;

 # Bluetooth
 hardware.bluetooth.enable = false;
 # Don't power up the default Bluetooth controller on boot
 hardware.bluetooth.powerOnBoot = false;

 users.defaultUserShell = pkgs.zsh;

 programs.zsh = {
	enable = true;
	enableCompletion = true;
	autosuggestions.enable = true;
	syntaxHighlighting.enable = true;
	
	shellAliases = {
		la = "ls -a";
		update = "sudo nixos-rebuild switch";
	};
	#history.size = 10000;
	#history.path = "${config.xdg.dataHome}/zsh/history";
 };
 
 programs.tmux = {
	enable = true;
 };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
