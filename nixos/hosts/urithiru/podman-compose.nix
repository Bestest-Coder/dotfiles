# Auto-generated using compose2nix v0.3.2-pre.
{ pkgs, lib, config, ... }:

{
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      # Required for container networking to be able to use names.
      dns_enabled = true;
    };
  };

  # Enable container name DNS for non-default Podman networks.
  # https://github.com/NixOS/nixpkgs/issues/226365
  networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

  virtualisation.oci-containers.backend = "podman";

  # Containers
  # virtualisation.oci-containers.containers."caddy" = {
  #   image = "slothcroissant/caddy-cloudflaredns";
  #   volumes = [
  #     "/home/bestest/Caddy/Caddyfile:/etc/caddy/Caddyfile:rw"
  #     "/home/bestest/site:/srv:rw"
  #     "urithiru_caddy_config:/config:rw"
  #     "urithiru_caddy_data:/data:rw"
  #   ];
  #   ports = [
  #     "80:80/tcp"
  #     "443:443/tcp"
  #     "443:443/udp"
  #   ];
  #   log-driver = "journald";
  #   extraOptions = [
  #     "--network-alias=caddy"
  #     "--network=urithiru_default"
  #   ];
  # };
  # systemd.services."podman-caddy" = {
  #   serviceConfig = {
  #     Restart = lib.mkOverride 90 "always";
  #   };
  #   after = [
  #     "podman-network-urithiru_default.service"
  #     "podman-volume-urithiru_caddy_config.service"
  #     "podman-volume-urithiru_caddy_data.service"
  #   ];
  #   requires = [
  #     "podman-network-urithiru_default.service"
  #     "podman-volume-urithiru_caddy_config.service"
  #     "podman-volume-urithiru_caddy_data.service"
  #   ];
  #   partOf = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  #   wantedBy = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  # };
  virtualisation.oci-containers.containers."cloudflared" = {
    image = "docker.io/cloudflare/cloudflared";
    environment = {
    };
    environmentFiles = [
      config.age.secrets.cloudflare-env.path
    ];
    cmd = [ "tunnel" "run" "besthome" ];
    log-driver = "journald";
    extraOptions = [
      "--network=host"
      "-lio.containers.autoupdate=registry"
    ];
  };
  systemd.services."podman-cloudflared" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-urithiru-root.target"
    ];
    wantedBy = [
      "podman-compose-urithiru-root.target"
    ];
  };
  # virtualisation.oci-containers.containers."dendrite" = {
  #   image = "matrixdotorg/dendrite-monolith:latest";
  #   volumes = [
  #     "/home/bestest/matrix/config:/etc/dendrite:rw"
  #     "/home/bestest/matrix/jetstream:/var/dendrite/jetstream:rw"
  #     "/home/bestest/matrix/searchindex:/var/dendrite/searchindex:rw"
  #   ];
  #   ports = [
  #     "8008:8008/tcp"
  #     "8448:8448/tcp"
  #   ];
  #   dependsOn = [
  #     "postgres-dendrite"
  #   ];
  #   log-driver = "journald";
  #   extraOptions = [
  #     "--hostname=monolith"
  #     "--network-alias=monolith"
  #     "--network=urithiru_default"
  #   ];
  # };
  # systemd.services."podman-dendrite" = {
  #   serviceConfig = {
  #     Restart = lib.mkOverride 90 "always";
  #   };
  #   after = [
  #     "podman-network-urithiru_default.service"
  #   ];
  #   requires = [
  #     "podman-network-urithiru_default.service"
  #   ];
  #   partOf = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  #   wantedBy = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  # };
  # virtualisation.oci-containers.containers."homebox" = {
  #   image = "ghcr.io/hay-kot/homebox:latest";
  #   environment = {
  #     "HBOX_LOG_FORMAT" = "text";
  #     "HBOX_LOG_LEVEL" = "info";
  #     "HBOX_OPTIONS_ALLOW_REGISTRATION" = "false";
  #     "HBOX_WEB_MAX_UPLOAD_SIZE" = "10";
  #   };
  #   volumes = [
  #     "/home/bestest/homebox-data:/data:rw"
  #   ];
  #   ports = [
  #     "3100:7745/tcp"
  #   ];
  #   log-driver = "journald";
  #   extraOptions = [
  #     "--network-alias=homebox"
  #     "--network=urithiru_default"
  #   ];
  # };
  # systemd.services."podman-homebox" = {
  #   serviceConfig = {
  #     Restart = lib.mkOverride 90 "always";
  #   };
  #   after = [
  #     "podman-network-urithiru_default.service"
  #   ];
  #   requires = [
  #     "podman-network-urithiru_default.service"
  #   ];
  #   partOf = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  #   wantedBy = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  # };
  virtualisation.oci-containers.containers."jellyfin" = {
    image = "docker.io/jellyfin/jellyfin:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "/home/bestest/mediaserver/data:/data:rw"
      "/home/bestest/mediaserver/data/jellyfinconfig:/config:rw"
    ];
    ports = [
      "8096:8096/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--device=nvidia.com/gpu=all"
      "--network-alias=jellyfin"
      "--network=urithiru_default"
      "-lio.containers.autoupdate=registry"
    ];
  };
  systemd.services."podman-jellyfin" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-urithiru_default.service"
    ];
    requires = [
      "podman-network-urithiru_default.service"
    ];
    partOf = [
      "podman-compose-urithiru-root.target"
    ];
    wantedBy = [
      "podman-compose-urithiru-root.target"
    ];
  };
  # virtualisation.oci-containers.containers."playit-docker" = {
  #   image = "docker.io/pepaondrugs/playitgg-docker:latest";
  #   volumes = [
  #     "urithiru_playit-volume:/etc/playit:rw"
  #   ];
  #   log-driver = "journald";
  #   extraOptions = [
  #     "--network=host"
  #   ];
  # };
  # systemd.services."podman-playit-docker" = {
  #   serviceConfig = {
  #     Restart = lib.mkOverride 90 "always";
  #   };
  #   after = [
  #     "podman-volume-urithiru_playit-volume.service"
  #   ];
  #   requires = [
  #     "podman-volume-urithiru_playit-volume.service"
  #   ];
  #   partOf = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  #   wantedBy = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  # };
  # virtualisation.oci-containers.containers."postgres-dendrite" = {
  #   image = "docker.io/postgres:15.5-bookworm";
  #   environment = {
  #     "POSTGRES_DB" = "dendrite";
  #     "POSTGRES_PASSWORD" = "cockdickballin";
  #     "POSTGRES_USER" = "scrublord";
  #   };
  #   volumes = [
  #     "urithiru_postgres_dendrite_data:/var/lib/postgresql/data:rw"
  #   ];
  #   log-driver = "journald";
  #   extraOptions = [
  #     "--health-cmd=pg_isready -U scrublord"
  #     "--health-interval=5s"
  #     "--health-retries=5"
  #     "--health-timeout=5s"
  #     "--network-alias=postgres-dendrite"
  #     "--network=urithiru_default"
  #   ];
  # };
  # systemd.services."podman-postgres-dendrite" = {
  #   serviceConfig = {
  #     Restart = lib.mkOverride 90 "always";
  #   };
  #   after = [
  #     "podman-network-urithiru_default.service"
  #     "podman-volume-urithiru_postgres_dendrite_data.service"
  #   ];
  #   requires = [
  #     "podman-network-urithiru_default.service"
  #     "podman-volume-urithiru_postgres_dendrite_data.service"
  #   ];
  #   partOf = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  #   wantedBy = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  # };
  virtualisation.oci-containers.containers."prowlarr" = {
    image = "lscr.io/linuxserver/prowlarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "/home/bestest/mediaserver/data/prowlarrconfig:/config:rw"
    ];
    ports = [
      "9696:9696/tcp"
    ];
    dependsOn = [
      "wireguard"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=prowlarr"
      "--network=urithiru_default"
      "-lio.containers.autoupdate=registry"
    ];
  };
  systemd.services."podman-prowlarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-urithiru_default.service"
    ];
    requires = [
      "podman-network-urithiru_default.service"
    ];
    partOf = [
      "podman-compose-urithiru-root.target"
    ];
    wantedBy = [
      "podman-compose-urithiru-root.target"
    ];
  };
  virtualisation.oci-containers.containers."qbittorrent" = {
    image = "lscr.io/linuxserver/qbittorrent:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
      "WEBUI_PORT" = "8080";
    };
    volumes = [
      "/home/bestest/mediaserver/data/downloads:/data/downloads:rw"
      "/home/bestest/mediaserver/data/qbittorrentconfig:/config:rw"
    ];
    dependsOn = [
      "wireguard"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:wireguard"
      "-lio.containers.autoupdate=registry"
    ];
  };
  systemd.services."podman-qbittorrent" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-urithiru-root.target"
    ];
    wantedBy = [
      "podman-compose-urithiru-root.target"
    ];
  };
  virtualisation.oci-containers.containers."radarr" = {
    image = "lscr.io/linuxserver/radarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "/home/bestest/mediaserver/data:/data:rw"
      "/home/bestest/mediaserver/data/radarrconfig:/config:rw"
    ];
    ports = [
      "7878:7878/tcp"
    ];
    dependsOn = [
      "wireguard"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=radarr"
      "--network=urithiru_default"
      "-lio.containers.autoupdate=registry"
    ];
  };
  systemd.services."podman-radarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-urithiru_default.service"
    ];
    requires = [
      "podman-network-urithiru_default.service"
    ];
    partOf = [
      "podman-compose-urithiru-root.target"
    ];
    wantedBy = [
      "podman-compose-urithiru-root.target"
    ];
  };
  virtualisation.oci-containers.containers."sonarr" = {
    image = "lscr.io/linuxserver/sonarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "/home/bestest/mediaserver/data:/data:rw"
      "/home/bestest/mediaserver/data/sonarrconfig:/config:rw"
    ];
    ports = [
      "8989:8989/tcp"
    ];
    dependsOn = [
      "wireguard"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=sonarr"
      "--network=urithiru_default"
      "-lio.containers.autoupdate=registry"
    ];
  };
  systemd.services."podman-sonarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-urithiru_default.service"
    ];
    requires = [
      "podman-network-urithiru_default.service"
    ];
    partOf = [
      "podman-compose-urithiru-root.target"
    ];
    wantedBy = [
      "podman-compose-urithiru-root.target"
    ];
  };
  virtualisation.oci-containers."minecraft" = {
    image = "itzg/minecraft-server:java17";
    environment = {
      "VERSION" = "25w14craftmine";
      "EULA" = "TRUE";
      "INIT_MEMORY" = "1G";
      "MAX_MEMORY" = "6G";
    }
    volumes = [
      "/home/bestest/mc-server:/data:rw"
    ];
    ports = [
      "25565:25565/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=minecraft-server"
      "--network=urithiru_default"
    ];
  };
  systemd.services."podman-minecraft" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-urithiru_default.service"
    ];
    requires = [
      "podman-network-urithiru_default.service"
    ];
    partOf = [
      "podman-compose-urithiru-root.target"
    ];
    wantedBy = [
      "podman-compose-urithiru-root.target"
    ];
  };
  # virtualisation.oci-containers.containers."terrafirmacraft" = {
  #   image = "itzg/minecraft-server:java17";
  #   environment = {
  #     "CF_SLUG" = "terrafirmacraft-hardrock";
  #     "ENABLE_AUTOPAUSE" = "true";
  #     "EULA" = "TRUE";
  #     "INIT_MEMORY" = "1G";
  #     "MAX_MEMORY" = "6G";
  #     "MAX_TICK_TIME" = "-1";
  #     "REMOVE_OLD_MODS" = "TRUE";
  #     "TYPE" = "AUTO_CURSEFORGE";
  #   };
  #   environmentFiles = [
  #     config.age.secrets.curseforge-env.path
  #   ];
  #   volumes = [
  #     "/home/bestest/mc-downloads:/downloads:rw"
  #     "/home/bestest/tfc-server:/data:rw"
  #   ];
  #   ports = [
  #     "25565:25565/tcp"
  #   ];
  #   log-driver = "journald";
  #   extraOptions = [
  #     "--network-alias=terrafirmacraft"
  #     "--network=urithiru_default"
  #   ];
  # };
  # systemd.services."podman-terrafirmacraft" = {
  #   serviceConfig = {
  #     Restart = lib.mkOverride 90 "no";
  #   };
  #   after = [
  #     "podman-network-urithiru_default.service"
  #   ];
  #   requires = [
  #     "podman-network-urithiru_default.service"
  #   ];
  #   partOf = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  #   wantedBy = [
  #     "podman-compose-urithiru-root.target"
  #   ];
  # };
  virtualisation.oci-containers.containers."wireguard" = {
    image = "lscr.io/linuxserver/wireguard:latest";
    environment = {
      "LOG_CONFS" = "true";
      "PERSISTENTKEEPALIVE_PEERS" = "";
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "/home/bestest/mediaserver/data/wireguardconfig:/config:rw"
      "/lib/modules:/lib/modules:rw"
    ];
    ports = [
      "51820:51820/udp"
      "8080:8080/tcp"
      "6881:6881/tcp"
      "6881:6881/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_MODULE"
      "--hostname=wireguard"
      "--network-alias=wireguard"
      "--network=urithiru_default"
      "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
      "--sysctl=net.ipv4.ip_forward=1"
      "-lio.containers.autoupdate=registry"
    ];
  };
  systemd.services."podman-wireguard" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-urithiru_default.service"
    ];
    requires = [
      "podman-network-urithiru_default.service"
    ];
    partOf = [
      "podman-compose-urithiru-root.target"
    ];
    wantedBy = [
      "podman-compose-urithiru-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-urithiru_default" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f urithiru_default";
    };
    script = ''
      podman network inspect urithiru_default || podman network create urithiru_default
    '';
    partOf = [ "podman-compose-urithiru-root.target" ];
    wantedBy = [ "podman-compose-urithiru-root.target" ];
  };

  # Volumes
  # systemd.services."podman-volume-urithiru_caddy_config" = {
  #   path = [ pkgs.podman ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  #   script = ''
  #     podman volume inspect urithiru_caddy_config || podman volume create urithiru_caddy_config
  #   '';
  #   partOf = [ "podman-compose-urithiru-root.target" ];
  #   wantedBy = [ "podman-compose-urithiru-root.target" ];
  # };
  # systemd.services."podman-volume-urithiru_caddy_data" = {
  #   path = [ pkgs.podman ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  #   script = ''
  #     podman volume inspect urithiru_caddy_data || podman volume create urithiru_caddy_data
  #   '';
  #   partOf = [ "podman-compose-urithiru-root.target" ];
  #   wantedBy = [ "podman-compose-urithiru-root.target" ];
  # };
  # systemd.services."podman-volume-urithiru_playit-volume" = {
  #   path = [ pkgs.podman ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  #   script = ''
  #     podman volume inspect urithiru_playit-volume || podman volume create urithiru_playit-volume
  #   '';
  #   partOf = [ "podman-compose-urithiru-root.target" ];
  #   wantedBy = [ "podman-compose-urithiru-root.target" ];
  # };
  # systemd.services."podman-volume-urithiru_postgres_dendrite_data" = {
  #   path = [ pkgs.podman ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  #   script = ''
  #     podman volume inspect urithiru_postgres_dendrite_data || podman volume create urithiru_postgres_dendrite_data
  #   '';
  #   partOf = [ "podman-compose-urithiru-root.target" ];
  #   wantedBy = [ "podman-compose-urithiru-root.target" ];
  # };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-urithiru-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
