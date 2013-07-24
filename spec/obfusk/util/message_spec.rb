# --                                                            ; {{{1
#
# File        : obfusk/util/message_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'obfusk/util/message'
require 'obfusk/util/spec'

ou = Obfusk::Util

describe 'obfusk/util/message' do

  context 'ohai' do                                             # {{{1
    it 'no colours' do
      ou.capture_stdout { ou.ohai 'hi there!' } .should == \
        "==> hi there!\n"
    end
    it 'colours' do
      ou.capture_stdout(:tty) { ou.ohai 'hi there!' } \
        .should == "\e[1;34m==> \e[1;37mhi there!\e[0m\n"
    end
  end                                                           # }}}1

  context 'onow' do                                             # {{{1
    it 'no colours' do
      ou.capture_stdout { ou.onow 'Do', *%w{ foo bar } } .should == \
        "==> Do: foo, bar\n"
    end
    it 'colours' do
      ou.capture_stdout(:tty) { ou.onow 'Do', *%w{ foo bar } } \
        .should == "\e[1;32m==> \e[1;37mDo\e[0m: " +
                   "\e[1;32mfoo\e[0m, \e[1;32mbar\e[0m\n"
    end
  end                                                           # }}}1

  context 'onoe' do                                             # {{{1
    it 'no colours' do
      ou.capture_stderr { ou.onoe 'oops!' } .should == \
        "Error: oops!\n"
    end
    it 'colours' do
      ou.capture_stderr(:tty) { ou.onoe 'oops!' } \
        .should == "\e[1;31mError\e[0m: oops!\n"
    end
    it 'logger' do
      log = []; l = ->(msg) { log << msg }
      ou.capture_stderr { ou.onoe 'oops!', log: l }
      log.should == ['Error: oops!']
    end
  end                                                           # }}}1

  context 'opoo' do                                             # {{{1
    it 'label' do
      ou.capture_stderr { ou.opoo 'oops!' } .should == \
        "Warning: oops!\n"
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
