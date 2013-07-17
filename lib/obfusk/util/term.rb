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

require 'io/console'

module Obfusk; module Util; module Term

  # some ansi escape colours                                      TODO
  TERM_COLOURS = {                                              # {{{1
    non:  "\e[0m",
    red:  "\e[1;31m",
    grn:  "\e[1;32m",
    blu:  "\e[1;34m",
    whi:  "\e[1;37m",
  }                                                             # }}}1

  GET_COLS = 'TERM=${TERM:-dumb} tput cols'

  # --

  # colour code (or '' if not tty)
  def self.colour(x, what = :out)
    tty?(what) ? TERM_COLOURS.fetch(x) : ''
  end

  # colour code for STDERR
  def self.colour_e(x)
    colour x, :err
  end

  # --

  # terminal columns
  def self.columns
    %x[#{GET_COLS}].to_i
  end

  # is STDOUT (or STDERR) a tty?
  def self.tty?(what = :out)
    (what == :out ? STDOUT : STDERR).isatty
  end

  # --

  # prompt for line; optionally hide input
  def self.prompt(prompt, hide = false)
    print prompt; STDOUT.flush
    line = hide ? STDIN.noecho { |i| i.gets } .tap { puts } :
                  STDIN.gets
    line && line.chomp
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
