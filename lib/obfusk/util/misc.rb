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

module Obfusk; module Util

  # nil if x is .empty?, x otherwise
  def self.empty_as_nil(x)
    x && x.empty? ? nil : x
  end

  # ...

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
