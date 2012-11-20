require 'formula'

class Newsbeuter < Formula
  homepage 'http://newsbeuter.org/'
  head 'https://github.com/akrennmair/newsbeuter.git'
  url 'http://newsbeuter.org/downloads/newsbeuter-2.5.tar.gz'
  md5 'bb8cd3f2a3693de4c16be28c869a1f75'

  depends_on 'stfl'
  depends_on 'curl'
  depends_on 'sqlite'
  depends_on 'libxml2'
  depends_on 'json-c'
  depends_on 'gettext'

  def patches
	return [DATA, "https://raw.github.com/gist/2431979/newsbeuter.diff"] if not build.head? 
  end

  def install
    system "make"
    system "make install prefix=#{prefix}"
  end

end
