# --                                                            ; {{{1
#
# File        : obfusk/util/struct_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require 'obfusk/util/struct'

ou = Obfusk::Util

struct = ->() {
  ou.struct(*%w{ f1 f2 f3 }) do
    def some_method; f1 + f2; end
  end
}

describe 'obfusk/util/struct' do

  context 'struct' do                                           # {{{1
    it 'new' do
      s = struct[]; foo = s.new f1: 37, f2: 5
      foo.some_method.should == 42
      foo.f1.should == 37
      foo.f2.should == 5
      foo.f3.should == nil
    end
    it 'build' do
      s = struct[]; bar = s.build(f1: 99) { |x| x.f2 = 1 }
      bar.some_method.should == 100
      bar.f1.should == 99
      bar.f2.should == 1
      bar.f3.should == nil
    end
    it 'no other fields to get' do
      s = struct[]; bar = s.new
      expect { bar.oops } .to \
        raise_error(NoMethodError, /undefined method.*`oops'/)
    end
    it 'no other fields to set' do
      s = struct[]; bar = s.new
      expect { bar.oops = 99 } .to \
        raise_error(NoMethodError, /undefined method.*`oops='/)
    end
    it 'frozen' do
      s = struct[]; bar = s.build { |x| x.f2 = 1 }
      expect { bar.f1 = 99 } .to \
        raise_error(RuntimeError, /can't modify frozen/)
    end
    it 'check!' do
      s = struct[]; bar = s.build { |x| x.f2 = 1 }
      expect { bar.check! } .to \
        raise_error(ou::BetterStruct::IncompleteError, /empty field/)
    end
    it 'to_h' do
      s = struct[]; bar = s.new(f1: 'hi!')
      bar.to_h.should == { f1: 'hi!', f2: nil, f3: nil }
    end
    it 'to_str_h' do
      s = struct[]; bar = s.new(f1: 'hi!')
      bar.to_str_h.should == { 'f1'=>'hi!', 'f2'=>nil, 'f3'=>nil }
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
