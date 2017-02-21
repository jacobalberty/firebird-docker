# docker Firebird

## Supported tags and respective `Dockerfile` links

[`2.5-sc`, `2.5.7-sc` (*2.5-sc/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/2.5-sc/Dockerfile)

[`2.5-ss`, `2.5.7-ss` (*2.5-ss/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/2.5-ss/Dockerfile)

[`3.0`, `3.0.1` `latest` (*Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/master/Dockerfile)

## What's New
### Alpine branch on github
I have sort of built firebird under alpine, the build is at this time not working.
If you see a tag show up on the docker hub but not in the supported list above then do not expect it to work.
If you would like to poke around feel free to check out the github branch for 3.0-alpine.
### 2.5.7 released
2.5.7 packages were released by the Firebird Project and the images have been updated.
### `ISC_PASSWORD`, `FIREBIRD_USER`, `FIREBIRD_PASSWORD` and `FIREBIRD_DATABASE`
Support for setting the SYSDBA password through `ISC_PASSWORD` variable and creation of users/a default database
through `FIREBIRD_USER`, `FIREBIRD_PASSWORD` and `FIREBIRD_DATABASE`.
### Using Dynamic Matching on the Docker Hub now.
This will allow me to maintain more tags and branches to include older legacy versions and allow you pin against a specific version.
### 3.0 is now default
The "Latest" tag on docker hub is now 3.0.

## Default password for `sysdba`
The default password for `sysdba` is randomly generated when you first launch the container, 
look in the docker log for your container or pull /var/firebird/etc/SYSDBA.password.
Alternatively you may pass the environment variable ISC_PASSWORD to set the default password.

## Update policy
### Stable releases
I will maintain current versions of Stable firebird releases. Each version of the stable branches
will recieve a tag on both github and docker that will be semi permanent. The latest tagged
versions will periodically be deleted and remade if a new feature for the image is created.
Tags other than the latest release will not be updated as image specific features are implemented
#### 3.0
Any new image features will be developed on the 3.0 releases
#### 2.5
On request I am happy to attempt to backport any 3.0 image feature to the 2.5 branches
### Development policy
4.0 is presently in alpha I would like to start maintaining images when it moves into beta if time permits.
Until 4.0 hits RC stage I don't believe it will be feasible for me to maintain up to date images of 4.0 though
and until final release is made I do not intend to promise stability of tags, ie as new release candidates or betas 
get released I may remove older 4.0 tags.

## Description
This is a Firebird SQL Database container.

## Default Login information
Username: SYSDBA
Password is either set by `ISC_PASSWORD` or randomized

## Environment Variables:
### `TZ`
TimeZone. (i.e. America/Chicago)

### `ISC_PASSWORD`
Default `sysdba` user password, if left blank a random 20 character password will be set instead.
The password used will be placed in /var/firebird/etc/SYSDBA.password.
If a random password is generated then it will be in the log for the container.

### `FIREBIRD_DATABASE`
If this is set then a database will be created with this name under the `/databases` volume with the 'UTF8'
default character set and if `FIREBIRD_USER` is also set then `FIREBIRD_USER` will be given ownership.

### `FIREBIRD_USER`
This user will be created and given ownership of `FIREBIRD_DATABASE`.
This variable is only used if `FIREBIRD_DATABASE` is also set.

### `FIREBIRD_PASSWORD`
The password for `FIREBIRD_USER`, if left blank a random 20 character password will be set instead.
If a random password is generated then it will be in the log for the container.

### `<VARIABLE>_FILE`
If set to the path to a file then the named variable minus the _FILE portion will contain the contents of that file.
This is useful for using docker secrets to manage your password.
This applies to all variables except `TZ`

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
