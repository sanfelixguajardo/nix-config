# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./system/hardware-configuration.nix
    ];

  # Enable nix-command and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ]; 

  # Set ZSH as default shell for users
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [ 25565 443 12345 5900];

  # nvidia configuration
  hardware.opengl = {
	enable = true;
	driSupport = true;
	driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
	modesetting.enable = true;

	powerManagement.enable = false;
   	powerManagement.finegrained = false;

 	open = false;

	nvidiaSettings = true;

	package = config.boot.kernelPackages.nvidiaPackages.beta;
  };  

  services = {
	pipewire = {
		enable = true;
		audio.enable = true;
		pulse.enable = true;
		alsa = {
			enable = true;
			support32Bit = true;
			};
		jack.enable = true;
		};

  };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "winkeys";
  };

  # Configure console keymap
  console.keyMap = "es";

  # display manager
  services.greetd = {
	enable = true;
	settings = {
		default_session.command = ''
			
			${pkgs.greetd.tuigreet}/bin/tuigreet \
			--time \
			--asterisks \
			--cmd Hyprland
			'';
	};
  };

  programs.starship = {
	enable = true;
  };


  # Hyprland config
  programs.hyprland = {
	enable = true;
	xwayland.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sanfe = {
    isNormalUser = true;
    description = "sanfe";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
   
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  environment.etc.hosts.mode = "0644";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	openssl # it is needed to install nerdfonts
  	vim
	firefox
	git
	alacritty
	pavucontrol
	wofi
	mangohud
	alsa-utils # includes pkgs like alsamixer to reconfigure microphone boost
	swww
	waybar
	spotify
	fastfetch
	vesktop # it is needed for discord screen shearing
	pipes
	cava
	htop
	libudev-zero
	prismlauncher
	yazi # file manager
	imv #image viwer
	zathura
	zoxide
	bat
	fzf
	eza
	zsh
	mpv	
	tmux
	burpsuite
	wayvnc
	zinit # package manager para zsh
	oh-my-posh
	home-manager

	(import /home/sanfe/.local/share/bin/wall-theme-select.nix { inherit pkgs; })
  ];


  fonts.packages = with pkgs; [
	nerdfonts
  ];

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
