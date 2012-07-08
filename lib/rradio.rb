#!/usr/bin/env ruby
# encoding: utf-8

require 'rradio/task'

# NOTE
# $ dbus-send --help
# Usage: dbus-send [--help] [--system | --session | --address=ADDRESS] [--dest=NAME] [--type=TYPE] [--print-reply[=literal]] [--reply-timeout=MSEC] <destination object path> <message name> [contents ...]
# 
# Remote methods
#   * ListRadios
#   * turnOff
#   * volumeDown 
#   * playRadio
#   * getCurrentMetaData
#   * volumeUp
#   * playUrl
#   * getCurrentRadio
module RRadio
end
