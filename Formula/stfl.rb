require 'formula'

class Stfl < Formula
  homepage 'http://www.clifford.at/stfl/'
  url 'http://www.clifford.at/stfl/stfl-0.22.tar.gz'
  md5 'df4998f69fed15fabd702a25777f74ab'

  def patches
    "https://raw.github.com/gist/1556181/stfl.diff"
  end

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "make install prefix=#{prefix}"
  end
end

