# --                                                            ; {{{1
#
# File        : obfusk/util/process.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

# my namespace
module Obfusk; module Util; module Process

  GET_AGE = ->(pid) { "ps -p #{pid} -o etime=" }

  # --

  # get process age information from ps
  def self.age(pid)
    ispid! pid; %x[#{GET_AGE[pid]}].gsub(/\s/, '')
  end

  # process alive?
  # @return [Boolean] false if not alive
  # @return [Boolean] true if alive and mine
  # @return [Symbol]  :not_mine if alive and not mine
  def self.alive?(pid)
    ::Process.kill 0, pid; true
  rescue Errno::EPERM; :not_mine
  rescue Errno::ESRCH; false
  end

  # @raise ArgumentError if pid is not an integer
  def self.ispid!(pid)
    pid.is_a? Integer or raise ArgumentError, 'invalid PID'
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
