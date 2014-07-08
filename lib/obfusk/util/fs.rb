# --                                                            ; {{{1
#
# File        : obfusk/util/fs.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-07-07
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'fileutils'

# my namespace
module Obfusk; module Util; module FS

  # append to file
  def self.append(file, *lines)
    File.open(file, 'a') { |f| f.puts lines }
  end

  # does file/dir or symlink exists?
  def self.exists?(path)
    File.exist?(path) || File.symlink?(path)
  end

  # ohai + mkdir_p; requires `obfusk/util/message`
  def self.omkdir_p(*paths)
    ::Obfusk::Util.ohai "mkdir -p #{paths*' '}"
    FileUtils.mkdir_p paths
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
