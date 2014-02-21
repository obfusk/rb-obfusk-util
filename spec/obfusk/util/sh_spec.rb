# --                                                            ; {{{1
#
# File        : obfusk/util/sh_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-20
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'obfusk/util/sh'

ou = Obfusk::Util

describe 'obfusk/util/sh' do

  context 'sh (1)' do                                           # {{{1
    it 'echoes w/ args and env' do
      r, w = IO.pipe
      res = ou.sh 'echo "$0" ">>$1<<" ">>$FOO<<"', '"one"',
        'FOO' => 'foo', out: w
      w.close; x = r.read; r.close
      expect(res.ok?).to eq(true)
      expect(x).to eq(%Q{bash >>"one"<< >>foo<<\n})
    end
    it 'works w/ print, exit, and merge' do
      r, w = IO.pipe
      res = ou.sh 'echo step1; false; echo step3', print: true, exit: true,
        merge: true, out: w
      w.close; x = r.read; r.close
      expect(res.ok?).to eq(false)
      expect(x).to eq("+ echo step1\nstep1\n+ false\n")
    end
    it 'outputs pwd w/ arg' do
      r, w = IO.pipe
      res = ou.sh 'cd "$1"; pwd', '/', out: w
      w.close; x = r.read; r.close
      expect(res.ok?).to eq(true)
      expect(x).to eq("/\n")
    end
    it 'outputs pwd w/ :chdir' do
      r, w = IO.pipe
      res = ou.sh 'pwd', chdir: '/', out: w
      w.close; x = r.read; r.close
      expect(res.ok?).to eq(true)
      expect(x).to eq("/\n")
    end
  end                                                           # }}}1

  context 'sh (2)' do                                           # {{{1
    it 'prints to stderr w/ print/-x' do
      ro, wo = IO.pipe; re, we = IO.pipe
      res = ou.sh 'echo FOO; echo BAR', print: true, out: wo, err: we
      wo.close; o = ro.read; ro.close
      we.close; e = re.read; re.close
      expect(res.ok?).to eq(true)
      expect(o).to eq("FOO\nBAR\n")
      expect(e).to eq("+ echo FOO\n+ echo BAR\n")
    end
    it 'ignores false w/o exit/-e' do
      r, w = IO.pipe
      res = ou.sh 'echo FOO; false; echo BAR', out: w
      w.close; x = r.read; r.close
      expect(res.ok?).to eq(true)
      expect(x).to eq("FOO\nBAR\n")
    end
    it 'stops at false w/ exit/-e' do
      r, w = IO.pipe
      res = ou.sh 'echo FOO; false; echo BAR', exit: true, out: w
      w.close; x = r.read; r.close
      expect(res.ok?).to eq(false)
      expect(x).to eq("FOO\n")
    end
    it 'merges stdout and stderr w/ merge' do
      r, w = IO.pipe
      res = ou.sh 'echo FOO; echo BAR >&2; echo BAZ', merge: true, out: w
      w.close; x = r.read; r.close
      expect(res.ok?).to eq(true)
      expect(x).to eq("FOO\nBAR\nBAZ\n")
    end
    it 'merges env w/ string keys' do
      r, w = IO.pipe
      res = ou.sh 'echo $FOO; echo $BAR',
        env: { 'FOO' => 'no', 'BAR' => 'bar' }, 'FOO' => 'yes', out: w
      w.close; x = r.read; r.close
      expect(res.ok?).to eq(true)
      expect(x).to eq("yes\nbar\n")
    end
  end                                                           # }}}1

  context 'sh (3)' do                                           # {{{1
    it 'false => ok? returns false and ok! raises' do
      r, w = IO.pipe
      res = ou.sh 'false', out: w
      w.close; x = r.read; r.close
      expect(res.ok?).to eq(false)
      expect(res.status.exitstatus).to eq(1)
      expect { res.ok! } .to \
        raise_error(ou::RunError, /command returned non-zero/)
      expect(x).to eq('')
    end
    it 'fails w/ message on stderr w/ NONEXISTENT' do
      r, w = IO.pipe
      res = ou.sh 'NONEXISTENT', err: w
      w.close; x = r.read; r.close
      expect(res.ok?).to eq(false)
      expect(res.status.exitstatus).to eq(127)
      expect(x).to eq("bash: NONEXISTENT: command not found\n")
    end
    it 'fails w/ RunError w/ shell NONEXISTENT' do
      expect { ou.sh 'irrelevant', shell: 'NONEXISTENT' } .to \
        raise_error(ou::RunError, /failed to spawn command/)
    end
  end                                                           # }}}1

  context 'sh?' do                                              # {{{1
    it 'true => true' do
      expect(ou.sh? 'true').to eq(true)
    end
    it 'false => false' do
      expect(ou.sh? 'false').to eq(false)
    end
  end                                                           # }}}1

  context 'sh!' do                                              # {{{1
    it 'true => Sh' do
      expect( ou.sh! 'true' ).to be_an_instance_of(ou::Sh)
    end
    it 'false => RunError' do
      expect { ou.sh! 'false' } .to \
        raise_error(ou::RunError, /command returned non-zero/)
    end
  end                                                           # }}}1

  context 'shc (1)' do                                          # {{{1
    it 'echoes w/ args and env' do
      r = ou.shc 'echo "$0" ">>$1<<" ">>$FOO<<"', '"one"',
        'FOO' => 'foo'
      expect(r.ok?).to eq(true)
      expect(r.stdout).to eq(%Q{bash >>"one"<< >>foo<<\n})
      expect(r.stderr).to eq('')
    end
    it 'works w/ print, exit, and merge' do
      r = ou.shc 'echo step1; false; echo step3', print: true, exit: true,
        merge: true
      expect(r.ok?).to eq(false)
      expect(r.stdout).to eq("+ echo step1\nstep1\n+ false\n")
      expect(r.stderr).to eq(nil)
    end
    it 'outputs pwd w/ arg' do
      r = ou.shc 'cd "$1"; pwd', '/'
      expect(r.ok?).to eq(true)
      expect(r.stdout).to eq("/\n")
      expect(r.stderr).to eq('')
    end
    it 'outputs pwd w/ :chdir' do
      r = ou.shc 'pwd', chdir: '/'
      expect(r.ok?).to eq(true)
      expect(r.stdout).to eq("/\n")
      expect(r.stderr).to eq('')
    end
  end                                                           # }}}1

  context 'shc (2)' do                                          # {{{1
    it 'prints to stderr w/ print/-x' do
      r = ou.shc 'echo FOO; echo BAR', print: true
      expect(r.ok?).to eq(true)
      expect(r.stdout).to eq("FOO\nBAR\n")
      expect(r.stderr).to eq("+ echo FOO\n+ echo BAR\n")
    end
    it 'ignores false w/o exit/-e' do
      r = ou.shc 'echo FOO; false; echo BAR'
      expect(r.ok?).to eq(true)
      expect(r.stdout).to eq("FOO\nBAR\n")
      expect(r.stderr).to eq('')
    end
    it 'stops at false w/ exit/-e' do
      r = ou.shc 'echo FOO; false; echo BAR', exit: true
      expect(r.ok?).to eq(false)
      expect(r.stdout).to eq("FOO\n")
      expect(r.stderr).to eq('')
    end
    it 'merges stdout and stderr w/ merge' do
      r = ou.shc 'echo FOO; echo BAR >&2; echo BAZ', merge: true
      expect(r.ok?).to eq(true)
      expect(r.stdout).to eq("FOO\nBAR\nBAZ\n")
      expect(r.stderr).to eq(nil)
    end
    it 'merges env w/ string keys' do
      r = ou.shc 'echo $FOO; echo $BAR',
        env: { 'FOO' => 'no', 'BAR' => 'bar' }, 'FOO' => 'yes'
      expect(r.ok?).to eq(true)
      expect(r.stdout).to eq("yes\nbar\n")
      expect(r.stderr).to eq('')
    end
  end                                                           # }}}1

  context 'shc (3)' do                                          # {{{1
    it 'false => ok? returns false and ok! raises' do
      r = ou.shc 'false'
      expect(r.ok?).to eq(false)
      expect(r.status.exitstatus).to eq(1)
      expect { r.ok! } .to \
        raise_error(ou::RunError, /command returned non-zero/)
      expect(r.stdout).to eq('')
      expect(r.stderr).to eq('')
    end
    it 'fails w/ message on stderr w/ NONEXISTENT' do
      r = ou.shc 'NONEXISTENT'
      expect(r.ok?).to eq(false)
      expect(r.status.exitstatus).to eq(127)
      expect(r.stdout).to eq('')
      expect(r.stderr).to eq("bash: NONEXISTENT: command not found\n")
    end
    it 'fails w/ RunError w/ shell NONEXISTENT' do
      expect { ou.shc 'irrelevant', shell: 'NONEXISTENT' } .to \
        raise_error(ou::RunError, /failed to capture3 command/)
    end
  end                                                           # }}}1

  context 'shc?' do                                             # {{{1
    it 'true => true' do
      expect(ou.shc? 'true').to eq(true)
    end
    it 'false => false' do
      expect(ou.shc? 'false').to eq(false)
    end
  end                                                           # }}}1

  context 'shc!' do                                             # {{{1
    it 'true => Shc' do
      expect( ou.shc! 'true' ).to be_an_instance_of(ou::Shc)
    end
    it 'false => RunError' do
      expect { ou.shc! 'false' } .to \
        raise_error(ou::RunError, /command returned non-zero/)
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
