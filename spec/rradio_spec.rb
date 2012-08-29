#!/usr/bin/env ruby
# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Kernel
  def self.capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval "$#{stream} = #{stream.upcase}"
    end
    result
  end
end
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
      @player.stub(:listRadios).and_return([[
        'Jazz',   # $[01]
        'R&B',    # $[02]
        'Country' # $[03]
      ]])
    end
    # radiotray active
    context 'when playing Jazz channel' do
      before do
        @player.stub(:playRadio).with(/Jazz|R&B/)
        @player.stub(:getCurrentRadio).and_return(['Jazz'])
        @player.stub(:turnOff).and_return(true)
        @player.stub(:volumeUp).and_return(true)
        @player.stub(:volumeDown).and_return(true)
      end
      describe ':list action' do
        let(:task){ RRadio::Task.new ['list'] }
        before do
          @stdout = capture(:stdout){ @result = task.list }
        end
        it 'should return channels' do
          @stdout.split("\n").length.should eq 3
          @result.length.should eq 3
        end
        it 'should return sorted list' do
          @stdout.split("\n").length.should eq 3
          @result.should eq ['Country', 'Jazz', 'R&B']
        end
        it 'should call :puts 3 times', :ruby => 1.9 do
          $stdout.should_receive(:puts).with(/Country|Jazz|R&B/).exactly(3).times
          task.list.length.should eq 3
        end
      end
      describe ':play action' do
        context 'when invalid index given as argment' do
          let(:task){ RRadio::Task.new ['play'] }
          before do
            @stdout = capture(:stdout){ @result = task.play('05') }
          end
          it 'should display error' do
            @result.should eq nil
            @stdout.chomp.should eq '$05 does not exist'
          end
          it 'should call :puts once', :ruby => 1.9 do
            $stdout.should_receive(:puts).with(/\w?does\snot\sexist$/).once
            task.play('05').should eq nil
          end
        end
        context 'when switch channel' do
          let(:task){ RRadio::Task.new ['play'] }
          before do
            @stdout = capture(:stdout){ @result = task.play('02') }
          end
          it 'should display channel name' do
            @result.should eq nil
            @stdout.chomp.should eq 'R&B'
          end
          it 'should call :puts once', :ruby => 1.9 do
            $stdout.should_receive(:puts).with('R&B').once
            task.play('02').should eq nil
          end
        end
        context 'when no index given' do
          let(:task){ RRadio::Task.new ['play'] }
          before do
            @stdout = capture(:stdout){ @result = task.play }
          end
          it 'should display current channel' do
            @result.should eq nil
            @stdout.chomp.should eq 'Jazz'
          end
          it 'should call :puts once', :ruby => 1.9 do
            $stdout.should_receive(:puts).with('Jazz').once
            task.play.should eq nil
          end
        end
      end
      describe ':off action' do
        let(:task){ RRadio::Task.new ['off'] }
        before do
          @stdout = capture(:stdout){ @result = task.off }
        end
        it 'should display channel name' do
          @result.should eq nil
          @stdout.chomp.should eq 'Jazz'
        end
        it 'should call :puts once', :ruby => 1.9 do
          $stdout.should_receive(:puts).with(/Jazz/).once
          task.off.should eq nil
        end
      end
      describe ':show action' do
        let(:task){ RRadio::Task.new ['show'] }
        before do
          @stdout = capture(:stdout){ @result = task.show }
          @task = RRadio::Task.new ['show']
        end
        it 'should display channel name' do
          @result.should eq nil
          @stdout.chomp.should eq 'Jazz'
        end
        it 'should call :puts once', :ruby => 1.9 do
          $stdout.should_receive(:puts).with(/Jazz/).once
          task.show.should eq nil
        end
      end
      describe ':volume action' do
        let(:task){ RRadio::Task.new ['volume'] }
        it 'should respond volume up with 1-5' do
          task.volume('up', '1').should eq 1
          task.volume('up', '3').should eq 3
        end
        it 'should respond volume up with too big value' do
          task.volume('up', '99').should eq 5
        end
        it 'should respond volume down with 1-5' do
          task.volume('up', '2').should eq 2
          task.volume('up', '4').should eq 4
        end
        it 'should respond volume down with too big value' do
          task.volume('up', '99').should eq 5
        end
        it 'should not respond with invalid action' do
          task.volume('keep', '5').should eq nil
        end
      end
    end
    # radiotray inactive
    context 'when not playing radio' do
      before do
        @player.stub(:getCurrentRadio).and_return(['not playing'])
        @player.stub(:turnOff).and_return(nil)
      end
      describe ':off action' do
        let(:task){ RRadio::Task.new ['off'] }
        before do
          @stdout = capture(:stdout){ @result = task.off }
        end
        it 'should not respond and display "not playing"' do
          @result.should eq nil
          @stdout.chomp.should eq 'not playing'
        end
        it 'should call :puts once', :ruby => 1.9 do
          $stdout.should_receive(:puts).with('not playing').once
          task.off.should eq nil
        end
      end
      describe ':show action' do
        let(:task){ RRadio::Task.new ['show'] }
        before do
          @stdout = capture(:stdout){ @result = task.show }
        end
        it 'should display "not playing"' do
          @result.should eq nil
          @stdout.chomp.should eq 'not playing'
        end
        it 'should call :puts once', :ruby => 1.9 do
          $stdout.should_receive(:puts).with('not playing').once
          task.show.should eq nil
        end
      end
    end
  end
end
