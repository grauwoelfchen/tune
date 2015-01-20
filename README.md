# tune

[![Build Status](https://secure.travis-ci.org/grauwoelfchen/tune.png)](http://travis-ci.org/grauwoelfchen/tune)

Simple controller for Radio Tray ♪♪♪

* [Radio Tray](http://radiotray.sourceforge.net/)


## Installation

```
$ gem install tune

or

$ git clone https://github.com/grauwoelfchen/tune.git
$ cd tune
$ rake build
$ gem install pkg/tune-x.x.x.gem
```


## Requirements

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

Copyright (c) 2012,2015 Yasuhiro Asaka

MIT License


## Change Log

* 2015.01.21, 0.0.6 Add 2.1.5 travis ruby test target. Add LICENSE into gemspec.
* 2013.11.01, 0.0.5 Update task to be suitable for thor ~> 0.18.1
* 2013.10.28, 0.0.4 Updated `power off` to kill process via pid (tested with ruby-1.9.3-p448, ruby-2.0.0-p247)
                    Specified rspec version for travis (as 2.12.0)
* 2013.02.15, 0.0.3 Removed unused gems and files (tested with ruby-1.9.3-p385)
* 2012.12.04, 0.0.2 Updated README :p
* 2012.12.04, 0.0.1 Released as gem !


## Todo

* Improve spec description
* Add indicator (:play action takes sometimes a few seconds)
* Create action for management of bookmarks (add, edit, delete)
* Display current song (possible ??)
