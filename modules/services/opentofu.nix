{
  config,
  lib,
  pkgs,
  ...
}:

# Configurable OpenTofu service, see authentik for usage example
let
  cfg = config.services.opentofu;
  types = lib.types;
in
{
  options.services.opentofu = {
    configurations = lib.mkOption {
      description = "OpenTofu configurations to manage";
      default = { };
      type = types.attrsOf (
        types.submodule {
          options = {
            source = lib.mkOption {
              type = types.path;
              description = "Path to the Terraform/OpenTofu configuration files";
            };
            environmentFiles = lib.mkOption {
              type = types.listOf types.path;
              default = [ ];
              description = "List of environment files (containing secrets/vars) to load for the service";
            };
            vars = lib.mkOption {
              type = types.attrsOf types.str;
              default = { };
              description = "Environment variables to pass to the OpenTofu execution";
            };
          };
        }
      );
    };
  };

  config = {
    systemd.services = lib.mapAttrs' (name: conf: {
      name = "opentofu-${name}";
      value = {
        description = "OpenTofu Configuration Manager for ${name}";
        wantedBy = [ "multi-user.target" ];
        path = [
          pkgs.opentofu
          pkgs.rsync
          pkgs.git
        ];

        serviceConfig = {
          Type = "oneshot";
          StateDirectory = "opentofu/${name}";
          WorkingDirectory = "/var/lib/opentofu/${name}";
          EnvironmentFile = conf.environmentFiles;
        };

        script = ''
          # Ensure working directory is initialized
          ${pkgs.rsync}/bin/rsync -av --delete --chmod=u+w \
            --exclude '.terraform' \
            --exclude '*.tfstate' \
            --exclude '*.tfstate.backup' \
            ${conf.source}/ .

          # Force provider refresh by removing local cache and lock file
          # This ensures the new version in the source is respected
          rm -f .terraform.lock.hcl
          rm -rf .terraform/providers

          # Export variables
          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList (n: v: ''
              export TF_VAR_${n}="${v}"
            '') conf.vars
          )}

          # Initialize OpenTofu and pull the new provider version
          ${pkgs.opentofu}/bin/tofu init -upgrade

          # Apply configuration
          ${pkgs.opentofu}/bin/tofu apply -auto-approve
        '';
      };
    }) cfg.configurations;
  };
}
