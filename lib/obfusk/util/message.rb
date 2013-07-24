# --                                                            ; {{{1
#
# File        : obfusk/util/message.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'obfusk/util/term'

# my namespace
module Obfusk; module Util

  # info message w/ colours:
  # ```
  # "==> <msg>"
  # ```
  def self.ohai(msg)
    puts _tcol(:lbl) + '==> ' + _tcol(:whi) + msg + _tcol(:non)
  end

  # info message w/ colours:
  # ```
  # "==> <msg>: <a>[, <b>, ...]"
  # ```
  def self.onow(msg, *what)
    puts _tcol(:lgn) + '==> ' + _tcol(:whi) + msg + _tcol(:non) +
      (what.empty? ? '' : _owhat(what))
  end

  # --

  # error message w/ colours:
  # ```
  # "<label>: <msg>"
  # ```
  #
  # `opts[:label]` defaults to 'Error';
  # set `opts[:log]` to a lambda to pass message on to a logger
  def self.onoe(msg, opts = {})
    l = opts[:label] || 'Error'
    $stderr.puts _tcole(:lrd) + l + _tcole(:non) + ': ' + msg
    opts[:log]["#{l}: #{msg}"] if opts[:log]
  end

  # warning message (onoe w/ label 'Warning')
  def self.opoo(msg, opts = {})
    onoe msg, opts.merge(label: 'Warning')
  end

  # --

  # (helper for onow)
  def self._owhat(what)
    ': ' + what.map { |x| _tcol(:lgn) + x + _tcol(:non) } *', '
  end

  # Term.colour
  def self._tcol(*a)
    Term.colour *a
  end

  # Term.colour_e
  def self._tcole(*a)
    Term.colour_e *a
  end

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
