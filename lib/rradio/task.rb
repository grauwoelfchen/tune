#!/usr/bin/env ruby
# encoding: utf-8

require 'thor'
require 'dbus'

module RRadio
  class Task < Thor

    def initialize(args, opts={}, conf={})
      super(args, opts, conf)
      _setup
    end

    desc 'list', 'Show bookmarks [synonym: ls]'
    map  'ls' => :list
    def list
      all_names = channels
      var_width = all_names.length.to_s.length
      all_names.each_with_index do |channel, index|
        var = index.to_s.rjust var_width, '0'
        if channel == playing
          puts "\033[1;30m$\[#{var}\] \033[1;31m#{channel}"
        else
          puts "\033[1;30m$\[#{var}\] \033[1;34m#{channel}"
        end
      end
    end

    desc 'play', 'Play radio [synonym: start]'
    map  'start' => :play
    method_options :channel => :string
    def play channel=''
      if channel =~ /^(\$*)(\d+)$/
        name = channels[$2.to_i]
      end
      if channel.empty?
        # same as `show`
        puts playing
      elsif !name
        puts "$#{channel} does not exist"
      else
        @player.playRadio name
        puts name
      end
    end

    desc 'off', 'Turn off [synonym: stop]'
    map  'stop' => :off
    def off
      if name = playing
        @player.turnOff
        puts name
      end
    end

    desc 'show', 'Show radio channel [synonym: current]'
    map  'current' => :show
    def show
      puts playing
    end

    desc 'volume {up|down} (1-5)', 'Change volume [synonym: vol]'
    map  'vol' => :volume
    method_options :action => :string, :value => :numeric
    def volume action=nil, value='1'
      if action =~ /^(up|down)$/
        value = value.to_i > 5 ? 5 : value.to_i
        value.times do
          @player.send "volume#{action.capitalize}".to_sym
        end
      end
    end

    private

    def _setup
      @bus = DBus::SessionBus.instance
      @service = @bus.service('net.sourceforge.radiotray')
      _init_player
    end

    def _init_player
      @player = @service.object('/net/sourceforge/radiotray')
      @player.default_iface = 'net.sourceforge.radiotray'
      @player.introspect
    end

    def channels
       @player.listRadios.first.sort
    end

    def playing
      radio = @player.getCurrentRadio
      radio.first if radio
    end
  end
end
