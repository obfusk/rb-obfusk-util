# --                                                            ; {{{1
#
# File        : obfusk/util/term.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-17
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

module Obfusk; module Util

  # some ansi escape colours                                      TODO
  TERM_COLOURS = {                                              # {{{1
    non:  "\e[0m",
    red:  "\e[1;31m",
    grn:  "\e[1;32m",
    blu:  "\e[1;34m",
    whi:  "\e[1;37m",
  }                                                             # }}}1

  # --

  # colour code (or '' if not tty)
  def self.term_colour(x, what = :out)
    term_tty?(what) ? TERM_COLOURS.fetch(x) : ''
  end

  # colour code for STDERR
  def self.term_colour_e(x)
    term_col x, :err
  end

  # --

  # terminal columns
  def self.term_columns
    %x[ TERM=${TERM:-dumb} tput cols ].to_i
  end

  # is STDOUT (or STDERR) a tty?
  def self.term_tty?(what = :out)
    (what == :out ? STDOUT : STDERR).isatty
  end

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
