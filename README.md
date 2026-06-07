## iTPL

`itpl` (iTunes PlayList in short) is a command line tool to export iTunes playlist with various options.
<!-- TOC -->

- [iTPL](#itpl)
  - [Features](#features)
  - [Install](#install)
  - [Usage](#usage)
    - [M3U Playlist](#m3u-playlist)
    - [Other Examples](#other-examples)
  - [Repository](#repository)
  - [Contributors](#contributors)

<!-- /TOC -->
<!--more-->

### Features

- Use iTunes Library/API, not relying on xml/plist
- List all playlists
- List duplicate of playlist
- List all items' path of a playlist
  - Put path inside single or double quotes
  - Remove base path
  - Add prefix string to output path
  - Output path in escaped format
  - Output path in NFC(Linux) encoding

### Install

```sh
git clone https://github.com/J-Siu/itpl.git
cd itpl
swift build -c release

# Copy binary to /usr/local/bin
cp .build/release/itpl /usr/local/bin/
```

### Usage

```sh
USAGE: options [-i] [-s] [-d] [-r <base path>] [-p <prefix>] [-e] [-n] [--qd] [--qs] [--debug] [<name>]

ARGUMENTS:
  <name>                  Play list name
        List all play list if no name is provided.

OPTIONS:
  -i                      Info mode
  -s                      Sort by title
  -d                      List duplicate.
  -r <base path>          Remove base path from item path output.
        Path output in full if it does not contain the provided base path.
  -p <prefix>             Add prefix string to each line.
  -e                      Escape format.
  -n                      Encode path in NFC(Linux) encoding.
  --qd                    Path in double quote.
  --qs                    Path in single quote.
  --debug                 Debug mode.
  -h, --help              Show help information.
```

#### M3U Playlist

```sh
itpl fav > fav.m3u
```

If Linux/NFC encoding is needed:

```sh
itpl fav -n > fav.m3u
```

#### Other Examples

```sh
# List all playlists
$ itpl
Library
Music
Music Videos
TV & Movies
Purchased
fav
Movies
Home Videos
TV Shows
Podcasts
Audiobooks
```

```sh
# List playlist fav items in escape format
$ itpl fav -e
/Users/js/Music/iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/01\ The\ Miracle\ \(Of\ Joey\ Ramone\).m4a
/Users/js/Music/iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/02\ Every\ Breaking\ Wave.m4a
/Users/js/Music/iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/03\ California\ \(There\ Is\ No\ End\ to\ Love\).m4a
/Users/js/Music/iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/04\ Song\ for\ Someone.m4a
/Users/js/Music/iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/05\ Iris\ \(Hold\ Me\ Close\).m4a
/Users/js/Music/iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/06\ Volcano.m4a
/Users/js/Music/iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/07\ Raised\ By\ Wolves.m4a
/Users/js/Music/iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/08\ Cedarwood\ Road.m4a
/Users/js/Music/iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/09\ Sleep\ Like\ a\ Baby\ Tonight.m4a
/Users/js/Music/iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/10\ This\ Is\ Where\ You\ Can\ Reach\ Me\ Now.m4a
/Users/js/Music/iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/11\ The\ Troubles.m4a
```

```sh
# List playlist fav items with base path /Users/js/Music/ removed
$ itpl fav -r /Users/js/Music/
iTunes/iTunes Media/Music/U2/Songs of Innocence/01 The Miracle (Of Joey Ramone).m4a
iTunes/iTunes Media/Music/U2/Songs of Innocence/02 Every Breaking Wave.m4a
iTunes/iTunes Media/Music/U2/Songs of Innocence/03 California (There Is No End to Love).m4a
iTunes/iTunes Media/Music/U2/Songs of Innocence/04 Song for Someone.m4a
iTunes/iTunes Media/Music/U2/Songs of Innocence/05 Iris (Hold Me Close).m4a
iTunes/iTunes Media/Music/U2/Songs of Innocence/06 Volcano.m4a
iTunes/iTunes Media/Music/U2/Songs of Innocence/07 Raised By Wolves.m4a
iTunes/iTunes Media/Music/U2/Songs of Innocence/08 Cedarwood Road.m4a
iTunes/iTunes Media/Music/U2/Songs of Innocence/09 Sleep Like a Baby Tonight.m4a
iTunes/iTunes Media/Music/U2/Songs of Innocence/10 This Is Where You Can Reach Me Now.m4a
iTunes/iTunes Media/Music/U2/Songs of Innocence/11 The Troubles.m4a
```

```sh
# Escape path, remove base path /Users/js/Music/, and add "ls -lh " in front
$ itpl fav -r /Users/js/Music/ -p "ls -lh " -e
ls -lh iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/01\ The\ Miracle\ \(Of\ Joey\ Ramone\).m4a
ls -lh iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/02\ Every\ Breaking\ Wave.m4a
ls -lh iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/03\ California\ \(There\ Is\ No\ End\ to\ Love\).m4a
ls -lh iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/04\ Song\ for\ Someone.m4a
ls -lh iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/05\ Iris\ \(Hold\ Me\ Close\).m4a
ls -lh iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/06\ Volcano.m4a
ls -lh iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/07\ Raised\ By\ Wolves.m4a
ls -lh iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/08\ Cedarwood\ Road.m4a
ls -lh iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/09\ Sleep\ Like\ a\ Baby\ Tonight.m4a
ls -lh iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/10\ This\ Is\ Where\ You\ Can\ Reach\ Me\ Now.m4a
ls -lh iTunes/iTunes\ Media/Music/U2/Songs\ of\ Innocence/11\ The\ Troubles.m4a
```

### Repository

- [itpl](https://github.com/J-Siu/itpl)

### Contributors

- [John Sing Dao Siu](https://github.com/J-Siu)
