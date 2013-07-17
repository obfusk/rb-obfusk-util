# --                                                            ; {{{1
#
# File        : obfusk/util/data.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-17
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

module Obfusk; module Util

  # assoc key(s) w/ value(s); array keys represent nested keys;
  # e.g. x = {x:{y:0}} => assoc(x, [:x,:y] => 1) <=> x[:x,:y] = 1;
  # will autovivivy missing (if false/nil) nested objects as hashes
  def self.assoc(x, h = {})                                   # {{{1
    h.each do |k,v|
      if k.is_a? Array
        case k.length
        when 0; raise ArgumentError, 'empty array key'
        when 1; x[k.first] = v
        else    h, *t = k; assoc (x[h] ||= {}), t => v
        end
      else
        x[k] = v
      end
    end
    x
  end                                                         # }}}1

  # deep copy using Marshal
  def self.deepdup(obj)
    Marshal.load Marshal.dump obj
  end

  # nil if x is .empty?, x otherwise
  def self.empty_as_nil(x)
    x && x.empty? ? nil : x
  end

  # hash to struct
  def self.h_to_struct(h = {})
    Struct.new(*h.keys).new(*h.values)
  end

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
