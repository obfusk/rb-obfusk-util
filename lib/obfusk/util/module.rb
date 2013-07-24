# --                                                            ; {{{1
#
# File        : obfusk/util/module.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

# my namespace
module Obfusk; module Util

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
