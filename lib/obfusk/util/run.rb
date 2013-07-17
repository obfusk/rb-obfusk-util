# --                                                            ; {{{1
#
# File        : obfusk/util/run.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-17
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

module Obfusk; module Util

  class RunError < RuntimeError; end

  # --

  # better Kernel.exec; should never return (if successful);
  # see spawn, spawn_w, system;
  # @raise RunError on ENOENT
  def self.exec(*args)
    _enoent_to_run('exec', args) do |a|
      Kernel.exec *_spawn_args(*a)
    end
  end

  # better Kernel.spawn; options can be passed as last arg like w/
  # Kernel.spawn, but instead of env as optional first arg, options
  # takes an :env key as well; also, no shell is ever used;
  # returns PID; see exec, spawn_w, system
  # @raise RunError on ENOENT
  def self.spawn(*args)
    _enoent_to_run('spawn', args) do |a|
      Kernel.spawn *_spawn_args(*a)
    end
  end

  # better system: spawn + wait; returns $?; see exec, spawn, system
  def self.spawn_w(*args)
    pid = spawn(*args); ::Process.wait pid; $?
  end

  # better Kernel.system; returns true/false; see exec, spawn, spawn_w
  # @raise RunError on failure (Kernel.system -> nil)
  def self.system(*args)
    r = Kernel.system *_spawn_args(*args)
    raise RunError, "failed to run command #{args} (#$?)" if r.nil?
    r
  end

  # --

  # ohai + spawn; requires obfusk/util/message
  def self.ospawn(*args)
    ::Obfusk::Util.ohai _spawn_rm_opts(args)*' '; spawn *args
  end

  # ohai + spawn_w; requires obfusk/util/message
  def self.ospawn_w(*args)
    ::Obfusk::Util.ohai _spawn_rm_opts(args)*' '; spawn_w *args
  end

  # --

  # @raise RunError if Process::Status's exitcode is non-zero
  def chk_exit(args, status)
    c = status.exitcode
    raise RunError, "command returned non-zero: #{args} -> #{s}" \
      if c != 0
  end

  # --

  # helper
  def self._enoent_to_run(what, args, &b)                       # {{{1
    begin
      b[args]
    rescue Errno::ENOENT => e
      raise RunError,
        "failed to #{what} command #{args}: #{e.message}"
    end
  end                                                           # }}}1

  # helper
  def self._spawn_args(cmd, *args)                              # {{{1
    c = [cmd, cmd]
    if args.last && (l = args.last.dup).is_a?(Hash) \
                 && e = l.delete(:env)
      [e, c] + args[0..-2] + [l]
    else
      [c] + args
    end
  end                                                           # }}}1

  # helper
  def self._spawn_rm_opts(args)
    args.last.is_a?(Hash) ? args[0..-2] : args
  end

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
