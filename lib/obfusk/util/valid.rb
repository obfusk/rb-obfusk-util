# --                                                            ; {{{1
#
# File        : obfusk/util/valid.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-17
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

module Obfusk; module Util; module Valid

  class ValidationError < RuntimeError; end

  # --

  # validate #args in min..max (min.. if max=nil); returns args
  # @raise ArgError on out of bounds
  def self.args(what, args, min, max = min)
    if args.length < min || (max && args.length > max)
      raise ArgError, "#{what} expected #{min}..#{max} arguments" +
                      ", got #{args.length}"
    end; args
  end

  # @raise ValidationError
  def self.invalid!(msg)
    raise ValidationError, msg
  end

  # parse options, return remaining args; assumes optparse's .parse!
  def self.parse_opts(op, args)
    as = args.dup; op.parse! as; as
  end

  # validate value against regex
  # @raise ValidationError on no match
  def self.validate!(x, rx, name)
    x.to_s.match /^(#{rx})$/ or invalid! "invalid #{name}"
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
