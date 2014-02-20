# --                                                            ; {{{1
#
# File        : obfusk/util/sh.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-20
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'obfusk/util/run'

# my namespace
module Obfusk; module Util

  # shell command result
  class Sh < Struct.new(:cmd, :status, :stdout, :stderr)        # {{{1

    # was the exitstatus zero?
    def ok?
      status.exitstatus == 0
    end

    # @raise RunError when exitstatus non-zero
    # @return [Sh] self
    def ok!
      ::Obfusk::Util.chk_exitstatus cmd, status.exitstatus; self
    end

    # ... TODO ...

  end                                                           # }}}1

  # --

  # run a command using bash (w/ arguments) and capture its output;
  # see also `sys`; uses `capture{2e,3}`
  #
  # ```
  # sh('echo "$0" ">>$1<<" ">>$FOO<<"', '"one"', 'FOO' => 'foo').stdout
  # # => %Q{bash >>"one"<< >>foo<<}
  # ```
  #
  # @param [Hash] args.last
  #   * `:shell`  the shell to use                    (default: `'bash'`)
  #   * `:print`  whether to pass `-x` to the shell   (default: `false`)
  #   * `:exit`   whether to pass `-e` to the shell   (default: `false`)
  #   * `:merge`  whether to merge stdout and stderr  (default: `false`)
  #   * `:env`    the environment
  #   * any other `String` key is added to the `env`
  #   * any other `Symbol` key is passed as an option to `capture3`
  # @return [Sh]
  def self.sh(cmd, *args)                                       # {{{1
    c = _sh cmd, args
    if c[:merge]
      stderr = nil; stdout, status = capture2e(*c[:cmd], c[:opts])
    else
      stdout, stderr, status = capture3(*c[:cmd], c[:opts])
    end
    Sh.new c[:cmd], status, stdout, stderr
  end                                                           # }}}1

  # `sh(...).ok?`
  def self.sh?(cmd, *args)
    sh(cmd, *args).ok?
  end

  # `sh(...).ok!`
  def self.sh!(cmd, *args)
    sh(cmd, *args).ok!
  end

  # --

  # run a command using bash (w/ arguments); takes the same arguments
  # as `sh`; uses `spawn_w`
  #
  # ```
  # sys 'echo "$0" ">>$1<<" ">>$FOO<<"', '"one"', 'FOO' => 'foo'
  # # stdout: bash >>"one"<< >>foo<<
  # ```
  #
  # @return [Process::Status]
  def self.sys(cmd, *args)
    c   = _sh cmd, args; o = c[:opts]
    o_  = c[:merge] ? o.merge(:err => o[:out] ? [:child, :out] : :out) : o
    spawn_w(*c[:cmd], o_)
  end

  # `sys(...).exitstatus == 0`
  def self.sys?(cmd, *args)
    sys(cmd, *args).exitstatus == 0
  end

  # `sys(...)`
  # @raise RunError when exitstatus non-zero
  def self.sys!(cmd, *args)
    sys(cmd, *args).tap { |s| chk_exitstatus cmd, s.exitstatus }
  end

  # --

  # ohai + sh; requires `obfusk/util/message`
  def self.osh(*args)
    ::Obfusk::Util.ohai _spawn_rm_opts(args)*' '; sh(*args)
  end

  # ohai + sh?; requires `obfusk/util/message`
  def self.osh?(*args)
    ::Obfusk::Util.ohai _spawn_rm_opts(args)*' '; sh?(*args)
  end

  # ohai + sh!; requires `obfusk/util/message`
  def self.osh!(*args)
    ::Obfusk::Util.ohai _spawn_rm_opts(args)*' '; sh!(*args)
  end

  # --

  # ohai + sys; requires `obfusk/util/message`
  def self.osys(*args)
    ::Obfusk::Util.ohai _spawn_rm_opts(args)*' '; sys(*args)
  end

  # ohai + sys?; requires `obfusk/util/message`
  def self.osys?(*args)
    ::Obfusk::Util.ohai _spawn_rm_opts(args)*' '; sys?(*args)
  end

  # ohai + sys!; requires `obfusk/util/message`
  def self.osys!(*args)
    ::Obfusk::Util.ohai _spawn_rm_opts(args)*' '; sys!(*args)
  end

  # --

  # helper
  def self._sh(cmd, args)                                       # {{{1
    a, o  = args.last && (l = args.last.dup).is_a?(Hash) ?
              [args[0..-2],l] : [args,{}]
    shell = o.delete(:shell) || 'bash'
    print = o.delete :print
    exit  = o.delete :exit
    merge = o.delete :merge
    env   = o.delete(:env) || {}
    syms  = o.select { |k,v| Symbol === k }
    strs  = o.select { |k,v| String === k }
    opts  = syms.merge env: env.merge(strs)
    c     = [shell] + (print ? %w{-x} : []) + (exit ? %w{-e} : []) +
              ['-c', cmd, shell] + a
    { cmd: c, opts: opts, merge: merge }
  end                                                           # }}}1

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
