require 'formula'

class Newsbeuter < Formula
  homepage 'http://newsbeuter.org/'
  url 'http://newsbeuter.org/downloads/newsbeuter-2.5.tar.gz'
  sha1 'f3ed4d98c790e881a3782bd7c3e5572b09689bf5'
  head 'https://github.com/akrennmair/newsbeuter.git', :using => :git

  depends_on 'pkg-config' => :build
  depends_on 'curl'
  depends_on 'gettext'
  depends_on 'json-c'
  depends_on 'libstfl'
  depends_on 'sqlite'

  def patches
    if not build.head? then
      { :p1 => DATA }
    end
  end

  def install
    system "make"
    system "make install prefix=#{prefix}"
  end

end

__END__
diff --git a/config.sh b/config.sh
--- a/config.sh
+++ b/config.sh
@@ -100,6 +100,8 @@ check_pkg "libcurl" || check_custom "libcurl" "curl-config" || fail "libcurl"
 check_pkg "libxml-2.0" || check_custom "libxml2" "xml2-config" || fail "libxml2"
 check_pkg "stfl" || fail "stfl"
 check_pkg "json" || fail "json"
-check_custom "ncursesw5" "ncursesw5-config" || fail "ncursesw5"
 check_ssl_implementation
 all_aboard_the_fail_boat
+
+echo "CXXFLAGS+=$CPPFLAGS" >> config.mk
+echo "LDFLAGS+=$LDFLAGS" >> config.mk
diff --git a/src/controller.cpp b/src/controller.cpp
--- a/src/controller.cpp
+++ b/src/controller.cpp
@@ -879,8 +879,7 @@ void controller::notify(const std::string& msg) {
 		std::cout.flush();
 	}
 	if (cfg.get_configvalue_as_bool("notify-beep")) {
-		LOG(LOG_DEBUG, "controller:notify: notifying beep");
-		::beep();
+		LOG(LOG_DEBUG, "controller:notify: beep unsupported on this platform");
 	}
 	if (cfg.get_configvalue("notify-program").length() > 0) {
 		std::string prog = cfg.get_configvalue("notify-program");
@@ -931,7 +930,6 @@ void controller::version_information(const char * argv0, unsigned int level) {
 #if defined(__GNUC__) && defined(__VERSION__)
 		std::cout << "Compiler: g++ " << __VERSION__ << std::endl;
 #endif
-		std::cout << "ncurses: " << curses_version() << " (compiled with " << NCURSES_VERSION << ")" << std::endl;
 		std::cout << "libcurl: " << curl_version()  << " (compiled with " << LIBCURL_VERSION << ")" << std::endl;
 		std::cout << "SQLite: " << sqlite3_libversion() << " (compiled with " << SQLITE_VERSION << ")" << std::endl;
 		std::cout << "libxml2: compiled with " << LIBXML_DOTTED_VERSION << std::endl << std::endl;
diff --git a/src/ttrss_api.cpp b/src/ttrss_api.cpp
--- a/src/ttrss_api.cpp
+++ b/src/ttrss_api.cpp
@@ -220,7 +220,7 @@ rsspp::feed ttrss_api::fetch_feed(const std::string& id) {
 		const char * link = json_object_get_string(json_object_object_get(item_obj, "link"));
 		const char * content = json_object_get_string(json_object_object_get(item_obj, "content"));
 		time_t updated = (time_t)json_object_get_int(json_object_object_get(item_obj, "updated"));
-		boolean unread = json_object_get_boolean(json_object_object_get(item_obj, "unread"));
+		bool unread = json_object_get_boolean(json_object_object_get(item_obj, "unread"));
 
 		rsspp::item item;
 
diff --git a/src/view.cpp b/src/view.cpp
--- a/src/view.cpp
+++ b/src/view.cpp
@@ -1020,7 +1020,6 @@ void view::handle_cmdline_completion(std::tr1::shared_ptr<formaction> fa) {
 	switch (suggestions.size()) {
 		case 0:
 			LOG(LOG_DEBUG, "view::handle_cmdline_completion: found no suggestion for `%s'", fragment.c_str());
-			::beep(); // direct call to ncurses - we beep to signal that there is no suggestion available, just like vim
 			return;
 		case 1:
 			suggestion = suggestions[0];
