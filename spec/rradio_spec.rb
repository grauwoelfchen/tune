#!/usr/bin/env ruby
# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RRadio::Task do
  before do
    @player = double('player')
    @player.stub(:default_iface=).with('net.sourceforge.radiotray').and_return(true)
    @player.stub(:introspect)
    @service = double('service')
    @service.stub(:object).with('/net/sourceforge/radiotray').and_return(@player)
    @dbus = mock(DBus::SessionBus)
    @dbus.stub(:service).with('net.sourceforge.radiotray').and_return(@service)
    DBus::SessionBus.stub(:instance).and_return(@dbus)
  end
  context 'when radiotray has 3 channels' do
    before do
      @player.stub(:listRadios).and_return([['Jazz', 'R&B', 'Country']])
    end
    context 'when playing Jazz channel' do
      before do
        @player.stub(:playRadio).with('Jazz')
        @player.stub(:getCurrentRadio).and_return(['Jazz'])
        @player.stub(:turnOff).and_return(true)
        @player.stub(:volumeUp).and_return(true)
        @player.stub(:volumeDown).and_return(true)
      end
      describe ':list action' do
        before do
          @task = RRadio::Task.new ['list']
        end
        it 'should return 3 channels' do
          $stdout.should_receive(:puts).with(/Country|Jazz|R&B/).exactly(3).times
          @task.list.length.should eq 3
        end
        it 'should return sorted list' do
          $stdout.should_receive(:puts).with(/Country|Jazz|R&B/).exactly(3).times
          @task.list.should eq ['Country', 'Jazz', 'R&B']
        end
      end
      describe ':play action' do
        before do
          @task = RRadio::Task.new ['play']
        end
        it 'should display error with invalid index' do
          $stdout.should_receive(:puts).with(/does\snot\sexist/).exactly(1).times
          @task.play('5').should eq nil
        end
        it 'should display channel name' do
          $stdout.should_receive(:puts).with(/Jazz/).exactly(1).times
          @task.play('1').should eq nil
        end
      end
      describe ':off action' do
        before do
          @task = RRadio::Task.new ['off']
        end
        it 'should display channel name' do
          $stdout.should_receive(:puts).with(/Jazz/).once
          @task.off.should eq nil
        end
      end
      describe ':show action' do
        before do
          @task = RRadio::Task.new ['show']
        end
        it 'should display channel name' do
          $stdout.should_receive(:puts).with(/Jazz/).once
          @task.show.should eq nil
        end
      end
      describe ':volume action' do
        before do
          @task = RRadio::Task.new ['volume']
        end
        it 'should respond volume up with 1-5' do
          @task.volume('up', '1').should eq 1
          @task.volume('up', '3').should eq 3
        end
        it 'should respond volume up with too big value' do
          @task.volume('up', '99').should eq 5
        end
        it 'should respond volume down with 1-5' do
          @task.volume('up', '2').should eq 2
          @task.volume('up', '4').should eq 4
        end
        it 'should respond volume down with too big value' do
          @task.volume('up', '99').should eq 5
        end
        it 'should not respond with invalid action' do
          @task.volume('keep', '5').should eq nil
        end
      end
    end
    context 'when not playing radio' do
      before do
        @player.stub(:getCurrentRadio).and_return(nil)
      end
      describe ':off action' do
        before do
          @task = RRadio::Task.new ['off']
        end
        it 'should not respond and display nothing' do
          $stdout.should_not_receive(:puts)
          @task.off.should eq nil
        end
      end
      describe ':show action' do
        before do
          @task = RRadio::Task.new ['show']
        end
        it 'should not display channel name' do
          $stdout.should_receive(:puts).with(nil)
          @task.show.should eq nil
        end
      end
    end
  end
end
