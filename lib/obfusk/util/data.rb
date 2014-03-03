# --                                                            ; {{{1
#
# File        : obfusk/util/data.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-03-03
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

# my namespace
module Obfusk; module Util

  # assoc key(s) w/ value(s); array keys represent nested keys;
  # will autovivivy missing (if false/nil) nested objects as hashes
  #
  # ```
  # x = { x: { y: 0 } }; assoc(x, [:x,:y] => 1); x[:x][:y] == 1
  # ```
  def self.assoc(x, h = {})                                   # {{{1
    h.each do |k,v|
      if k.is_a? Array
        case k.length
        when 0; raise ArgumentError, 'empty array key'
        when 1; x[k.first] = v
        else    h, *t = k; assoc(x[h] ||= {}, t => v)
        end
      else
        x[k] = v
      end
    end
    x
  end                                                         # }}}1

  # get the value in a nested associative structure; returns the value
  # (if found), the result of the block (if passed), or nil.
  #
  # ```
  # get_in({ x: { y: 1 } }, :x, :y)
  # # => 1
  # ```
  def self.get_in(x, *ks, &b)                                   # {{{1
    if ks.length == 0
      x
    else
      v = x.fetch(ks.first) { return b && b[] }
      get_in v, *ks.drop(1), &b
    end
  end                                                           # }}}1

  # --

  # convert hash keys to strings
  def self.stringify_keys(h)
    transform_keys(h, &:to_s)
  end

  # convert hash keys to symbols
  # @param always [Boolean] whether to always convert or ignore errors
  def self.symbolize_keys(h, always = true)
    transform_keys(h, &(always ? :to_sym : -> k { k.to_sym rescue k }))
  end

  # convert hash keys using block
  def self.transform_keys(h, &b)
    Hash[h.map { |k,v| [b[k],v] }]
  end

  # --

  # convert nested hash keys to strings
  def self.deep_stringify_keys(h)
    deep_transform_keys(h, &:to_s)
  end

  # convert nested hash keys to symbols
  # @param always [Boolean] whether to always convert or ignore errors
  def self.deep_symbolize_keys(h, always = true)
    deep_transform_keys(h, &(always ? :to_sym : -> k { k.to_sym rescue k }))
  end

  # convert nested hash keys using block
  def self.deep_transform_keys(h, &b)
    Hash[h.map { |k,v| [b[k], v.is_a?(Hash) ? deep_transform_keys(v,&b) : v] }]
  end

  # --

  # merge hashes recursively
  def self.deep_merge(h1, h2, &b)                               # {{{1
    h1.merge(Hash[h2.map do |k,v2|
      if h1.has_key?(k)
        if (v1 = h1[k]).is_a?(Hash) && v2.is_a?(Hash)
          [k, deep_merge(v1, v2, &b)]
        else
          [k, b ? b[k,h1[k],v2] : v2]
        end
      else
        [k, v2]
      end
    end])
  end                                                           # }}}1

  # --

  # deep copy using Marshal
  def self.deepdup(obj)
    Marshal.load Marshal.dump obj
  end

  # nil if x is `.empty?`, x otherwise
  def self.empty_as_nil(x)
    x && x.empty? ? nil : x
  end

  # hash to struct
  def self.h_to_struct(h = {})
    Struct.new(*h.keys).new(*h.values)
  end

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
