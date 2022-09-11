class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "https://download.kde.org/stable/release-service/22.08.0/src/kcachegrind-22.08.0.tar.xz"
  sha256 "674d0a6d56b3b0f0d37b5fe8f7b976ceded972842297a275f2230af2232f76d6"
  license "GPL-2.0-or-later"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "51036481ec372fe406232ab278d88989c770609f30186967ace588155a78d9dc"
    sha256 cellar: :any,                 arm64_big_sur:  "d103cec2b2839c98a71eb6fbf3cb3ad0ff62d71cfe244c74fe5ae8ebf46a9aa1"
    sha256 cellar: :any,                 monterey:       "ae8ab0e853de358c181d6fe87872dc53c8f78288cde3c679a785dccf1b183edb"
    sha256 cellar: :any,                 big_sur:        "78293bdf5b1641f1ef4fabdc4a00b1553337d89bc9dbeb485928f110e97e4a7d"
    sha256 cellar: :any,                 catalina:       "a20e72b9ad4806a69e1625e2a36ae06d285b959801d0dc5bc95e90865d456644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94657967ecdb92ac2e30648aa4f4f49f2e2ce6499a16f8c0ed68bf58173ac1c5"
  end

  depends_on "graphviz"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = ["-config", "release", "-spec"]
    os = OS.mac? ? "macx" : OS.kernel_name.downcase
    compiler = ENV.compiler.to_s.start_with?("gcc") ? "g++" : ENV.compiler
    arch = Hardware::CPU.intel? ? "" : "-#{Hardware::CPU.arch}"
    args << "#{os}-#{compiler}#{arch}"

    system Formula["qt@5"].opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end
