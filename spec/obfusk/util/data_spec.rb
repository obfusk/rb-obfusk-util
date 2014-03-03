# --                                                            ; {{{1
#
# File        : obfusk/util/data_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-03-03
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
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

  context 'get_in' do                                           # {{{1
    it 'returns nested key' do
      x = { x: { y: 0 }, z: [1,2,3] }
      expect(ou.get_in(x, :x, :y)).to eq(0)
      expect(ou.get_in(x, :z, 1)).to eq(2)
    end
    it 'returns nil when not found' do
      expect(ou.get_in({}, :x, :y)).to eq(nil)
    end
    it 'returns block result when not found and block given' do
      expect(ou.get_in({}, :x, :y) { 42 }).to eq(42)
    end
  end                                                           # }}}1

  context 'stringify_keys' do                                   # {{{1
    it 'transforms keys to strings' do
      expect(ou.stringify_keys({ x: 1, 2 => 99 })).to \
        eq({ 'x' => 1, '2' => 99 })
    end
  end                                                           # }}}1

  context 'symbolize_keys' do                                   # {{{1
    it 'transforms keys to symbols' do
      expect(ou.symbolize_keys({ 'x' => 1, 'y' => 99 })).to \
        eq({ x: 1, y: 99 })
    end
    it 'ignores errors w/ always = false' do
      expect(ou.symbolize_keys({ 'x' => 1, 2 => 99 }, false)).to \
        eq({ x: 1, 2 => 99 })
    end
  end                                                           # }}}1

  context 'transform_keys' do                                   # {{{1
    it 'transforms keys' do
      h = { 'x' => 1, 2 => 99 }
      expect(ou.transform_keys(h) { |k| k.to_sym rescue k }).to \
        eq({ x: 1, 2 => 99 })
    end
  end                                                           # }}}1

  context 'deep_stringify_keys' do                              # {{{1
    it 'transforms nested keys to strings' do
      expect(ou.deep_stringify_keys({ x: { 2 => 99 } })).to \
        eq({ 'x' => { '2' => 99 } })
    end
  end                                                           # }}}1

  context 'deep_symbolize_keys' do                              # {{{1
    it 'transforms nested keys to symbols' do
      expect(ou.deep_symbolize_keys({ 'x' => { 'y' => 99 } })).to \
        eq({ x: { y: 99 } })
    end
  end                                                           # }}}1

  context 'deep_transform_keys' do                              # {{{1
    it 'transforms nested keys' do
      h = { 'x' => { 'y' => 42 }, 2 => 99 }
      expect(ou.deep_transform_keys(h) { |k| k.to_sym rescue k }).to \
        eq({ x: { y: 42 }, 2 => 99 })
    end
  end                                                           # }}}1

  context 'deep_merge' do                                       # {{{1
    it 'merges hashes recursively' do
      h1  = { x: { y: 42       }, z: 11 }
      h2  = { x: { y: 1 , q: 1 }, z: 1  }
      h3  = { x: { y: 1 , q: 1 }, z: 1  }
      h4  = { x: { y: 42, q: 1 }, z: 11 }
      h5  = { x: { y: 43, q: 1 }, z: 12 }
      f   = -> k,o,n { o + n }
      expect(ou.deep_merge(h1, h2   )).to eq(h3)
      expect(ou.deep_merge(h2, h1   )).to eq(h4)
      expect(ou.deep_merge(h1, h2, &f)).to eq(h5)
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
