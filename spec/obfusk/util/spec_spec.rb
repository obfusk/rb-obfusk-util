# --                                                            ; {{{1
#
# File        : obfusk/util/spec_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'obfusk/util/spec'

ou = Obfusk::Util

describe 'obfusk/util/spec' do

  context 'provide_stdin' do                                    # {{{1
    it 'stdin + reset' do
      old = $stdin
      ou.provide_stdin("foo\nbar\nbaz\n") do
        $stdin.readlines.map(&:chomp)
      end .should == %w{ foo bar baz }
      $stdin.should == old
    end
    it 'reset on error' do
      err = Class.new RuntimeError; old = $stdin
      begin ou.provide_stdin('') { raise err, 'OOPS' }
      rescue err; end
      $stdin.should == old
    end
  end                                                           # }}}1

  context 'capture_stdout' do                                   # {{{1
    it 'stdout + reset' do
      old = $stdout
      ou.capture_stdout { puts %w{ foo bar baz } } \
        .should == "foo\nbar\nbaz\n"
      $stdout.should == old
    end
    it 'reset on error' do
      err = Class.new RuntimeError; old = $stdout
      begin ou.capture_stdout { raise err, 'OOPS' }
      rescue err; end
      $stdout.should == old
    end
  end                                                           # }}}1

  context 'capture_stderr' do                                   # {{{1
    it 'stderr + reset' do
      old = $stderr
      ou.capture_stderr { $stderr.puts %w{ foo bar baz } } \
        .should == "foo\nbar\nbaz\n"
      $stderr.should == old
    end
    it 'reset on error' do
      err = Class.new RuntimeError; old = $stderr
      begin ou.capture_stderr { raise err, 'OOPS' }
      rescue err; end
      $stderr.should == old
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
