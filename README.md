# docker Firebird

## Supported tags and respective `Dockerfile` links

[`2.5-sc`, `2.5.8-sc` (*2.5-sc/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/2.5-sc/Dockerfile)

[`2.5-ss`, `2.5.8-ss` (*2.5-ss/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/2.5-ss/Dockerfile)

[`3.0`, `3.0.4` `latest` (*Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/master/Dockerfile)

## What's New
### 3.0.4 Sub Release
Firebird Project is happy to announce general availability of Firebird [3.0.4](https://www.firebirdsql.org/en/firebird-3-0-4/) — the 4th point release in the Firebird 3.0 series.

This sub-release offers many bug fixes and also adds a few improvements, please refer to the [Release Notes](https://www.firebirdsql.org/file/documentation/release_notes/html/en/3_0/rlsnotes30.html) for the full list of changes. Binary kits for Windows, Linux and Android platforms are immediately available for [download](https://www.firebirdsql.org/en/firebird-3-0-4/), Mac OS kits will follow shortly.


### 2.5.8 Sub Release
Firebird Project is happy to announce general availability of [Firebird 2.5.8](https://firebirdsql.org/en/firebird-2-5-8/) — the latest minor release in the Firebird 2.5 series.

This sub-release introduces several bug fixes and a few improvements, please refer to the [Release Notes](https://firebirdsql.org/file/documentation/release_notes/html/en/2_5/rlsnotes25.html) for the full list of changes. Binary kits for Windows and Linux on both 32-bit and 64-bit platforms are immediately available for [download](https://firebirdsql.org/en/firebird-2-5-8/). Binary kits for Mac OS X will follow shortly.

## Default password for `sysdba`
The default password for `sysdba` is randomly generated when you first launch the container, 
look in the docker log for your container or check `/firebird/etc/SYSDBA.password`.
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
The password used will be placed in `/firebird/etc/SYSDBA.password`.
If a random password is generated then it will be in the log for the container.

### `FIREBIRD_DATABASE`
If this is set then a database will be created with this name under the `/firebird/data` volume with the 'UTF8'
default character set and if `FIREBIRD_USER` is also set then `FIREBIRD_USER` will be given ownership.

### `FIREBIRD_USER`
This user will be created and given ownership of `FIREBIRD_DATABASE`.
This variable is only used if `FIREBIRD_DATABASE` is also set.

### `FIREBIRD_PASSWORD`
The password for `FIREBIRD_USER`, if left blank a random 20 character password will be set instead.
If a random password is generated then it will be in the log for the container.

### `EnableLegacyClientAuth`

If this is set to true then when launching without an existing /firebird/etc folder this will cause the newly created firebird.conf to have 
the following defaults:
```
AuthServer = Legacy_Auth, Srp, Win_Sspi 
AuthClient = Legacy_Auth, Srp, Win_Sspi 
UserManager = Legacy_UserManager, Srp 
WireCrypt = enabled 
```
This will allow legacy clients to connect and authenticate.

### `EnableWireCrypt`

If this is set to true then when launching without an existing /firebird/etc folder this will cause the newly created firebird.conf to have
`WireCrypt = enabled` to allow compatibility with Jaybird 3

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

### `/firebird`
This single volume supercedes all of the old volumes with most of the old volumes existing as subdirectories under `/firebird`

#### `/firebird/data`
Default location to put database files

#### `/firebird/system`
security database DIR

#### `/firebird/etc`
config files DIR
message files DIR

#### `/firebird/log`
log files DIR

### Read Only root filesystem
For some users they may prefer to run the filesystem in read only mode for additional security.
These volumes would need to be created rw in order to do this.

#### `/var/firebird/run`
This volume does not actually exist by default but you may want to create it if you wish to use a `read only` root filesystem
guardian lock DIR

#### `/tmp`
This volume does not actually exist by default but you may want to create it if you wish to use a `read only` root filesystem
Database lock directory

## Exposes: 
### 3050/tcp

## Health Check
I have now added [HEALTHCHECK support](https://docs.docker.com/engine/reference/builder/#healthcheck) to the image. By default it uses nc to check port 3050.
If you would like it to perform a more thorough check then you can create `/firebird/etc/docker-healthcheck.conf`
If you add `HC_USER` `HC_PASS` and `HC_DB` to that file then the healthcheck will attempt a simple query against the specified database to determine server status.

Example `docker-healthcheck.conf`:
```
HC_USER=SYSDBA
HC_PASS=masterkey
HC_DB=employee.fdb
```

## Events
Please note for events to work properly you must either configure RemoteAuxPort and forward it with -p using a direct mapping where both sides internal and external use the same port or use --net=host to allow the random port mapping to work.
see: http://www.firebirdfaq.org/faq53/ for more information on event port mapping.
