class Enumlib < Formula
  desc "Derivative structure enumeration library"
  homepage "https://github.com/msg-byu/enumlib"
  url "https://github.com/msg-byu/enumlib/archive/v1.0.8.tar.gz"
  sha256 "dc82c68a0987e4c32c224b64ab03fb82397c80f789906a01994366c526c56499"
  # tag "matsci"
  # doi: 10.1103/PhysRevB.77.224115
  # doi: 10.1103/PhysRevB.80.014120
  # doi: 10.1016/j.commatsci.2012.02.015

  depends_on "gcc" => :build
  depends_on :fortran => :build

  resource "symlib" do
    url "https://github.com/msg-byu/symlib/archive/v1.1.0.tar.gz"
    sha256 "2dbde11031cd27c20566275fc1fca112e989e7150fa9afa5560acf483761613f"
  end

  def install
    ENV.deparallelize

    # F90 can be either gfortran or ifort
    f90 = File.basename ENV.fc

    resource("symlib").stage do
      cp_r ".", "#{buildpath}/symlib"
    end

    cd "symlib/src" do
      system "make", "F90=#{f90}"
    end

    cd "src" do
      system "make", "F90=#{f90}"
      system "make", "F90=#{f90}", "enum.x"
      system "make", "F90=#{f90}", "makestr.x"
      bin.install "enum.x"
      bin.install "makestr.x"
    end
  end

  test do
    # using sample input provided by enumlib
    input = "fcc
bulk
0.50000000     0.50000000      0.0000000        # a1 parent lattice vector
0.50000000      0.0000000     0.50000000        # a2 parent lattice vector
 0.0000000     0.50000000     0.50000000        # a3 parent lattice vector
 2 -nary case
    1 # Number of points in the multilattice
 0.0000000      0.0000000      0.0000000    0/1   # d01 d-vector
    8 8   # Starting and ending cell sizes for search
0.10000000E-06 # Epsilon (finite precision parameter)
part list of labelings
1 2 2
1 2 2
"
    File.write("struct_enum.in", input)
    system "#{bin}/enum.x"
  end
end
