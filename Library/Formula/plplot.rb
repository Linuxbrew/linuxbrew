class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "http://plplot.sourceforge.net"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.11.1%20Source/plplot-5.11.1.tar.gz"
  sha256 "289dff828c440121e57b70538b3f0fb4056dc47159bc1819ea444321f2ff1c4c"

  bottle do
    sha256 "d3241c1a7251b2a57a16c8ebc46c3372c7fd8b788f3863f419a6bc37cf2924a9" => :yosemite
    sha256 "f97ec3e39264ef40d31b6b8b516649bbbd53591b2a5debcd30ab38fafdfdf121" => :mavericks
    sha256 "6d295b3f17311517054ac418bb8716346d82cdb02faff4080355c6adb7192b99" => :mountain_lion
  end

  option "with-java"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "pango"
  depends_on "libtool" => :run
  depends_on "freetype"
  depends_on :x11 => :optional
  depends_on :fortran => :optional

  def install
    args = std_cmake_args
    args << "-DENABLE_java=OFF" if build.without? "java"
    args << "-DPLD_xwin=OFF" if build.without? "x11"
    args << "-DENABLE_f95=OFF" if build.without? "fortran"
    args << "-DENABLE_ada=OFF" << "-DENABLE_d=OFF" << "-DENABLE_qt=OFF" \
         << "-DENABLE_lua=OFF" << "-DENABLE_tk=OFF" << "-DENABLE_python=OFF" \
         << "-DENABLE_tcl=OFF" << "-DPLD_xcairo=OFF" << "-DPLD_wxwidgets=OFF" \
         << "-DENABLE_wxwidgets=OFF"

    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <plplot.h>

      int main(int argc, char *argv[]) {
        plparseopts( &argc, argv, PL_PARSE_FULL );
        plsdev( "extcairo" );
        plinit();
        return 0;
      }
    EOS
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}/plplot
      -L#{lib}
      -lcsirocsa
      -lltdl
      -lm
      -lplplot
      -lqsastime
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
