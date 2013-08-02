# --                                                            ; {{{1
#
# File        : obfusk/util/module.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-25
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

# my namespace
module Obfusk; module Util

  # create module method to.to_meth that calls from.from_meth
  def self.link_mod_method(from, from_meth, to, to_meth = from_meth)
    to.module_exec(from, from_meth, to_meth) do |f,fm,tm|
      (class << self; self; end).send(:define_method, tm) \
        { |*a,&b| f.send(fm, *a, &b) }
    end
  end

  # load `dir/*` (by searching for `dir/*.rb` in `$LOAD_PATH`)
  #
  # ```
  # require_all('napp/types') ~> require 'napp/types/*'
  # ```
  #
  # @return [Hash] `{ module => result-of-require }`
  def self.require_all(dir)
    Hash[ $LOAD_PATH.map { |x| Dir["#{x}/#{dir}/*.rb"] } .flatten \
            .map { |x| "#{dir}/" + File.basename(x, '.rb') } .uniq \
            .map { |x| y = require x; [x,y] } ]
  end

  # get submodules as hash
  #
  # ```
  # submodules(Foo) -> { 'bar' => Foo::Bar, ... }
  # ```
  def self.submodules(mod)
    Hash[ mod.constants \
          .map { |x| [x.downcase.to_s, mod.const_get(x)] } \
          .select { |k,v| v.class == Module } ]
  end

end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
