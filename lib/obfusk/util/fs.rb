# --                                                            ; {{{1
#
# File        : obfusk/util/fs.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'fileutils'

module Obfusk; module Util; module FS

  # append to file
  def self.append(file, *lines)
    File.open(file, 'a') { |f| f.puts lines }
  end

  # does file/dir or symlink exists?
  def self.exists?(path)
    File.exists?(path) || File.symlink?(path)
  end

  # ohai + mkdir_p; requires `obfusk/util/message`
  def self.omkdir_p(*paths)
    ::Obfusk::Util.ohai "mkdir -p #{paths*' '}"
    FileUtils.mkdir_p paths
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
