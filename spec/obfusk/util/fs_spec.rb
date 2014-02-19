# --                                                            ; {{{1
#
# File        : obfusk/util/fs_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-02-19
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'obfusk/util/fs'
require 'obfusk/util/message'

require 'fileutils'
require 'tmpdir'

ou = Obfusk::Util
fs = Obfusk::Util::FS

describe 'obfusk/util/fs' do

  context 'append' do                                           # {{{1
    it 'new file' do
      Dir.mktmpdir do |dir|
        fs.append "#{dir}/testfile", %w{ foo bar baz }
        File.read("#{dir}/testfile").should == "foo\nbar\nbaz\n"
      end
    end
    it 'existing file' do
      Dir.mktmpdir do |dir|
        File.write "#{dir}/testfile", "some data\n"
        fs.append "#{dir}/testfile", %w{ foo bar baz }
        File.read("#{dir}/testfile").should == \
          "some data\nfoo\nbar\nbaz\n"
      end
    end
  end                                                           # }}}1

  context 'exists?' do                                          # {{{1
    it 'existing file' do
      Dir.mktmpdir do |dir|
        FileUtils.touch "#{dir}/testfile"
        fs.exists?("#{dir}/testfile").should be_true
      end
    end
    it 'existing link' do
      Dir.mktmpdir do |dir|
        FileUtils.touch "#{dir}/target"
        File.symlink "#{dir}/target", "#{dir}/symlink"
        fs.exists?("#{dir}/symlink").should be_true
      end
    end
    it 'existing dir' do
      Dir.mktmpdir do |dir|
        fs.exists?(dir).should be_true
      end
    end
    it 'non-existing file' do
      Dir.mktmpdir do |dir|
        fs.exists?("#{dir}/testfile").should be_false
      end
    end
    it 'non-existing link' do
      Dir.mktmpdir do |dir|
        fs.exists?("#{dir}/symlink").should be_false
      end
    end
    it 'non-existing dir' do
      Dir.mktmpdir do |dir|
        fs.exists?("#{dir}/nonexistent").should be_false
      end
    end
    it 'broken link' do
      Dir.mktmpdir do |dir|
        File.symlink "#{dir}/target", "#{dir}/symlink"
        fs.exists?("#{dir}/symlink").should be_true
      end
    end
  end                                                           # }}}1

  context 'omkdir_p' do                                         # {{{1
    it 'exists + message' do
      Dir.mktmpdir do |dir|
        dirs = %w{ foo bar baz }.map { |x| "#{dir}/#{x}" }
        ou.capture_stdout { fs.omkdir_p(*dirs) } \
          .should == "==> mkdir -p #{dirs*' '}\n"
        dirs.each { |d| Dir.exists?(d).should be_true }
      end
    end
  end                                                           # }}}1

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
