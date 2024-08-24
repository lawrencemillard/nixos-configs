{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}: let
  inherit (lib) mkIf mkGraphicalService getExe;
  inherit (osConfig) modules;
in {
  config = mkIf config.programs.chromium.enable {
    programs.chromium = {
      commandLineArgs = [
        "--enable-logging=stderr"
        "--ignore-gpu-blocklist"
      ];
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { # bypass paywalls
          id = "dcpihecpambacapedldabdbpakmachpb";
          updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
        }
        { # dark reader
          id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
          updateUrl = "https://clients2.google.com/service/update2/crx";
        }
      ];
    };
  };
}