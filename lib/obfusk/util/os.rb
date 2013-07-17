# --                                                            ; {{{1
#
# File        : obfusk/util/os.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-17
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'etc'

module Obfusk; module Util; module OS

  # home dir of (current) user
  def self.home(user = nil)
    user ? Etc.getpwnam(user).dir : Dir.home
  end

  # user name
  def self.user
    Etc.getlogin
  end

  # --

  # current time ('%F %T')
  def self.now(fmt = '%F %T')
    Time.now.strftime fmt
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
