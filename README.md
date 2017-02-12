# docker Firebird

## Supported tags and respective `Dockerfile` links

[`2.5-sc`, `2.5.6-sc` (*2.5-sc/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/2.5-sc/Dockerfile)

[`2.5-ss`, `2.5.6-ss` (*2.5-ss/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/2.5-ss/Dockerfile)

[`3.0`, `3.0.1` `latest` (*Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/master/Dockerfile)

## What's New
### Using Dynamic Matching on the Docker Hub now.
This will allow me to maintain more tags and branches to include older legacy versions and allow you pin against a specific version.
### 3.0 is now default
The "Latest" tag on docker hub is now 3.0.
## Default password for `sysdba`
The default password for `sysdba` is randomly generated when you first launch the container, 
look in the docker log for your container or pull /var/firebird/etc/SYSDBA.password.
Alternatively you may pass the environment variable ISC_PASSWORD to set the default password.


## Description
This is a Firebird SQL Database container.

## Default Login information
Username: SYSDBA
Password is either set by `ISC_PASSWORD` or randomized
Please be sure to change your password as soon as you log in.

## Environment Variables:
### `TZ`
TimeZone. (i.e. America/Chicago)

### `ISC_PASSWORD`
Default `sysdba` user password, if left blank a random 32 character password will be set instead.
The password used will be placed in /var/firebird/etc/SYSDBA.password and output in the log for the container.

## Server Architectures
At the moment only the "Super Classic" and "Super Server" architectures are available.

### SC
Super Classic.
### SS
Super Server.
### CS
Classic Server.

## Volumes:

### `/databases/`
Default location to put database files

### `/var/firebird/run`
guardian lock DIR

### `/var/firebird/etc`
config files DIR
message files DIR

### `/var/firebird/log`
log files DIR

### `/var/firebird/system`
security database DIR

### `/tmp/firebird`
Database lock directory

## Exposes: 
### 3050/tcp

## Events
Please note for events to work properly you must either configure RemoteAuxPort and forward it with -p using a direct mapping where both sides internal and external use the same port or use --net=host to allow the random port mapping to work.
see: http://www.firebirdfaq.org/faq53/ for more information on event port mapping.