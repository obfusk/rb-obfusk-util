# --                                                            ; {{{1
#
# File        : obfusk/util/spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'stringio'

# my namespace
module Obfusk; module Util

  # use StringIO to provide $stdin to block
  def self.provide_stdin(str, &b)                               # {{{1
    old = $stdin
    begin
      StringIO.open(str, 'r') { |s| $stdin = s; b[] }
    ensure
      $stdin = old
    end
  end                                                           # }}}1

  # use StringIO to capture $stdout from block
  def self.capture_stdout(&b)                                   # {{{1
    old = $stdout
    begin
      StringIO.open('', 'w') { |s| $stdout = s; b[]; s.string }
    ensure
      $stdout = old
    end
  end                                                           # }}}1

  # use StringIO to capture $stderr from block
  def self.capture_stderr(&b)                                   # {{{1
    old = $stderr
    begin
      StringIO.open('', 'w') { |s| $stderr = s; b[]; s.string }
    ensure
      $stderr = old
    end
  end                                                           # }}}1

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
