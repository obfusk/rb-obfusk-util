# --                                                            ; {{{1
#
# File        : obfusk/util/cmd.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-17
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

module Obfusk; module Util; module Cmd

  SIG_RX = /^(SIG[A-Z0-9]+)\s+/
  VAR_RX = / \$ \{ ([A-Z_]+) \} /x

  # --

  # parses optional SIG* prefix in command string
  # (e.g. 'SIGINT foo bar ...');
  # returns { command: command, signal: signal };
  # if there is no prefix, signal is SIGTERM
  def self.killsig(cmd)                                         # {{{1
    if m = cmd.match(SIG_RX)
      { command: cmd.sub(r, ''), signal: m[1] }
    else
      { command: cmd, signal: 'SIGTERM' }
    end
  end                                                           # }}}1

  # prepend nohup to args
  def self.nohup(*args)
    ['nohup'] + args
  end

  # replaces ${VAR}s in command string using vars hash
  def self.set_vars(cmd, vars)
    cmd.gsub(VAR_RX) { |m| vars[$1] }
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
