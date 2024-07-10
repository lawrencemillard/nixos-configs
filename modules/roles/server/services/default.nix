{
  imports = [
    ./databases # mysql, postgreqsl, redis and more
    ./homepage-dashboard # homepage dashboard
    ./monitoring # prometheus, grafana, loki and uptime-kuma
    ./networking
    ./nginx # base nginx webserver configuration

    ./adguard.nix # adguard home dns server
    ./authelia.nix # authelia authentication server
    ./lldap.nix # authentication server
    ./mailserver.nix # nixos-mailserver setup
    ./nextcloud.nix # cloud storage (not a backup solution)
    ./searxng.nix # searx search engine
    ./suwayomi-server.nix # manga reader server
    ./vaultwarden.nix # bitwarden compatible password manager
  ];
}