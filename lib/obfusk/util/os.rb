# --                                                            ; {{{1
#
# File        : obfusk/util/os.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-19
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'etc'

# my namespace
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
