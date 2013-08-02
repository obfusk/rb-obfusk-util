# --                                                            ; {{{1
#
# File        : obfusk/util/opt_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require 'obfusk/util/opt'

op = Obfusk::Util::Opt

describe 'obfusk/util/opt' do

  context 'Parser' do                                           # {{{1
    it 'parse_r' do
      x = nil
      p = op::Parser.new do |o|
        o.on('--help', 'Show help') { x = 'HELP' }
      end
      args1 = %w{ foo --help bar }; args2 = p.parse_r args1
      x.should == 'HELP'
      args1.should == %w{ foo --help bar }
      args2.should == %w{ foo bar }
    end
    it 'no officious' do
      expect { op::Parser.new.parse_r %w{ --help } } .to \
        raise_error(OptionParser::InvalidOption, /--help/)
    end
  end                                                           # }}}1

  context 'parse' do                                            # {{{1
    it 'parse' do
      p = op::Parser.new do |o|
        o.on('--help', 'Show help') {}
      end
      args1 = %w{ foo --help bar }; args2 = op.parse p, args1
      args1.should == %w{ foo --help bar }
      args2.should == %w{ foo bar }
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
