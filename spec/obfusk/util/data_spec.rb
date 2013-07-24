# --                                                            ; {{{1
#
# File        : obfusk/util/data_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'obfusk/util/data'

module Obfusk::Util::Data__Spec
  S = Struct.new :x, :y
end

ou = Obfusk::Util
ds = ou::Data__Spec

describe 'obfusk/util/data' do

  context 'assoc' do                                            # {{{1
    it 'assoc' do
      x = { x: { y: 0 }, z: [1,2,3] }
      ou.assoc(x, [:x,:y] => 1, [:z,1] => 99)
      x[:x][:y].should == 1
      x[:z].should == [1,99,3]
    end
  end                                                           # }}}1

  context 'deepdup' do                                          # {{{1
    it 'equal' do
      x = { x: { y: 0 }, z: [1,2,3], s: ds::S.new(1,2) }
      y = Obfusk::Util.deepdup x
      x.should == y
    end
    it 'different objects' do
      x = { x: { y: 0 }, z: [1,2,3], s: ds::S.new(1,2) }
      y = Obfusk::Util.deepdup x
      y[:x][:y] = 1 ; x[:x][:y].should == 0
      y[:z][1]  = 99; x[:z][1].should == 2
      y[:s].y   = 37; x[:s].y.should == 2
    end
  end                                                           # }}}1

  context 'empty_as_nil' do                                     # {{{1
    it 'nil' do
      ou.empty_as_nil(nil).should == nil
    end
    it 'empty string' do
      ou.empty_as_nil('').should == nil
    end
    it 'empty array' do
      ou.empty_as_nil([]).should == nil
    end
    it 'not empty or nil' do
      ou.empty_as_nil('foo').should == 'foo'
    end
    it 'real world example' do
      env = { 'PORT' => '' }
      (ou.empty_as_nil(env['PORT']) || 1234).should == 1234
    end
  end                                                           # }}}1

  context 'h_to_struct' do                                      # {{{1
    it 'h_to_struct' do
      s = ou.h_to_struct({x:1,y:2})
      s.members.sort.should == [:x,:y].sort
      s.x.should == 1
      s.y.should == 2
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
