# --                                                            ; {{{1
#
# File        : obfusk/util/opt.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-19
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'optparse'

# my namespace
module Obfusk; module Util; module Opt

  # better OptionParser
  class Parser < OptionParser
    # do nothing!
    def add_officious; end

    # parse options, return remaining args
    def parse_r(args)
      as = args.dup; parse! as; as
    end
  end

  # --

  # parse options, return remaining args
  def self.parse(op, args)
    as = args.dup; op.parse! as; as
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
