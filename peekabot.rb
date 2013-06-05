require 'formula'

class Peekabot < Formula
  homepage 'http://www.peekabot.org/'
  url 'http://downloads.sourceforge.net/project/peekabot/peekabot/0.8.x/peekabot-0.8.6.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fpeekabot%2Ffiles%2Fpeekabot%2F0.8.x%2F'
  md5 '3b988da5467fd72fdb108b55696afbd3'

  depends_on 'boost'
  depends_on 'xerces-c'
  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'gtkmm'
  depends_on 'gtkglextmm'
  depends_on 'pangox-compat'

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      Lots of ambiguous references
    EOS
  end

  def patches
    DATA
  end

  def install
    inreplace 'configure', '-Wl,-R', '-Wl,-rpath,'
    
    ENV.append 'LDFLAGS', "-L/usr/local/lib -lboost_system-mt"    
    ENV.append 'CFLAGS', "-DBOOST_FILESYSTEM_VERSION=3"
    ENV.append 'CPPFLAGS', "-DBOOST_FILESYSTEM_VERSION=3"      
    ENV.append 'CXXFLAGS', "-DBOOST_FILESYSTEM_VERSION=3"      
    
    system "./configure", "--prefix=#{prefix}"

    system "make install"
  end

  def test
    system "peekabot -v"
  end
end

__END__
diff -bur ./src/actions/SetTransformation.cc ../peekabot-0.8.6/src/actions/SetTransformation.cc
--- ./src/actions/SetTransformation.cc  2010-11-18 18:35:36.000000000 +0000
+++ ../peekabot-0.8.6/src/actions/SetTransformation.cc  2013-06-05 09:28:47.000000000 +0100
@@ -8,6 +8,8 @@
  * http://www.boost.org/LICENSE_1_0.txt)
  */
 
+#include <Eigen/LU>
+
 #include <boost/math/fpclassify.hpp>
 #include <stdexcept>
 
diff -bur ./src/renderer/entities/OccupancyGrid2D.cc ../peekabot-0.8.6/src/renderer/entities/OccupancyGrid2D.cc
--- ./src/renderer/entities/OccupancyGrid2D.cc  2010-09-08 12:52:48.000000000 +0100
+++ ../peekabot-0.8.6/src/renderer/entities/OccupancyGrid2D.cc  2013-06-05 09:28:33.000000000 +0100
@@ -19,6 +19,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <Eigen/LU>
+
 #include <cmath>
 #include <cassert>
 #include <GL/glew.h>
