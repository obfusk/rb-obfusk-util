# --                                                            ; {{{1
#
# File        : obfusk/util/die_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require 'obfusk/util/die'
require 'obfusk/util/message'
require 'obfusk/util/spec'

ou = Obfusk::Util

describe 'obfusk/util/die' do

  context 'die!' do                                             # {{{1
    it 'exit + messages' do
      ou.capture_stderr do
        expect { ou.die!(*%w{ foo bar baz }) } \
          .to raise_error(SystemExit)
      end .should == "Error: foo\nError: bar\nError: baz\n"
    end
    it 'default value' do
      begin ou.capture_stderr { ou.die!('foo') }
      rescue SystemExit => e; e; end .status .should == 1
    end
    it 'default value' do
      begin ou.capture_stderr { ou.die!('foo', status: 42) }
      rescue SystemExit => e; e; end .status .should == 42
    end
  end                                                           # }}}1

  context 'udie!' do                                            # {{{1
    usage = 'prog [<opt(s)>]'
    it 'exit + messages' do
      ou.capture_stderr do
        expect { ou.udie!(usage, *%w{ foo bar }) } \
          .to raise_error(SystemExit)
      end .should == "Error: foo\nError: bar\nUsage: #{usage}\n"
    end
    it 'default value' do
      begin ou.capture_stderr { ou.udie!(usage) }
      rescue SystemExit => e; e; end .status .should == 1
    end
    it 'default value' do
      begin ou.capture_stderr { ou.udie!(usage, status: 42) }
      rescue SystemExit => e; e; end .status .should == 42
    end
  end                                                           # }}}1

  context 'odie!' do                                            # {{{1
    it 'exit + message' do
      ou.capture_stderr do
        expect { ou.odie!('foo!') } .to raise_error(SystemExit)
      end .should == "Error: foo!\n"
    end
    it 'default value' do
      begin ou.capture_stderr { ou.odie!('foo!') }
      rescue SystemExit => e; e; end .status .should == 1
    end
    it 'default value' do
      begin ou.capture_stderr { ou.odie!('foo!', status: 42) }
      rescue SystemExit => e; e; end .status .should == 42
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
