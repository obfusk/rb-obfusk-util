# --                                                            ; {{{1
#
# File        : obfusk/util/misc.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-17
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'fileutils'

module Obfusk; module Util

  # current time ('%F %T')
  def self.now(fmt = '%F %T')
    Time.now.strftime fmt
  end

  # ohai + mkdir_p; requires obfusk/util/message
  def self.omkdir_p(*paths)
    ::Obfusk::Util.ohai "mkdir -p #{paths*' '}"
    FileUtils.mkdir_p paths
  end

  # ...

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
