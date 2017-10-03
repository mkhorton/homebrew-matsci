class Bader < Formula
  desc "Grid based Bader analysis"
  homepage "http://theory.cm.utexas.edu/henkelman/code/bader/"
  url "http://theory.cm.utexas.edu/henkelman/code/bader/download/v1.00/bader.tar.gz"
  sha256 "9defc5d005521a3ed8bad7a3e2e557283962269eddf9994864c77b328c179c63"
  # tag "matsci"
  # doi "10.1088/0953-8984/21/8/084204"
  # doi "10.1002/jcc.20575"
  # doi "10.1016/j.commatsci.2005.04.010"
  # doi "10.1063/1.3553716"

  depends_on "gcc" => :build
  depends_on :fortran => :build

  def install
    ENV.deparallelize

    fc = File.basename ENV.fc

    if fc == "gfortran"
      system "make", "-f", "makefile.osx_gfortran"
    elsif fc == "ifort"
      system "make", "-f", "makefile.osx_ifort"
    end

    bin.install "bader"
  end

  test do
    # test files are large and not distributed with the source distribution
    # so test simply runs bader binary to print help
    system "#{bin}/bader"
  end
end
