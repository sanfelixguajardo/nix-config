{
	description = "One flake to rule them all";
	
	inputs = {

		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
		home-manager.url = "github:nix-community/home-manager/release-24.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, home-manager, ... } @ inputs: 

		let
			lib = nixpkgs.lib;
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};

			supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];
			forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
			nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });
		in {
		
		nixosConfigurations = { 
			nixos = lib.nixosSystem {
				inherit system;
				modules = [ ./configuration.nix ];
			};
		};	
		homeConfigurations = {
			sanfe = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [ ./home.nix ];
			};
		};

		packages = forAllSystems (system:
			let pkgs = nixpkgsFor.${system};
			in {
				default = self.packages.${system}.install;
				
				install = pkgs.writeShellApplication {
					name = "install";
					runtimeInputs = with pkgs; [ git ];
					text = ''${./install.sh} "$@"'';
				};
		});
		
		apps = forAllSystems (system: {
			default = self.apps.${system}.install;

			install = {
				type = "app";
				program = "${self.packages.${system}.install}/bin/install";
			};
		});
	};
}
