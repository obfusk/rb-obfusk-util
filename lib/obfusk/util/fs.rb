# --                                                            ; {{{1
#
# File        : obfusk/util/fs.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-07-17
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

module Obfusk; module Util; module FS

  # append to file
  def self.append(file, *lines)
    File.open(file, 'a') { |f| puts lines }
  end

  # does file/dir or symlink exists?
  def self.exists?(path)
    File.exists?(path) || File.symlink?(path)
  end

end; end; end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
