# tune

[![Build Status](https://secure.travis-ci.org/grauwoelfchen/tune.png)](http://travis-ci.org/grauwoelfchen/tune)

Simple controller for Radio Tray ♪♪♪

* [Radio Tray](http://radiotray.sourceforge.net/)


## Install

```
$ gem install tune (not yet)

or

$ git clone https://github.com/grauwoelfchen/tune.git
$ cd tune
$ rake build
$ gem install pkg/tune-x.x.x.gem
```


## Require

* dbus
* radiotray (runtime)


## Usage

You can specify channel with number index.

```
# run radiotray
$ tune power on
on

# list channels
$ tune list
$[00] .977 Classic Rock
$[01] .977 The Hitz Channel
$[02] 181.FM
$[03] 181.FM Classic Hits
$[04] 80s Sky.FM
...

# start to listen
$ tune play 16
Groove Salad
```

See help.

```
Tasks:
  tune help [TASK]             # Describe available tasks or one specific task
  tune list                    # Show bookmarks [synonym: ls]
  tune off                     # Turn off [synonym: stop]
  tune play                    # Play radio [synonym: start]
  tune power {on|off}          # On/Off radiotray [synonym: po]
  tune show                    # Show radio channel [synonym: current]
  tune volume {up|down} (1-5)  # Change volume [synonym: vol]
```


## License

Copyright (c) 2012 Yasuhiro Asaka

MIT License


## Todo

* Improve spec description
* Add indicator (:play action takes sometimes a few seconds)
* Create action for management of bookmarks (add, edit, delete)
* Display current song (possible ??)
