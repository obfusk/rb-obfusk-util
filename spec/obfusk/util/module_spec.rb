# --                                                            ; {{{1
#
# File        : obfusk/util/module_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-19
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'obfusk/util/module'

require 'fileutils'
require 'tmpdir'

module Obfusk::Util::Module__Spec
  module Foo; end; module Bar; end
end

ou = Obfusk::Util
ms = ou::Module__Spec

describe 'obfusk/util/module' do

  context 'link_mod_method' do                                  # {{{1
    it 'link_mod_method' do
      x = Module.new; y = Module.new
      x.module_eval do
        def self.foo; 42; end
        def self.bar; 37; end
      end
      y.module_eval do
        ou.link_mod_method x, :foo, self
        ou.link_mod_method x, :bar, self, :baz
      end
      y.foo.should == 42
      y.baz.should == 37
    end
  end                                                           # }}}1

  context 'require_all' do                                      # {{{1
    it 'require_all' do
      Dir.mktmpdir do |dir|
        d = "#{dir}/obfusk/util/spec__"
        FileUtils.mkdir_p d
        %w{ foo bar }.each do |x|
          File.write "#{d}/#{x}.rb",
            "module #{ms}::#{x.capitalize}; VALUE = '#{x}'; end"
        end
        $:.unshift dir
        begin
          ou.require_all 'obfusk/util/spec__'
          ms::Foo::VALUE.should == 'foo'
          ms::Bar::VALUE.should == 'bar'
        ensure
          $:.shift
        end
      end
    end
  end                                                           # }}}1

  context 'submodules' do                                       # {{{1
    it 'submodules' do
      ou.submodules(ms).should == \
        { 'foo' => ms::Foo, 'bar' => ms::Bar }
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
