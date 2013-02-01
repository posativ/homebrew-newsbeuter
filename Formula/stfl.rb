require 'formula'

class Stfl < Formula
  homepage 'http://www.clifford.at/stfl/'
  url 'http://www.clifford.at/stfl/stfl-0.22.tar.gz'
  sha1 '226488be2b33867dfb233f0fa2dde2d066e494bd'

  def patches
    "https://raw.github.com/gist/1556181/stfl.diff"
  end

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "make install prefix=#{prefix}"
  end
end

