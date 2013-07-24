# --                                                            ; {{{1
#
# File        : obfusk/util/term.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'io/console'

# my namespace
module Obfusk; module Util; module Term

  # ansi colour codes
  TERM_COLOUR_CODES = {                                         # {{{1
    black:      '0;30', dark_gray:    '1;30',
    blue:       '0;34', light_blue:   '1;34',
    green:      '0;32', light_green:  '1;32',
    cyan:       '0;36', light_cyan:   '1;36',
    red:        '0;31', light_red:    '1;31',
    purple:     '0;35', light_purple: '1;35',
    brown:      '0;33', yellow:       '1;33',
    light_gray: '0;37', white:        '1;37',
    none:       '0'
  }                                                             # }}}1

  # some colour aliases
  TERM_COLOUR_ALIASES = {                                       # {{{1
    bla: :black,      dgr: :dark_gray,
    blu: :blue,       lbl: :light_blue,
    grn: :green,      lgn: :light_green,
    cyn: :cyan,       lcy: :light_cyan,   lrd: :light_red,
    pur: :purple,     lpu: :light_purple,
    bro: :brown,      yel: :yellow,
    lgr: :light_gray, whi: :white,        non: :none,
  }                                                             # }}}1

  # ansi colour escapes
  TERM_COLOUR_ESCAPES = (->(;a,b) {
    a = Hash[TERM_COLOUR_CODES.map   { |k,v| [k,"\e[#{v}m"] }]
    b = Hash[TERM_COLOUR_ALIASES.map { |k,v| [k,    a[v]  ] }]
    a.merge b
  })[]

  GET_COLS  = 'TERM=${TERM:-dumb} tput cols'
  GET_LINES = 'TERM=${TERM:-dumb} tput lines'

  # --

  # colour code (or '' if not tty)
  def self.colour(x, what = :out)
    tty?(what) ? TERM_COLOUR_ESCAPES.fetch(x) : ''
  end

  # colour code for $stderr
  def self.colour_e(x)
    colour x, :err
  end

  # --

  # terminal columns
  def self.columns
    %x[#{GET_COLS}].to_i
  end

  # terminal lines
  def self.lines
    %x[#{GET_LINES}].to_i
  end

  # is $stdout (or $stderr) a tty?
  def self.tty?(what = :out)
    (what == :out ? $stdout : $stderr).isatty
  end

  # --

  # prompt for line; optionally hide input
  def self.prompt(prompt, hide = false)
    print prompt; $stdout.flush
    line = hide ? $stdin.noecho { |i| i.gets } .tap { puts } :
                  $stdin.gets
    line && line.chomp
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
