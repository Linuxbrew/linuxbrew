require 'formula'

class Libidn < Formula
  homepage 'http://www.gnu.org/software/libidn/'
  url 'http://ftpmirror.gnu.org/libidn/libidn-1.28.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libidn/libidn-1.28.tar.gz'
  sha256 'dd357a968449abc97c7e5fa088a4a384de57cb36564f9d4e0d898ecc6373abfb'

  depends_on 'pkg-config' => :build

  option :universal

  ENV['CFLAGS'] = "-fPIC -shared  -static -rpath -ldl -rdynamic -Os -w -pipe -march=core2 -msse4"
  ENV['CXXFLAGS'] = "-fPIC -shared -static -rpath -ldl -rdynamic -Os -w -pipe -march=core2 -msse4"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--enable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp"
    system "make install"
  end

  def test
    system "#{bin}/idn", "--version"
  end
end
