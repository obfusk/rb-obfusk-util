[]: {{{1

    File        : README.md
    Maintainer  : Felix C. Stegerman <flx@obfusk.net>
    Date        : 2013-07-24

    Copyright   : Copyright (C) 2013  Felix C. Stegerman
    Version     : v0.0.1.SNAPSHOT

[]: }}}1

## Description
[]: {{{1

  [rb-]obfusk-util - miscellaneous utility library for ruby

  ...

[]: }}}1

## Examples
[]: {{{1

[]: {{{2

```ruby
Obfusk::Util::Cmd.killsig 'SIGINT foo bar'
# => { command: 'foo bar', signal: 'SIGINT' }

Obfusk::Util::Cmd.killsig 'foo bar'
# => { command: 'foo bar', signal: 'SIGTERM' }

Obfusk::Util::Cmd.shell 'SHELL echo "$FOO: $BAR"'
# => { command: 'echo "$FOO: $BAR"', shell: 'bash' }

Obfusk::Util::Cmd.set_vars 'echo FOO ... BAR ...',
  { 'FOO' => 'foo', 'BAR' => 'bar' }
# => 'echo foo ... bar ...'
```

[]: }}}2

[]: {{{2

```ruby
y = Obfusk::Util.deepdup x
Obfusk::Util.empty_as_nil(ENV['FOO']) || default
```

[]: }}}2

[]: {{{2

```ruby
Obfusk::Util::FS.append 'file', *lines
Obfusk::Util::FS.exists? 'file-or-possibly-broken-symlink'
```

[]: }}}2

[]: {{{2

```ruby
Obfusk::Util.ohai *%w{ rackup -p 8888 }
# shows '==> rackup -p 8888' in colour

Obfusk::Util.onow 'Starting', 'foo', 'bar'
# shows '==> Starting: foo, bar' in colour

Obfusk::Util.onoe 'Something is wrong!' # error in colour
Obfusk::Util.opoo 'This looks funny!'   # warning in colour
```

There are some o\* methods all over obfusk-util that combine some
operation with e.g. ohai.

[]: }}}2

[]: {{{2

```ruby
Obfusk::Util.require_all 'foo/bar'
# requires foo/bar/*

Obfusk::Util.submodules Foo
# => { 'bar' => Foo::Bar, 'baz' => Foo:Baz, ... }
```

[]: }}}2

[]: {{{2

Slightly improved OptionParser (w/o officious options):

```ruby
p = Obfusk::Util::Opt::Parser.new # ...
remaining_args = p.parse_r ARGV
```

[]: }}}2

[]: {{{2

```ruby
Obfusk::Util::OS.home         # => current user's home
Obfusk::Util::OS.home 'user'  # => user's home
Obfusk::Util::OS.user         # => current user
Obfusk::Util::OS.now          # => current time as '%F %T'
```

[]: }}}2

[]: {{{2

```ruby
Obfusk::Util::Process.age pid     # => e.g. '01:06:19'
Obfusk::Util::Process.alive? pid  # => false/true/:not_mine
```

[]: }}}2

[]: {{{2

spawn_w is spawn + wait (which is nicer than system).  No shell is
ever used; env is an option instead of an optional first argument;
ENOENT becomes RunError.  See also: exec, spawn, system, popen3.

```ruby
Obfusk::Util.spawn_w *%w{ some command }, env: { 'FOO' => 'bar' },
  chdir: 'some/dir' #, ...
# => $?

# raise RunError if command returned non-zero
Obfusk::Util.chk_exit(%w{ some command }) do |a|
  # spawn + wait + ohai
  Obfusk::Util.ospawn_w *a
end
```

[]: }}}2

[]: {{{2

```ruby
Foo = Obfusk::Util.struct(*%w{ field1 field2, field3 }) do
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

[]: {{{2

```ruby
Obfusk::Util::Term.colour :red
# => ansi escape code if STDOUT is a tty, '' otherwise

Obfusk::Util::Term.columns                # terminal columns
Obfusk::Util::Term.lines                  # terminal lines
Obfusk::Util::Term.tty?                   # is STDOUT a tty?
Obfusk::Util::Term.tty? :err              # is STDERR a tty?

Obfusk::Util::Term.prompt 'foo> '         # prompt for input
Obfusk::Util::Term.prompt 'foo> ', :hide  # prompt for password
```

[]: }}}2

[]: {{{2

```ruby
def foo(*args_)
  Obfusk::Util::Valid.args 'description', args_, 1, 3
  # => ArgumentError if #args not in 1..3
end
```

[]: }}}2

[]: }}}1

## Specs & Docs
[]: {{{1

    $ rake spec
    $ rake docs

[]: }}}1

## TODO
[]: {{{1

  * write more specs
  * write more docs
  * dual-license under EPLv1?
  * ...

[]: }}}1

## License
[]: {{{1

  GPLv2 [1].

[]: }}}1

## References
[]: {{{1

  [1] GNU General Public License, version 2
  --- http://www.opensource.org/licenses/GPL-2.0

[]: }}}1

[]: ! ( vim: set tw=70 sw=2 sts=2 et fdm=marker : )
