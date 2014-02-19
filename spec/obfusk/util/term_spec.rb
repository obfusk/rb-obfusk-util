# --                                                            ; {{{1
#
# File        : obfusk/util/term_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-19
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'obfusk/util/term'

ou = Obfusk::Util
te = Obfusk::Util::Term

describe 'obfusk/util/term' do

  context 'colour' do                                           # {{{1
    it 'no tty' do
      ou.capture_stdout { te.colour(:red) } .should == ''
    end
    it 'no such colour' do
      expect { te.colour(:octarine) } .to \
        raise_error(ArgumentError, /No such colour/)
    end
    it 'red, blue, green' do
      ou.capture_stdout(:tty) do
        te.colour(:red)   .should == "\e[0;31m"
        te.colour(:blue)  .should == "\e[0;34m"
        te.colour(:green) .should == "\e[0;32m"
      end
    end
    it 'red, blue, green (stderr)' do
      ou.capture_stderr(:tty) do
        te.colour_e(:red)   .should == "\e[0;31m"
        te.colour_e(:blue)  .should == "\e[0;34m"
        te.colour_e(:green) .should == "\e[0;32m"
      end
    end
  end                                                           # }}}1

  context 'columns' do                                          # {{{1
    it 'columns' do
      old = ENV['COLUMNS']; ENV['COLUMNS'] = '17'
      begin te.columns.should == 17
      ensure ENV['COLUMNS'] = old end
    end
  end                                                           # }}}1

  context 'lines' do                                            # {{{1
    it 'lines' do
      old = ENV['LINES']; ENV['LINES'] = '71'
      begin te.lines.should == 71
      ensure ENV['LINES'] = old end
    end
  end                                                           # }}}1

  context 'tty?' do                                             # {{{1
    it 'stdout tty' do
      ou.capture_stdout(:tty) { te.tty?.should be_true }
    end
    it 'stderr tty' do
      ou.capture_stderr(:tty) { te.tty?(:err).should be_true }
    end
    it 'stdout no tty' do
      ou.capture_stdout { te.tty?.should be_false }
    end
    it 'stderr no tty' do
      ou.capture_stderr { te.tty?(:err).should be_false }
    end
  end                                                           # }}}1

  context 'prompt' do                                           # {{{1
    it 'normal' do
      ou.provide_stdin("foo!\n") do
        ou.capture_stdout do
          name = te.prompt 'name? '
          name.should == 'foo!'
        end .should == 'name? '
      end
    end
    it 'no newline' do
      ou.provide_stdin('foo!') do
        ou.capture_stdout do
          name = te.prompt 'name? '
          name.should == 'foo!'
        end .should == 'name? '
      end
    end
    it 'hide' do
      ou.provide_stdin('foo!') do
        def $stdin.noecho(&b) b[self] end    # mock!
        ou.capture_stdout do
          name = te.prompt 'name? ', :hide
          name.should == 'foo!'
        end .should == "name? \n"
      end
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
