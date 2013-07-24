# --                                                            ; {{{1
#
# File        : obfusk/util/process_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'obfusk/util/process'

pr = Obfusk::Util::Process

describe 'obfusk/util/process' do

  context 'age' do                                              # {{{1
    it 'age' do
      pid = spawn 'sleep 100'
      begin
        pr.age(pid).should match /^00:0\d$/                     # ????
      ensure
        Process.kill 'TERM', pid; Process.wait pid
      end
    end
  end                                                           # }}}1

  context 'alive' do                                            # {{{1
    it 'alive' do
      pid = spawn 'sleep 100'
      begin
        pr.alive?(pid).should == true
      ensure
        Process.kill 'TERM', pid; Process.wait pid
      end
    end
    it 'not alive' do
      pid = spawn 'sleep 100'
      Process.kill 'TERM', pid; Process.wait pid
      pr.alive?(pid).should == false
    end
    it 'not mine' do
      pr.alive?(1).should == :not_mine  # init should be alive  # ????
    end
  end                                                           # }}}1

  context 'ispid!' do                                           # {{{1
    it 'pid' do
      pr.ispid!(12345).should be_true
    end
    it 'not a pid' do
      expect { pr.ispid!('12345') } .to \
        raise_error(ArgumentError, 'invalid PID')
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
