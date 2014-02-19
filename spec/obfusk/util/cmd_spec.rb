# --                                                            ; {{{1
#
# File        : obfusk/util/cmd_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-19
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'obfusk/util/cmd'

ouc = Obfusk::Util::Cmd

describe 'obfusk/util/cmd' do

  context 'killsig' do                                          # {{{1
    it 'SIGINT' do
      ouc.killsig('SIGINT foo bar').should == \
        { command: 'foo bar', signal: 'SIGINT' }
    end
    it 'default' do
      ouc.killsig('foo bar').should == \
        { command: 'foo bar', signal: 'SIGTERM' }
    end
    it 'set default' do
      ouc.killsig('foo bar', 'SIGINT').should == \
        { command: 'foo bar', signal: 'SIGINT' }
    end
    it 'no match' do
      ouc.killsig('SIGx foo bar').should == \
        { command: 'SIGx foo bar', signal: 'SIGTERM' }
    end
  end                                                           # }}}1

  context 'shell' do                                            # {{{1
    it 'sh' do
      ouc.shell('SHELL=sh foo bar').should == \
        { command: 'foo bar', shell: 'sh' }
    end
    it 'default' do
      ouc.shell('SHELL echo "$FOO: $BAR"').should == \
        { command: 'echo "$FOO: $BAR"', shell: 'bash' }
    end
    it 'set default' do
      ouc.shell('SHELL foo bar', 'mysh').should == \
        { command: 'foo bar', shell: 'mysh' }
    end
    it 'no match' do
      ouc.shell('SHELLx foo bar').should == \
        { command: 'SHELLx foo bar', shell: nil }
    end
  end                                                           # }}}1

  context 'nohup' do                                            # {{{1
    it 'nohup' do
      ouc.nohup(*%w{ foo bar baz }).should == \
        %w{ nohup foo bar baz }
    end
  end                                                           # }}}1

  context 'set_vars' do                                         # {{{1
    it 'replace' do
      ouc.set_vars('echo ${FOO} ... ${BAR} ...',
                   'FOO' => 'foo', 'BAR' => 'bar').should == \
        'echo foo ... bar ...'
    end
    it 'multiple' do
      ouc.set_vars('echo ${FOO} ... ${FOO} ...',
                   'FOO' => 'foo').should == \
        'echo foo ... foo ...'
    end
    it 'missing' do
      ouc.set_vars('echo ${FOO} ... ${BAR} ...',
                   'BAR' => 'bar').should == \
        'echo  ... bar ...'
    end
  end                                                           # }}}1

  context 'env_to_a' do                                         # {{{1
    it 'simple' do
      ouc.env_to_a('FOO' => 'bar', 'PORT' => 1234).sort.should == \
        ['PORT=1234', 'FOO="bar"'].sort
    end
    it 'nils' do
      ouc.env_to_a('FOO' => 'bar', 'PORT' => nil).should == \
        ['FOO="bar"']
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
