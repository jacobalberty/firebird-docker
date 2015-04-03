# docker Firebird

## Supported tags and respective `Dockerfile` links

[`2.5-sc`, `latest` (*2.5-sc/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/master/2.5-sc/Dockerfile)

[`2.5-ss` (*2.5-ss/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/master/2.5-ss/Dockerfile)

## Description
This is a Firebird SQL Database container.

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

## Exposes: 
### 3050/tcp

## Events
Please note for events to work properly you must either configure RemoteAuxPort and forward it with -p using a direct mapping where both sides internal and external use the same port or use --net=host to allow the random port mapping to work.
see: http://www.firebirdfaq.org/faq53/ for more information on event port mapping.
