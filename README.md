# rradio

[![Build Status](https://secure.travis-ci.org/grauwoelfchen/rradio.png)](http://travis-ci.org/grauwoelfchen/rradio)

Simple client of radiotray ♪♪♪


## Install

```
$ gem install rradio (not yet)

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
# run radiotray
$ rradio power on
on

# list channels
$ rradio list
$[00] .977 Classic Rock
$[01] .977 The Hitz Channel
$[02] 181.FM
$[03] 181.FM Classic Hits
$[04] 80s Sky.FM
...

# start to listen
$ rradio play 16
Groove Salad
```

See help.

```
Tasks:
  rradio help [TASK]             # Describe available tasks or one specific task
  rradio list                    # Show bookmarks [synonym: ls]
  rradio off                     # Turn off [synonym: stop]
  rradio play                    # Play radio [synonym: start]
  rradio power {on|off}          # On/Off radiotray [synonym: po]
  rradio show                    # Show radio channel [synonym: current]
  rradio volume {up|down} (1-5)  # Change volume [synonym: vol]
```


## License

Copyright (c) 2012 Yasuhiro Asaka

MIT License


## Todo

* Improve spec description
* Add indicator (:play action takes sometimes a few seconds)
* Create action for management of bookmarks (add, edit, delete)
* Display current song (possible ??)
* Raname to greate one :)
