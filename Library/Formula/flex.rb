require 'formula'

class Flex < Formula
  homepage 'http://flex.sourceforge.net'
  url 'http://downloads.sourceforge.net/flex/flex-2.5.37.tar.bz2'
  sha1 'db4b140f2aff34c6197cab919828cc4146aae218'

  depends_on 'gettext'

  def install
    system "./configure", "",
                          "--prefix=#{prefix}"
    system 'make install'
  end
end
