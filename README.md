[]: {{{1

    File        : README.md
    Maintainer  : Felix C. Stegerman <flx@obfusk.net>
    Date        : 2014-02-19

    Copyright   : Copyright (C) 2014  Felix C. Stegerman
    Version     : v0.4.2

[]: }}}1

[![Gem Version](https://badge.fury.io/rb/obfusk-util.png)](http://badge.fury.io/rb/obfusk-util)

## Description

  [rb-]obfusk-util - miscellaneous utility library for ruby

## Examples
[]: {{{1

```ruby
require 'obfusk/util/all'
```

---

[]: {{{2

```ruby
require 'obfusk/util/cmd'

Obfusk::Util::Cmd.killsig 'SIGINT foo bar'
# => { command: 'foo bar', signal: 'SIGINT' }

Obfusk::Util::Cmd.killsig 'foo bar'
# => { command: 'foo bar', signal: 'SIGTERM' }

Obfusk::Util::Cmd.shell 'SHELL echo "$FOO: $BAR"'
# => { command: 'echo "$FOO: $BAR"', shell: 'bash' }

Obfusk::Util::Cmd.set_vars 'echo ${FOO} ... ${BAR} ...',
  { 'FOO' => 'foo', 'BAR' => 'bar' }
# => 'echo foo ... bar ...'
```

[]: }}}2

---

[]: {{{2

```ruby
require 'obfusk/util/data'

x = { x: { y: 0 }, z: [1,2,3] }
Obfusk::Util.assoc(x, [:x,:y] => 1, [:z,1] => 99)
x[:x][:y] == 1          # => true
x[:z]     == [1,99,3]   # => true

y = Obfusk::Util.deepdup x
Obfusk::Util.empty_as_nil(ENV['FOO']) || default
```

[]: }}}2

---

[]: {{{2

```ruby
require 'obfusk/util/fs'

Obfusk::Util::FS.append('file', *lines)
Obfusk::Util::FS.exists? 'file-or-possibly-broken-symlink'
```

[]: }}}2

---

[]: {{{2

```ruby
require 'obfusk/util/message'

Obfusk::Util.ohai(*%w{ rackup -p 8888 })
# shows '==> rackup -p 8888' in colour

Obfusk::Util.onow 'Starting', 'foo', 'bar'
# shows '==> Starting: foo, bar' in colour

Obfusk::Util.onoe 'Something is wrong!' # error in colour
Obfusk::Util.opoo 'This looks funny!'   # warning in colour
```

There are some `o*` methods all over `obfusk-util` that combine some
operation with e.g. `ohai`.

[]: }}}2

---

[]: {{{2

```ruby
require 'obfusk/util/module'

module Foo; def self.foo; 42; end; end
module Bar
  # alias Foo.foo as Bar.foo and Bar.bar
  Obfusk::Util.link_mod_method Foo, :foo, self
  Obfusk::Util.link_mod_method Foo, :foo, self, :bar
end

Obfusk::Util.require_all 'foo/bar'
# requires foo/bar/*

Obfusk::Util.submodules Foo
# => { 'bar' => Foo::Bar, 'baz' => Foo:Baz, ... }
```

[]: }}}2

---

[]: {{{2

Slightly improved `OptionParser` (w/o officious options):

```ruby
require 'obfusk/util/opt'

p = Obfusk::Util::Opt::Parser.new # ...
remaining_args = p.parse_r ARGV
```

[]: }}}2

---

[]: {{{2

```ruby
require 'obfusk/util/os'

Obfusk::Util::OS.home         # => current user's home
Obfusk::Util::OS.home 'user'  # => user's home
Obfusk::Util::OS.user         # => current user
Obfusk::Util::OS.now          # => current time as '%F %T'
```

[]: }}}2

---

[]: {{{2

```ruby
require 'obfusk/util/process'

Obfusk::Util::Process.age pid     # => e.g. '01:06:19'
Obfusk::Util::Process.alive? pid  # => false/true/:not_mine
```

[]: }}}2

---

[]: {{{2

`spawn_w` is `spawn` + `wait` (which is nicer than `system`).  No
shell is ever used; `env` is an option instead of an optional first
argument; `ENOENT` becomes `RunError`.  See also: `exec`, `spawn`,
`system`, `capture{2,2e,3}`, `pipeline{,_r,_rw,_start,_w}`,
`popen{2,2e,3}`.

```ruby
require 'obfusk/util/run'

Obfusk::Util.spawn_w(*%w{ some command }, env: { 'FOO' => 'bar' },
  chdir: 'some/dir') #, ...
# => $?

# raise RunError if command returned non-zero
Obfusk::Util.chk_exit(%w{ some command }) do |a|
  # spawn + wait + ohai
  Obfusk::Util.ospawn_w(*a)
end
```

[]: }}}2

---

[]: {{{2

```ruby
require 'obfusk/util/sh'

sh('echo "$0" ">>$1<<" ">>$FOO<<"', '"one"', 'FOO' => 'foo').stdout
# => %Q{bash >>"one"<< >>foo<<}

sh('echo step1; false; echo step3',
  print: true, exit: true, merge: true).stdout
# => "+ echo step1\nstep1\n+ false\n"

sh? 'false'
# => false

sh! 'false'
# => RunError
```

[]: }}}2

---

[]: {{{2

```ruby
require 'obfusk/util/spec'

Obfusk::Util.provide_stdin(input) do
  # do something with $stdin
end

output = Obfusk::Util.capture_stdout do
  # do something with $stdout
end

output = Obfusk::Util.capture_stderr(:tty) do
  # do something with $stderr; $stderr.isatty => true
end
```

[]: }}}2

---

[]: {{{2

```ruby
require 'obfusk/util/struct'

Foo = Obfusk::Util.struct(*%w{ field1 field2 field3 }) do
  def some_method; field1 + field2; end
end

foo = Foo.new field1: 37, field2: 5
foo.some_method # => 42

# build a Foo which is frozen when the block ends
bar = Foo.build(field1: 99) do |x|
  c.field2 = 1
  # ...
end

bar.field3 = 99   # => RuntimeError b/c frozen
bar.check!        # => IncompleteError b/c there are empty fields
```

[]: }}}2

---

[]: {{{2

```ruby
require 'obfusk/util/term'

Obfusk::Util::Term.colour :red
# => ansi escape code if $stdout is a tty, '' otherwise

Obfusk::Util::Term.columns                # terminal columns
Obfusk::Util::Term.lines                  # terminal lines
Obfusk::Util::Term.tty?                   # is $stdout a tty?
Obfusk::Util::Term.tty? :err              # is $stderr a tty?

Obfusk::Util::Term.prompt 'foo> '         # prompt for input
Obfusk::Util::Term.prompt 'foo> ', :hide  # prompt for password
```

[]: }}}2

---

[]: {{{2

```ruby
require 'obfusk/util/valid'

def foo(*args_)
  Obfusk::Util::Valid.args 'description', args_, 1, 3
  # => ArgumentError if #args not in 1..3
end
```

[]: }}}2

[]: }}}1

## Specs & Docs

```bash
$ rake spec
$ rake docs
```

## TODO

  * improve sh w/ fp (pipe, lines, json, blocks)?
  * more specs/docs?
  * split into several gems?
  * ...

## License

  LGPLv3+ [1].

## References

  [1] GNU Lesser General Public License, version 3
  --- http://www.gnu.org/licenses/lgpl-3.0.html

[]: ! ( vim: set tw=70 sw=2 sts=2 et fdm=marker : )
