# --                                                            ; {{{1
#
# File        : obfusk/util/valid_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'obfusk/util/valid'

va = Obfusk::Util::Valid

describe 'obfusk/util/valid' do

  context 'args' do                                             # {{{1
    it 'max = min' do
      expect { va.args 'foo', %w{ a b c }, 3 } .to_not raise_error
    end
    it 'max + min' do
      expect { va.args 'foo', %w{ a b c }, 1, 4 } .to_not raise_error
      expect { va.args 'foo', %w{ a b c }, 2, 3 } .to_not raise_error
      expect { va.args 'foo', %w{ a b c }, 3, 4 } .to_not raise_error
      expect { va.args 'foo', %w{ a b c }, 3, 3 } .to_not raise_error
    end
    it 'no max' do
      expect { va.args 'foo', %w{ a b }, 1, nil } .to_not raise_error
      expect { va.args 'foo', %w{ a b }, 2, nil } .to_not raise_error
    end
    it 'max = min (invalid)' do
      expect { va.args 'foo', %w{ a b c }, 2 } .to \
        raise_error(va::ArgumentError)
      expect { va.args 'foo', %w{ a b c }, 4 } .to \
        raise_error(va::ArgumentError)
    end
    it 'max + min (invalid)' do
      expect { va.args 'foo', %w{ a b c }, 1, 2 } .to \
        raise_error(va::ArgumentError)
      expect { va.args 'foo', %w{ a b c }, 4, 5 } .to \
        raise_error(va::ArgumentError)
    end
    it 'no max (invalid)' do
      expect { va.args 'foo', %w{ a b }, 3, nil } .to \
        raise_error(va::ArgumentError)
    end
  end                                                           # }}}1

  context 'validate!' do                                        # {{{1
    it 'nil' do
      expect { va.validate! nil, /.*/, '...' } .to_not raise_error
    end
    it 'valid' do
      expect { va.validate! 'foo', /fo+/, '...' } .to_not raise_error
    end
    it 'invalid' do
      expect { va.validate! 'f', /fo+/, 'oops' } .to \
        raise_error(va::ValidationError, 'invalid oops')
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
