# encoding: utf-8

require 'stringio'
require 'ostruct'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Kernel
  # for stdout/stderr
  def capture(stream)
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
  context 'radiotray process does not exist yet' do
    # pending
  end
  context 'radiotray process is already started' do
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
    context 'when playing Jazz channel' do
      before do
        @player.stub(:turnOff).and_return(true)
        @player.stub(:volumeUp).and_return(true)
        @player.stub(:volumeDown).and_return(true)
        @player.stub(:playRadio).with(/Jazz|R&B/)
        @player.stub(:getCurrentRadio).and_return(['Jazz'])
        @player.stub(:listRadios).and_return([[
          'Jazz',   # $[01]
          'R&B',    # $[02]
          'Country' # $[03]
        ]])
      end
      describe ':list action' do
        let(:conf){ {:current_task =>  OpenStruct.new(:name => 'list')} }
        let(:task){ RRadio::Task.new(['list'], [], conf)  }
        before do
          @stdout = capture(:stdout){ @result = task.list }
        end
        it 'should return all channels' do
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
      describe ':play action with invalid index' do
        let(:conf){ {:current_task =>  OpenStruct.new(:name => 'play')} }
        let(:task){ RRadio::Task.new(['play'], [], conf) }
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
      describe ':play action with any args' do
        let(:conf){ {:current_task =>  OpenStruct.new(:name => 'play')} }
        let(:task){ RRadio::Task.new(['play'], [], conf) }
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
      describe ':play action with other channel' do
        let(:conf){ {:current_task =>  OpenStruct.new(:name => 'play')} }
        let(:task){ RRadio::Task.new(['play'], [], conf) }
        before do
          @stdout = capture(:stdout){ @result = task.play('02') }
        end
        it 'should display switched new channel' do
          @result.should eq nil
          @stdout.chomp.should eq 'R&B'
        end
        it 'should call :puts once', :ruby => 1.9 do
          $stdout.should_receive(:puts).with('R&B').once
          task.play('02').should eq nil
        end
      end
      describe ':off action' do
        let(:conf){ {:current_task =>  OpenStruct.new(:name => 'off')} }
        let(:task){ RRadio::Task.new(['off'], [], conf) }
        before do
          @stdout = capture(:stdout){ @result = task.off }
        end
        it 'should display stoped channel' do
          @result.should eq nil
          @stdout.chomp.should eq 'Jazz'
        end
        it 'should call :puts once', :ruby => 1.9 do
          $stdout.should_receive(:puts).with(/Jazz/).once
          task.off.should eq nil
        end
      end
      describe ':show action' do
        let(:conf){ {:current_task =>  OpenStruct.new(:name => 'show')} }
        let(:task){ RRadio::Task.new(['show'], [], conf) }
        before do
          @stdout = capture(:stdout){ @result = task.show }
        end
        it 'should display current channel' do
          @result.should eq nil
          @stdout.chomp.should eq 'Jazz'
        end
        it 'should call :puts once', :ruby => 1.9 do
          $stdout.should_receive(:puts).with(/Jazz/).once
          task.show.should eq nil
        end
      end
      describe ':volume action with invalid value' do
        let(:conf){ {:current_task =>  OpenStruct.new(:name => 'volume')} }
        let(:task){ RRadio::Task.new(['volume'], [], conf) }
        it 'should up volume as 5 with too big value' do
          task.volume('up', '99').should eq 5
        end
        it 'should down volume as 5 with too big value' do
          task.volume('up', '99').should eq 5
        end
        it 'should not respond with invalid action' do
          task.volume('keep', '5').should eq nil
        end
      end
      describe ':volume action with valid value' do
        let(:conf){ {:current_task =>  OpenStruct.new(:name => 'volume')} }
        let(:task){ RRadio::Task.new(['volume'], [], conf) }
        it 'should up volume' do
          task.volume('up', '1').should eq 1
          task.volume('up', '3').should eq 3
        end
        it 'should down volume' do
          task.volume('up', '2').should eq 2
          task.volume('up', '4').should eq 4
        end
      end
    end

    context 'when not playing any channel' do
      before do
        @player.stub(:getCurrentRadio).and_return(['not playing'])
        @player.stub(:turnOff).and_return(nil)
      end
      describe ':off action' do
        let(:conf){ {:current_task =>  OpenStruct.new(:name => 'off')} }
        let(:task){ RRadio::Task.new(['off'], [], conf) }
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
        let(:conf){ {:current_task =>  OpenStruct.new(:name => 'show')} }
        let(:task){ RRadio::Task.new(['show'], [], conf) }
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
