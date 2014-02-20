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

  context 'capture2' do                                         # {{{1
    it 'succeed' do
      o, s = ou.capture2 'bash', '-c', 'echo $FOO',
        env: { 'FOO' => 'foo' }
      expect(s.exitstatus).to eq(0)
      expect(o).to eq("foo\n")
    end
    it 'fail (no shell)' do
      expect { ou.capture2 'echo THIS IS NOT A COMMAND' } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'capture2e' do                                        # {{{1
    it 'succeed' do
      oe, s = ou.capture2e 'bash', '-c', 'echo $FOO >&2; pwd',
        env: { 'FOO' => 'foo' }, chdir: '/'
      expect(s.exitstatus).to eq(0)
      expect(oe).to eq("foo\n/\n")
    end
    it 'fail (no shell)' do
      expect { ou.capture2e 'echo THIS IS NOT A COMMAND' } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'capture3' do                                         # {{{1
    it 'succeed' do
      o, e, s = ou.capture3 'bash', '-c', 'echo $FOO >&2; pwd',
        env: { 'FOO' => 'foo' }, chdir: '/'
      expect(s.exitstatus).to eq(0)
      expect(o).to eq("/\n")
      expect(e).to eq("foo\n")
    end
    it 'fail (no shell)' do
      expect { ou.capture3 'echo THIS IS NOT A COMMAND' } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'pipeline' do                                         # {{{1
    it 'succeed' do
      ri, wi  = IO.pipe; wi.puts %w{ foo bar baz foo }; wi.close
      ro, wo  = IO.pipe
      ss      = ou.pipeline ['sort'], %w{ uniq -c }, in: ri, out: wo;
                wo.close
      o       = ro.read; ro.close; ri.close
      expect(ss.length).to eq(2)
      expect(ss[0].exitstatus).to eq(0)
      expect(ss[1].exitstatus).to eq(0)
      expect(o).to match(/\A +1 bar\n +1 baz\n +2 foo\n\z/)
    end
    it 'fail (no shell)' do
      expect { ou.pipeline ['echo THIS IS NOT A COMMAND'] } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'pipeline_r' do                                       # {{{1
    it 'succeed' do
      ri, wi = IO.pipe; wi.puts %w{ foo bar baz foo }; wi.close
      ou.pipeline_r(['sort'], %w{ uniq -c }, in: ri) do |o,ts|
        expect(ts.length).to eq(2)
        expect(ts[0].value.exitstatus).to eq(0)
        expect(ts[1].value.exitstatus).to eq(0)
        expect(o.read).to match(/\A +1 bar\n +1 baz\n +2 foo\n\z/)
      end
    end
    it 'fail (no shell)' do
      expect { ou.pipeline_r ['echo THIS IS NOT A COMMAND'] } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'pipeline_rw' do                                      # {{{1
    it 'succeed' do
      ou.pipeline_rw(['sort'], %w{ uniq -c }) do |i,o,ts|
        i.puts %w{ foo bar baz foo }; i.close
        expect(ts.length).to eq(2)
        expect(ts[0].value.exitstatus).to eq(0)
        expect(ts[1].value.exitstatus).to eq(0)
        expect(o.read).to match(/\A +1 bar\n +1 baz\n +2 foo\n\z/)
      end
    end
    it 'fail (no shell)' do
      expect { ou.pipeline_rw ['echo THIS IS NOT A COMMAND'] } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'pipeline_start' do                                   # {{{1
    it 'succeed' do
      ri, wi = IO.pipe; wi.puts %w{ foo bar baz foo }; wi.close
      ro, wo = IO.pipe
      ou.pipeline_start(['sort'], %w{ uniq -c }, in: ri, out: wo) do |ts|
        expect(ts.length).to eq(2)
        expect(ts[0].value.exitstatus).to eq(0)
        expect(ts[1].value.exitstatus).to eq(0)
      end
      wo.close; o = ro.read; ro.close; ri.close
      expect(o).to match(/\A +1 bar\n +1 baz\n +2 foo\n\z/)
    end
    it 'fail (no shell)' do
      expect { ou.pipeline_start ['echo THIS IS NOT A COMMAND'] } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'pipeline_w' do                                       # {{{1
    it 'succeed' do
      ro, wo = IO.pipe
      ou.pipeline_w(['sort'], %w{ uniq -c }, out: wo) do |i,ts|
        i.puts %w{ foo bar baz foo }; i.close
        expect(ts.length).to eq(2)
        expect(ts[0].value.exitstatus).to eq(0)
        expect(ts[1].value.exitstatus).to eq(0)
      end
      wo.close; o = ro.read; ro.close
      expect(o).to match(/\A +1 bar\n +1 baz\n +2 foo\n\z/)
    end
    it 'fail (no shell)' do
      expect { ou.pipeline_w ['echo THIS IS NOT A COMMAND'] } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'popen2' do                                           # {{{1
    it 'succeed' do
      ou.popen2 'bash', '-c', 'echo $FOO',
          env: { 'FOO' => 'foo' } do |i,o,t|
        i.close
        t.value.exitstatus.should == 0
        o.read.should == "foo\n"
      end
    end
    it 'fail (no shell)' do
      expect { ou.popen2 'echo THIS IS NOT A COMMAND' } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
    end
  end                                                           # }}}1

  context 'popen2e' do                                          # {{{1
    it 'succeed' do
      ou.popen2e 'bash', '-c', 'echo $FOO >&2; pwd',
          env: { 'FOO' => 'foo' }, chdir: '/' do |i,oe,t|
        i.close
        t.value.exitstatus.should == 0
        oe.read.should == "foo\n/\n"
      end
    end
    it 'fail (no shell)' do
      expect { ou.popen2e 'echo THIS IS NOT A COMMAND' } .to \
        raise_error(ou::RunError, /No such file or directory/)  # ????
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
