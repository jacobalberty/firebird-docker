# docker Firebird

## Supported tags and respective `Dockerfile` links

[`2.5-sc`, `v2.5.9-sc` (*2.5-sc/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/2.5-sc/Dockerfile)

[`2.5-ss`, `v2.5.9-ss` (*2.5-ss/Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/2.5-ss/Dockerfile)

[`3.0`, `v3.0`, `v3.0.9` (*Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/3.0/Dockerfile)

[`v4.0`, `v4.0.1`, `latest` (*Dockerfile*)](https://github.com/jacobalberty/firebird-docker/blob/master/Dockerfile)

## What's New

### Firebird 3.0.9 sub-release is available

Firebird Project is happy to announce general availability of [Firebird 3.0.9](https://firebirdsql.org/en/firebird-3-0-9/) — the latest point release in the Firebird 3.0 series.

This sub-release offers a few important bugfixes, please refer to the [Release Notes](https://firebirdsql.org/file/documentation/release_notes/html/en/3_0/rlsnotes30.html) for the full list of changes.
Binary kits for Windows, Linux and Android platforms are immediately available for [download](https://firebirdsql.org/en/firebird-3-0-9/), packages for Mac OS will follow shortly.

### Firebird Project is happy to announce general availability of [Firebird 4.0.1](https://firebirdsql.org/en/firebird-4-0-1/) — the first point release in the Firebird 4.0 series.

This sub-release offers many bug fixes and also adds a few improvements, please refer to the [Release Notes](https://firebirdsql.org/file/documentation/release_notes/html/en/4_0/rlsnotes40.html) for the full list of changes.
Binary kits for Windows, Linux and Android platforms are immediately available for [download](https://firebirdsql.org/en/firebird-4-0-1/).

### Firebird 3.0.8 sub-release is available

Firebird Project is happy to announce general availability of [Firebird 3.0.8](https://firebirdsql.org/en/firebird-3-0-8/) — the latest point release in the Firebird 3.0 series.

This sub-release offers many bug fixes and also adds a few improvements, please refer to the [Release Notes](https://firebirdsql.org/file/documentation/release_notes/html/en/3_0/rlsnotes30.html) for the full list of changes.
Binary kits for Windows, Linux, Mac OS and Android platforms are immediately available for [download](https://firebirdsql.org/en/firebird-3-0-8/).

### Base image is now on bullseye for 2.5-ss, 2.5-sc, 3.0 and 4.0 branches

This required a script to replace the libicu supplied by bullseye with the preferred one for the relevant firebird versions.
If for some reason you do get a [Collation unicode for character set utf8 is not installed](http://www.firebirdfaq.org/faq358/) error you can use
`gfix -icu <database>` to correct the issue as of firebird 3.0.

Both 2.5 branches are now included as well. Unfortunately the `gfix -icu <database>` option is not available for 2.5
so instead I have opted to add tags for `v2.5.9-sc-jessie` and `v2.5.9-ss-jessie`. If you find your setup works with the jessie tags but not the newer
`v2.5.9-sc` or `v2.5.9-ss` tags please switch back to the jessie tags and open an issue to let me know. This will probably be the last major update for v2.5 as 
version 2.5 has been [discontinued for 2 years now](https://firebirdsql.org/en/discontinued-versions/).

### Firebird Project is happy to announce general availability of [Firebird 4.0](https://firebirdsql.org/en/firebird-4-0/) — the latest major release of the Firebird relational database.

Firebird 4.0 introduces new data types and many improvements without radical changes in architecture or operation, the most important are:

-   Built-in logical replication;
-   Extended length of metadata identifiers (up to 63 characters);
-   New INT128 and DECFLOAT data types, longer precision for NUMERIC/DECIMAL data types;
-   Support for international time zones;
-   Configurable time-outs for connections and statements;
-   Pooling of external connections;
-   Batch operations in the API;
-   Built-in cryptographic functions;
-   New ODS (version 13) with new system and monitoring tables;
-   Maximum page size increased to 32KB.

Please refer to the [Release Notes](https://firebirdsql.org/file/documentation/release_notes/html/en/4_0/rlsnotes40.html) for the full list of changes. The complete [Language Reference](https://firebirdsql.org/file/documentation/html/en/refdocs/fblangref40/firebird-40-language-reference.html) is also available.

Binary kits for Windows, Linux and Android platforms (both 32-bit and 64-bit) are immediately available for [download](https://firebirdsql.org/en/firebird-4-0/).

### 3.0.7 Sub Release
Firebird Project is happy to announce general availability of Firebird [3.0.7](https://firebirdsql.org/en/firebird-3-0-7/) — the latest point release in the Firebird 3.0 series.

This sub-release offers many bug fixes and also adds a few improvements, please refer to the [Release Notes](https://firebirdsql.org/file/documentation/release_notes/html/en/3_0/rlsnotes30.html) for the full list of changes. Binary kits for Windows, Linux, Mac OS and Android platforms are immediately available for [download](https://firebirdsql.org/en/firebird-3-0-7/).

All users of Firebird v3.0.6 are strongly encouraged to upgrade to v3.0.7 as soon as possible due to several serious bugs found in v3.0.6 and fixed in this point release. 


### 2.5.9 Sub Release
The Firebird Project is happy to announce the general availability of [Firebird 2.5.9](https://firebirdsql.org/en/firebird-2-5-9/) — the latest minor release in the Firebird 2.5 series.

This sub-release introduces several bug fixes and a few improvements, please refer to the [Release Notes](https://firebirdsql.org/file/documentation/release_notes/html/en/2_5/rlsnotes25.html) for the full list of changes. Binary kits for Windows, Linux and MacOS X (both 32-bit and 64-bit) are immediately available for [download](https://firebirdsql.org/en/firebird-2-5-9/).

Also, in accordance with its release [lifetime policy](https://firebirdsql.org/en/release-policy/), the Firebird Project advises that the Firebird v2.5 series has reached its [end-of-life](http://en.wikipedia.org/wiki/End-of-life_(product)) and thus will not be maintained further. Once Firebird 4.0 is released, this last official release in the v.2.5 series, [Firebird 2.5.9](https://firebirdsql.org/en/firebird-2-5-9/), will be moved to the ["Discontinued Versions"](https://firebirdsql.org/en/discontinued-versions/) section of the download area.

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
The 2.5 series was eol'd by the firebird guys as of the 2.5.9 release. I do not anticipate any further updates to the 2.5 images.
### Development policy
4.0 has finally entered beta and along with it has some pretty major changes including ODS changes requiring a complete backup and restore to upgrade.
Because of this I am taking the opportunity to update the underlying debian image to debian buster. Currently the image builds but I have not tested using it yet.
In the coming months I will start making it usable.
I hope to have the 4.0 image usable by the time the official sources are at release candidate status.

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

### `DataTypeCompatibility`

If this is set then when launching without an existing /firebird/etc folder this will cause the newly created firebird.conf to set `DataTypeCompatibility` with the defined value supported by Firebird.
```
# ----------------------------
# Engine currently provides a number of new datatypes unknown to legacy clients.
# In order to simplify use of old applications set this parameter to minor FB
# version datatype compatibility with which you need. Currently two values are
# supported: 3.0 & 2.5.
# More precise (including per-session) tuning is possible via SQL and DPB.
#
# Per-database configurable.
#
#    Type: string
#
#DataTypeCompatibility =
```

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

#### `/firebird/restore`
Any `.fbk` files located in here that do not have a matching `.fdb` file under `/firebird/data` will automatically be restored via `gbak` to `/firebird/data` on container start.
The function that handles restoration starts by looking for `/firebird/etc/SYSDBA.password` if the file doesn't exist then no restoration attempts will be made.
If that file exists then it will check for a `.env` file matching the `.fbk` file in `/firebird/restore` and attempt to load `RESTORE_USER` and `RESTORE_PASSWORD` from that file but will fall back to `ISC_USER` and `ISC_PASSWORD` from `/firebird/etc/SYSDBA.password` if those values do not exist in the `.env` file or the `.env` file is missing.

So for example if you have `/firebird/restore/database.fbk` the script will first check if `/firebird/etc/SYSDBA.password` exists and fail if it doesn't. It will then check if `/firebird/data/database.fdb` exists. If that file does not exist the script will then attempt to restore `/firebird/restore/database.fbk` to `/firebird/data/database.fdb` using either `RESTORE_USER` and `RESTORE_PASSWORD` from `/firebird/restore/database.env` or if that file does not exist it will use `ISC_USER` and `ISC_PASSWORD` from  `/firebird/etc/SYSDBA.password`.

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

## Health Check0
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
