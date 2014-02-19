# --                                                            ; {{{1
#
# File        : obfusk/util/os_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-19
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'obfusk/util/os'

os = Obfusk::Util::OS

describe 'obfusk/util/os' do

  context 'home' do                                             # {{{1
    it 'my home' do
      os.home.should == ENV['HOME']                             # ????
    end
    it 'root' do
      os.home('root').should == '/root'                         # ????
    end
  end                                                           # }}}1

  context 'user' do                                             # {{{1
    it 'user' do
      os.user.should == ENV['USER']                             # ????
    end
  end                                                           # }}}1

  context 'now' do                                              # {{{1
    it 'now' do
      os.now.should match(/^\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d$/)
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
