# encoding: utf-8

require 'rubygems' if RUBY_VERSION.to_f < 1.9
require 'thor'
require 'dbus'

module RRadio
  class Task < Thor

    def initialize(args, opts={}, conf={})
      unless %w[
        help power
      ].include?(conf[:current_task].name)
        unless connect
          puts 'please power on ;)'
          exit
        end
      end
      super
    end

    desc 'power {on|off}', 'On/Off radiotray [synonym: po]'
    map  'po' => :power
    method_options :action => :string
    def power action=''
      res = `ps aux | grep '[r]adiotray'`.empty?
      on  = "\033[1;32mon\033[m"
      off = "\033[1;31moff\033[m"
      case action
      when /^on$/i
        res = `radiotray 1>/dev/null 2>&1 &`.nil? unless connect
      when /^off$/i
        res = `killall -15 radiotray` if connect
      end
      puts (res ? off : on)
    end

    desc 'list', 'Show bookmarks [synonym: ls]'
    map  'ls' => :list
    def list
      all_names = channels
      var_width = all_names.length.to_s.length
      all_names.each_with_index do |channel, index|
        var = index.to_s.rjust var_width, '0'
        if channel == playing
          puts "\033[1;30m$\[#{var}\] \033[1;31m#{channel}\033[m"
        else
          puts "\033[1;30m$\[#{var}\] \033[1;34m#{channel}\033[m"
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

    def connect
      (setup and init_player)
    end

    def setup
      begin
        @bus = DBus::SessionBus.instance
        @service = @bus.service('net.sourceforge.radiotray')
        return true
      rescue DBus::Error, Errno::ECONNREFUSED
        return false
      end
    end

    def init_player
      begin
        @player = @service.object('/net/sourceforge/radiotray')
        @player.default_iface = 'net.sourceforge.radiotray'
        @player.introspect
        return true
      rescue DBus::Error
        return false
      end
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
