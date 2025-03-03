{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.programs.nixvim.plugins.mark-radar;
  helpers = import ../helpers.nix { inherit lib; };
  defs = import ../plugin-defs.nix { inherit pkgs; };
in {
  options.programs.nixvim.plugins.mark-radar = {
    enable = mkEnableOption "Enable mark-radar";

    highlight_background = mkOption {
      type = with types; nullOr bool;
      default = null;
    };

    background_highlight_group = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    highlight_group = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    set_default_keybinds = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };

  config = let
    opts = helpers.toLuaObject {
      inherit (cfg) highlight_group background_highlight_group;
      set_default_mappings = cfg.set_default_keybinds;
      background_highlight = cfg.highlight_background;
    };
  in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ defs.mark-radar ];

      extraConfigLua = ''
        require("mark-radar").setup(${opts})
      '';
    };
  };
}
