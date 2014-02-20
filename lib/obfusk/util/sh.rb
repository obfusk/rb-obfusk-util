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
      ::Obfusk::Util.chk_exitstatus cmd, status.exitstatus
      self
    end

    # ... TODO ...

  end                                                           # }}}1

  # --

  # run a command using bash (w/ arguments)
  #
  # ```
  # sh 'echo "$0" ">>$1<<" ">>$FOO<<"', '"one"', 'FOO' => 'foo'
  # # => bash >>"one"<< >>foo<<
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
    if merge
      stderr = nil; stdout, status = capture2e *c, opts
    else
      stdout, stderr, status = capture3 *c, opts
    end
    Sh.new c, status, stdout, stderr
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

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
