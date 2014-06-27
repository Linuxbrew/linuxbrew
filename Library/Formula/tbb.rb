require "formula"

class Tbb < Formula
  homepage "http://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb42_20140416oss_src.tgz"
  sha1 "1285471b4dce67cf3edf20a071db37f4f205bcf1"
  version "4.2.4"

  option :cxx11

   def install
    # Intel sets varying O levels on each compile command.
    ENV.no_optimization

    args = %W[tbb_build_prefix=BUILDPREFIX]

    args << "compiler=gcc"
    args << "arch=intel64"

    if build.cxx11?
      ENV.cxx11
      args << "cpp0x=1" << "stdlib=libc++"
    end

    system "make", *args
    lib.install Dir["build/BUILDPREFIX_release/*.so"]
    include.install "include/tbb"
  end
end
