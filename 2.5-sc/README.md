# docker Firebird

## Supported tags and respective `Dockerfile` links

[`2.5-sc`, `latest` (*2.5-sc/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/master/2.5-sc/Dockerfile)

[`2.5-ss` (*2.5-ss/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/master/2.5-ss/Dockerfile)

[`3.0B2`, `3.0`, `3` (*3.0-sc/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/master/3.0/Dockerfile)

## What's New
### 3.0 tag
Beta 2 of 3.0 is being tagged so you can start testing it out.
Firebird 3.0 is drastically different so I reccomend reading the [release notes](http://web.firebirdsql.org/download/prerelease/rlsnotes/Firebird-3.0.0_Beta2-ReleaseNotes.pdf)
## Default Username/password
The default username and password are now set to SYSDBA/masterkey.
Please note that the 3.0 tag does not yet include the default password and will change every time a new build is pushed.
Check /var/firebird/etc/SYSDBA.password for the credentials for your current build.

## Description
This is a Firebird SQL Database container.

## Default Login information
Username: SYSDBA
Password: masterkey
Please be sure to change your password as soon as you log in.

## Environment Variables:
### `TZ`
TimeZone. (i.e. America/Chicago)

## Server Architectures
At the moment only the "Super Classic" and "Super Server" architectures are available.

### SC
Super Classic.
### SS
Super Server.
### CS
Classic Server.

Latest is the same as 2.5-sc

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
