# --                                                            ; {{{1
#
# File        : obfusk/util/struct.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-19
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

# my namespace
module Obfusk; module Util

  # better Struct; create using Obfusk::Util.struct
  module BetterStruct                                           # {{{1

    class IncompleteError < RuntimeError; end

    # --

    # include class methods as well
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods                                         # {{{2

      # new, block, freeze, return
      def build(h = {}, &b)
        x = new h; b[x] if b; x.freeze
      end

    end                                                         # }}}2

    # checks for missing fields, returns self
    # @raise IncompleteError if any fields are nil
    def check!
      members.each do |f|
        self[f].nil? and raise IncompleteError, "empty field: #{f}"
      end; self
    end

    # def with(h = {}, &b)
    #   x = dup
    #   h.each {
    # end

    unless Struct.method_defined? :to_h
      # convert to hash (ruby 2 has this already)
      def to_h
        Hash[each_pair.to_a]
      end
    end

    # convert to hash w/ string keys
    def to_str_h
      Hash[to_h.map { |k,v| [k.to_s,v] }]
    end

  end                                                           # }}}1

  # --

  # better struct; see examples in README.md
  def self.struct(*fields, &b)                                  # {{{1
    Class.new(Struct.new(*fields.map(&:to_sym))) do

      include BetterStruct

      # init w/ hash
      def initialize(h = {})
        h.each { |k,v| self[k] = v }
      end

      self.class_eval(&b) if b

    end
  end                                                           # }}}1

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
