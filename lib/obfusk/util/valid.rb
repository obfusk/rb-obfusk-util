# --                                                            ; {{{1
#
# File        : obfusk/util/valid.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-22
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

module Obfusk; module Util; module Valid

  class ArgumentError < RuntimeError; end
  class ValidationError < RuntimeError; end

  # --

  # validate #args in min..max (min.. if max=nil); returns args
  # @raise ArgumentError on out of bounds
  def self.args(what, args, min, max = min)
    if (l = args.length) < min || (max && l > max)
      raise ArgumentError,
        "#{what} expected #{min}..#{max} arguments, got #{l}"
    end; args
  end

  # @raise ValidationError
  def self.invalid!(msg)
    raise ValidationError, msg
  end

  # validate value against regex
  # @raise ValidationError on no match
  def self.validate!(x, rx, name)
    x.to_s.match /^(#{rx})$/ or invalid! "invalid #{name}"
  end

  # --

  # disable optparse's officious options
  def self.disable_optparse_officious(o, what = nil)
    (what || OptionParser::Officious.keys).each do |x|
      o.on("--#{x}") { raise OptionParser::InvalidOption }
    end
  end

  # clean OptionParser
  def self.optparse_clean(*args, &b)
    OptionParser.new(*args) do |o|
      disable_optparse_officious o; b[o] if b
    end
  end

  # parse options, return remaining args; assumes optparse's .parse!
  def self.parse_opts(op, args)
    as = args.dup; op.parse! as; as
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
