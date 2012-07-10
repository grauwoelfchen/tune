#!/usr/bin/env ruby
# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RRadio::Task do
  context 'when radiotray has 3 channels' do
    before do
      player = double('player')
      player.stub(:default_iface=).with('net.sourceforge.radiotray').and_return(true)
      player.stub(:introspect)
      player.stub(:listRadios).and_return([['test', 'test', 'test']])
      player.stub(:playRadio).with('test').and_return('test')
      service = double('service')
      service.stub(:object).with('/net/sourceforge/radiotray').and_return(player)
      @dbus = mock(DBus::SessionBus)
      @dbus.stub(:service).with('net.sourceforge.radiotray').and_return(service)
      DBus::SessionBus.stub(:instance).and_return(@dbus)
    end
    describe ':list action' do
      before do
        @task = RRadio::Task.new(['list'], {}, {})
      end
      it 'should return 3 channels' do
        $stdout.should_receive(:puts).with(/test/).exactly(3).times
        @task.list.length.should eq 3
      end
    end
  end
end
