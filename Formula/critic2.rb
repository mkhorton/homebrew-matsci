class Critic2 < Formula
  desc "Analysis of quantum chemical interactions in molecules and solids."
  homepage "https://github.com/aoterodelaroza/critic2"
  url "https://github.com/aoterodelaroza/critic2/archive/0765e3bf1280f07ebd0a9a6bdf64eb165c31407f.zip"
  version "2.0-stable"
  sha256 "99386eef6fb265d1f08f5e7f59aac3ec2fbca2081edd193b479f718f60c36dce"
  head "https://github.com/aoterodelaroza/critic2.git"
  # tag "matsci"
  # doi "10.1016/j.cpc.2013.10.026"
  # doi "10.1016/j.cpc.2008.07.018"

  option "with-libxc", "Compile with libxc support to calculate exchange and correlation densities"

  depends_on "gcc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libxc" => :optional

  def install
    system "autoreconf", "-i"

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]

    if build.with? "libxc"
      args << "--with-libxc-prefix=#{Formula["libxc"].opt_lib}"
      args << "--with-libxc-include=#{Formula["libxc"].opt_include}"
    end

    system "./configure", *args

    ENV.deparallelize { system "make" }
    system "make", "install"
  end

  test do
    touch("empty.cri")
    system "#{bin}/critic2", "empty.cri"
  end
end
