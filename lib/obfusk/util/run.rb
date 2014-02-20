# --                                                            ; {{{1
#
# File        : obfusk/util/run.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-19
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'open3'

# my namespace
module Obfusk; module Util

  class RunError < RuntimeError; end

  # --

  # better Kernel.exec; should never return (if successful);
  # see spawn, spawn_w, system
  # @raise RunError on ENOENT
  def self.exec(*args)
    _enoent_to_run('exec', args) do |a|
      Kernel.exec(*_spawn_args(*a))
    end
  end

  # better Kernel.spawn; options can be passed as last arg like w/
  # Kernel.spawn, but instead of env as optional first arg, options
  # takes an :env key as well; also, no shell is ever used;
  # returns PID; see exec, spawn_w, system
  # @raise RunError on ENOENT
  def self.spawn(*args)
    _enoent_to_run('spawn', args) do |a|
      Kernel.spawn(*_spawn_args(*a))
    end
  end

  # better system: spawn + wait; returns $?; see exec, spawn, system
  def self.spawn_w(*args)
    pid = spawn(*args); ::Process.wait pid; $?
  end

  # better Kernel.system; returns true/false; see exec, spawn, spawn_w
  # @raise RunError on failure (Kernel.system -> nil)
  def self.system(*args)
    r = Kernel.system(*_spawn_args(*args))
    raise RunError, "failed to run command #{args} (#$?)" if r.nil?
    r
  end

  # --

  # better Open3.capture2; see capture3
  # @raise RunError on ENOENT
  def self.capture2(*args)
    _enoent_to_run('capture2', args) do |a|
      Open3.capture2(*_spawn_args(*a))
    end
  end

  # better Open3.capture2e; see capture3
  # @raise RunError on ENOENT
  def self.capture2e(*args)
    _enoent_to_run('capture2e', args) do |a|
      Open3.capture2e(*_spawn_args(*a))
    end
  end

  # better Open3.capture3; see popen3
  # @raise RunError on ENOENT
  def self.capture3(*args)
    _enoent_to_run('capture3', args) do |a|
      Open3.capture3(*_spawn_args(*a))
    end
  end

  # --

  # better Open3.pipeline; see exec, popen3
  # @raise RunError on ENOENT
  def self.pipeline(*args)
    _enoent_to_run('pipeline', args) do |a|
      Open3.pipeline(*_pipeline_args(*a))
    end
  end

  # better Open3.pipeline_r; see pipeline_rw
  # @raise RunError on ENOENT
  def self.pipeline_r(*args, &b)
    _enoent_to_run('pipeline_r', args) do |a|
      Open3.pipeline_r(*_pipeline_args(*a), &b)
    end
  end

  # better Open3.pipeline_rw; see popen3
  # @raise RunError on ENOENT
  def self.pipeline_rw(*args, &b)
    _enoent_to_run('pipeline_rw', args) do |a|
      Open3.pipeline_rw(*_pipeline_args(*a), &b)
    end
  end

  # better Open3.pipeline_start; see popen3
  # @raise RunError on ENOENT
  def self.pipeline_start(*args, &b)
    _enoent_to_run('pipeline_start', args) do |a|
      Open3.pipeline_start(*_pipeline_args(*a), &b)
    end
  end

  # better Open3.pipeline_w; see pipeline_rw
  # @raise RunError on ENOENT
  def self.pipeline_w(*args, &b)
    _enoent_to_run('pipeline_w', args) do |a|
      Open3.pipeline_w(*_pipeline_args(*a), &b)
    end
  end

  # --

  # better Open3.popen2; see popen3
  # @raise RunError on ENOENT
  def self.popen2(*args, &b)
    _enoent_to_run('popen2', args) do |a|
      Open3.popen2(*_spawn_args(*a), &b)
    end
  end

  # better Open3.popen2e; see popen3
  # @raise RunError on ENOENT
  def self.popen2e(*args, &b)
    _enoent_to_run('popen2e', args) do |a|
      Open3.popen2e(*_spawn_args(*a), &b)
    end
  end

  # better Open3.popen3; see exec, spawn, spawn_w, system
  # @raise RunError on ENOENT
  def self.popen3(*args, &b)
    _enoent_to_run('popen3', args) do |a|
      Open3.popen3(*_spawn_args(*a), &b)
    end
  end

  # --

  # ohai + spawn; requires `obfusk/util/message`
  def self.ospawn(*args)
    ::Obfusk::Util.ohai _spawn_rm_opts(args)*' '; spawn(*args)
  end

  # ohai + spawn_w; requires `obfusk/util/message`
  def self.ospawn_w(*args)
    ::Obfusk::Util.ohai _spawn_rm_opts(args)*' '; spawn_w(*args)
  end

  # --

  # run block w/ args, check `.exitstatus`
  # @raise RunError if Process::Status's exitstatus is non-zero
  def self.chk_exit(args, &b)
    chk_exitstatus args, b[args].exitstatus
  end

  # @raise RunError if c != 0
  def self.chk_exitstatus(args, c)
    exit_non_zero! args, c if c != 0
  end

  # @raise RunError command returned non-zero
  def self.exit_non_zero!(args, c)
    raise RunError, "command returned non-zero: #{args} -> #{c}"
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
  def self._pipeline_args(*args)                                # {{{1
    if args.last && (l = args.last.dup).is_a?(Hash)
      args[0..-2].map { |c| _spawn_args(*c) } + [l]
    else
      args.map { |c| _spawn_args(*c) }
    end
  end                                                           # }}}1

  # helper
  def self._spawn_rm_opts(args)
    args.last.is_a?(Hash) ? args[0..-2] : args
  end

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
