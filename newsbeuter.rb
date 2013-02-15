require 'formula'

class Newsbeuter < Formula
  homepage 'http://newsbeuter.org/'
  url 'http://newsbeuter.org/downloads/newsbeuter-2.5.tar.gz'
  sha1 'f3ed4d98c790e881a3782bd7c3e5572b09689bf5'
  head 'https://github.com/akrennmair/newsbeuter.git', :using => :git

  depends_on 'stfl'
  depends_on 'curl'
  depends_on 'sqlite'
  depends_on 'libxml2'
  depends_on 'json-c'
  depends_on 'gettext'

  def patches
    if not build.head? then
      { :p1 => [
        "https://raw.github.com/gist/2431979/newsbeuter.diff",
        DATA
      ]}
    end
  end

  def install
    system "make"
    system "make install prefix=#{prefix}"
  end

end

__END__
diff --git a/src/ttrss_api.cpp b/src/ttrss_api.cpp
index 2cb36d4..0b7ac21 100644
--- a/src/ttrss_api.cpp
+++ b/src/ttrss_api.cpp
@@ -228,7 +228,7 @@ rsspp::feed ttrss_api::fetch_feed(const std::string& id) {
 		const char * link = json_object_get_string(json_object_object_get(item_obj, "link"));
 		const char * content = json_object_get_string(json_object_object_get(item_obj, "content"));
 		time_t updated = (time_t)json_object_get_int(json_object_object_get(item_obj, "updated"));
-		boolean unread = json_object_get_boolean(json_object_object_get(item_obj, "unread"));
+		bool unread = json_object_get_boolean(json_object_object_get(item_obj, "unread"));
 
 		rsspp::item item;
