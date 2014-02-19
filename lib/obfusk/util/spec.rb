# --                                                            ; {{{1
#
# File        : obfusk/util/spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-19
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'stringio'

# my namespace
module Obfusk; module Util

  # use StringIO to provide $stdin to block
  def self.provide_stdin(str, isatty = false, &b)               # {{{1
    old = $stdin
    begin
      StringIO.open(str, 'r') do |s|
        def s.isatty; true; end if isatty; $stdin = s; b[]
      end
    ensure
      $stdin = old
    end
  end                                                           # }}}1

  # use StringIO to capture $stdout from block
  def self.capture_stdout(isatty = false, &b)                   # {{{1
    old = $stdout
    begin
      StringIO.open('', 'w') do |s|
        def s.isatty; true; end if isatty; $stdout = s; b[]; s.string
      end
    ensure
      $stdout = old
    end
  end                                                           # }}}1

  # use StringIO to capture $stderr from block
  def self.capture_stderr(isatty = false, &b)                   # {{{1
    old = $stderr
    begin
      StringIO.open('', 'w') do |s|
        def s.isatty; true; end if isatty; $stderr = s; b[]; s.string
      end
    ensure
      $stderr = old
    end
  end                                                           # }}}1

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
