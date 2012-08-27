# rradio

[![Build Status](https://secure.travis-ci.org/grauwoelfchen/rradio.png)](http://travis-ci.org/grauwoelfchen/rradio)

Simple client of radiotray ♪♪♪

## Install

```
$ gem install rradio

or

$ git clone https://github.com/grauwoelfchen/rradio.git
$ cd rradio
$ rake build
$ gem install pkg/rradio-x.x.x.gem
```

## Require

* dbus
* radiotray (runtime)

## Usage

You can specify channel with number index.

```
# run radiotray background
$ radiotray >/dev/null 2>&1 &

# list channels
$ rradio list
$[00] .977 Classic Rock
$[01] .977 The Hitz Channel
$[02] 181.FM
$[03] 181.FM Classic Hits
$[04] 80s Sky.FM
...

# start to listen
$ rradio play 01
.977 The Hitz Channel
```

See help.

```
Tasks:
  rradio help [TASK]             # Describe available tasks or one specific task
  rradio list                    # Show bookmarks [synonym: ls]
  rradio off                     # Turn off [synonym: stop]
  rradio play                    # Play radio [synonym: start]
  rradio show                    # Show radio channel [synonym: current]
  rradio volume {up|down} (1-5)  # Change volume [synonym: vol]
```

## Todo

* Add indicator
* Task for management of bookmarks (add, edit, delete)
* Display current song (possible ??)
