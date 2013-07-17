# --                                                            ; {{{1
#
# File        : obfusk/util/die.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-17
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

module Obfusk; module Util

  # print msgs to stderr and exit 1;
  # pass { exit: code } as last argument to use other exit code
  def self.die!(*msgs)
    code = _die_msgs msgs; exit code
  end

  # print msgs to stderr, show usage, exit
  def self.udie!(usage, *msgs)
    code = _die_msgs msgs; STDERR.puts "Usage: #{usage}"; exit code
  end

  # --

  # onoe, exit; requires obfusk/util/message
  def self.odie!(msg, opts = {})
    o = opts.dup; c = o.delete(:code) || 1
    ::Obfusk::Util.onoe msg, o; exit c
  end

  # --

  # helper; modifies msgs -> OK b/c comes from *msgs
  def self._die_msgs(msgs)
    code = (msgs.last.is_a?(Hash) && msgs.pop[:exit]) || 1
    msgs.each { |m| STDERR.puts "Error: #{m}" }
    code
  end

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
