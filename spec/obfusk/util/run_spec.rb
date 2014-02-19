# --                                                            ; {{{1
#
# File        : obfusk/util/run_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-19
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'obfusk/util/message'
require 'obfusk/util/run'

ou = Obfusk::Util

describe 'obfusk/util/run' do

  context 'exec' do                                             # {{{1
    it 'succeed' do
      r, w = IO.pipe
      pid = fork do
        r.close; ou.exec 'bash', '-c', 'echo $FOO',
          env: { 'FOO' => 'foo' }, out: w
      end
      w.close; Process.wait pid; x = r.read; r.close
      x.should == "foo\n"
      $?.exitstatus.should == 0
    end
    it 'fail (no shell)' do
      expect { ou.exec 'echo THIS IS NOT A COMMAND' } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'spawn' do                                            # {{{1
    it 'succeed' do
      r, w = IO.pipe
      pid = ou.spawn 'bash', '-c', 'echo $FOO; pwd',
        env: { 'FOO' => 'foo' }, out: w, chdir: '/'
      w.close; Process.wait pid; x = r.read; r.close
      x.should == "foo\n/\n"
      $?.exitstatus.should == 0
    end
    it 'fail (no shell)' do
      expect { ou.spawn 'echo THIS IS NOT A COMMAND' } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'spawn_w' do                                          # {{{1
    it 'succeed' do
      r, w = IO.pipe
      res = ou.spawn_w 'bash', '-c', 'echo $FOO; pwd',
        env: { 'FOO' => 'foo' }, out: w, chdir: '/'
      w.close; x = r.read; r.close
      x.should == "foo\n/\n"
      res.exitstatus.should == 0
    end
    it 'fail (no shell)' do
      expect { ou.spawn_w 'echo THIS IS NOT A COMMAND' } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'system' do                                           # {{{1
    it 'succeed' do
      r, w = IO.pipe
      res = ou.system 'bash', '-c', 'echo $FOO; pwd',
        env: { 'FOO' => 'foo' }, out: w, chdir: '/'
      w.close; x = r.read; r.close
      x.should == "foo\n/\n"
      res.should == true
    end
    it 'fail (no shell)' do
      expect { ou.system 'echo THIS IS NOT A COMMAND' } .to \
        raise_error(ou::RunError, /failed to run command/)
    end
  end                                                           # }}}1

  context 'popen3' do                                           # {{{1
    it 'succeed' do
      ou.popen3 'bash', '-c', 'echo $FOO >&2; pwd',
                env: { 'FOO' => 'foo' }, chdir: '/' do |i,o,e,t|
        i.close
        t.value.exitstatus.should == 0
        o.read.should == "/\n"
        e.read.should == "foo\n"
      end
    end
    it 'fail (no shell)' do
      expect { ou.popen3 'echo THIS IS NOT A COMMAND' } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'ospawn' do                                            # {{{1
    it 'colour' do
      r, w = IO.pipe
      ou.capture_stdout(:tty) do
        pid = ou.ospawn(*%w{ echo FOO }, out: w)
        w.close; Process.wait pid; x = r.read; r.close
        x.should == "FOO\n"
        $?.exitstatus.should == 0
      end .should == "\e[1;34m==> \e[1;37mecho FOO\e[0m\n"
    end
  end                                                           # }}}1

  context 'ospawn_w' do                                          # {{{1
    it 'colour' do
      r, w = IO.pipe
      ou.capture_stdout(:tty) do
        res = ou.ospawn_w(*%w{ echo FOO }, out: w)
        w.close; x = r.read; r.close
        x.should == "FOO\n"
        res.exitstatus.should == 0
      end .should == "\e[1;34m==> \e[1;37mecho FOO\e[0m\n"
    end
  end                                                           # }}}1

  context 'chk_exit' do                                          # {{{1
    it 'zero' do
      expect { ou.chk_exit(%w{ true }) { |a| ou.spawn_w(*a) } } \
        .to_not raise_error
    end
    it 'non-zero' do
      expect { ou.chk_exit(%w{ false }) { |a| ou.spawn_w(*a) } } \
        .to raise_error(ou::RunError, /command returned non-zero/)
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
