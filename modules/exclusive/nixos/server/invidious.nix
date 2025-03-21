#
# Invidious service
#
# This does not mean you cannot be tracked as browser fingerprinting, IP address logging,
# pattern analysis, etc. are still possible.
#
{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault mkForce;

  domain = "yt.xilain.dev";
  sys = config.modules.system;
  cfg = sys.services;

  inherit (cfg.invidious.settings) port host;
in {
  config = mkIf config.services.invidious.enable {
    services = {
      invidious = {
        port = mkDefault port;
        domain = mkDefault domain;
        settings = {
          https_only = false;
          default_user_preferences = {
            locale = "en-US";
            region = "CA";
            captions = ["Vietnamese" "English" "English (auto-generated)"];
            feed_menu = ["Subscriptions" "Playlists"];
            default_home = "Subscriptions";
            player_style = "youtube";
            quality = "dash"; # "hd720";
            dark_mode = "auto";
          };
          database = {
            createLocally = mkForce true;
            port = mkDefault 5432;
            host = mkDefault "/run/postgresql";
          };
          db = {
            dbname = mkForce "invidious";
            user = mkForce "invidious";
            # password = mkForce "changeme";
          };
        };
      };

      nginx.virtualHosts.${domain} =
        {
          # enableAuthelia = true; # add custom authelia location

          # extraConfig = ''
          #   location / {
          #     set $upstream_homer http://${host}:${toString port};  #CHANGE NAME AND IP AND PORT
          #     proxy_pass $upstream_homer;  #change name of the service

          #     auth_request /authelia;
          #     auth_request_set $target_url $scheme://$http_host$request_uri;
          #     auth_request_set $user $upstream_http_remote_user;
          #     auth_request_set $groups $upstream_http_remote_groups;
          #     proxy_set_header Remote-User $user;
          #     proxy_set_header Remote-Groups $groups;
          #     error_page 401 =302 https://auth.xilain.dev/?rd=$target_url; #change YOURDOMAIN.COM to your domain

          #     client_body_buffer_size 128k;

          #     proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

          #     send_timeout 5m;
          #     proxy_read_timeout 360;
          #     proxy_send_timeout 360;
          #     proxy_connect_timeout 360;

          #     proxy_set_header Host $host;
          #     proxy_set_header X-Real-IP $remote_addr;
          #     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          #     proxy_set_header X-Forwarded-Proto $scheme;
          #     proxy_set_header X-Forwarded-Host $http_host;
          #     proxy_set_header X-Forwarded-Uri $request_uri;
          #     proxy_set_header X-Forwarded-Ssl on;
          #     proxy_redirect  http://  $scheme://;
          #     proxy_http_version 1.1;
          #     proxy_set_header Connection "";
          #     proxy_cache_bypass $cookie_session;
          #     proxy_no_cache $cookie_session;
          #     proxy_buffers 64 256k;

          #     set_real_ip_from 192.168.1.0/16;
          #     real_ip_header X-Forwarded-For;
          #     real_ip_recursive on;
          #   }
          # '';

          locations."/" = {
            proxyPass = "http://${host}:${toString port}";
          };
          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
