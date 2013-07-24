# --                                                            ; {{{1
#
# File        : obfusk/util/cmd.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

# my namespace
module Obfusk; module Util; module Cmd

  SIG_RX  = /^(SIG[A-Z0-9]+)\s+(.*)$/
  SH_RX   = /^SHELL(=(\S+))?\s+(.*)$/
  VAR_RX  = / \$ \{ ([A-Z_]+) \} /x

  # --

  # parses optional `SIG*` prefix in command string;
  # (e.g. `'SIGINT foo bar ...'`);
  # if there is no prefix, signal is default
  # @return [Hash] `{ command: command, signal: signal }`
  def self.killsig(cmd, default = 'SIGTERM')                    # {{{1
    if m = cmd.match(SIG_RX)
      { command: m[2], signal: m[1] }
    else
      { command: cmd, signal: default }
    end
  end                                                           # }}}1

  # parses optional `SHELL[=...]` prefix in command string
  # (e.g. `'SHELL=bash foo bar ...'`, `'SHELL foo bar ...'`);
  # if there is no prefix, shell is nil;
  # if there is no `=...`, shell is default
  # @return [Hash] `{ command: command, shell: shell }`
  def self.shell(cmd, default = 'bash')                         # {{{1
    if m = cmd.match(SH_RX)
      { command: m[3], shell: (m[2] || default) }
    else
      { command: cmd, shell: nil }
    end
  end                                                           # }}}1

  # --

  # prepend nohup to args
  def self.nohup(*args)
    ['nohup'] + args
  end

  # replaces `${VAR}s` in command string using vars hash
  def self.set_vars(cmd, vars)
    cmd.gsub(VAR_RX) { |m| vars[$1] }
  end

  # --

  # env hash as array (w/o nil values)
  # @return [<String>] `['k1="v1"', ...]`
  def self.env_to_a(h)
    h.reject { |k,v| v.nil? } .map { |k,v| "#{k}=#{v.inspect}" }
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
