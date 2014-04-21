From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH 1/3] xfstests: add helper for zero range support check
Date: Mon, 21 Apr 2014 16:40:23 -0400
Message-ID: <20140421204023.GB960@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

Add a helper function to verify fallocate zero range support in a style
similar to _require_xfs_io_falloc_collapse(), etc.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 common/rc | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/common/rc b/common/rc
index acf419b..bcda96a 100644
--- a/common/rc
+++ b/common/rc
@@ -1375,6 +1375,13 @@ _require_xfs_io_falloc_collapse()
 	_require_xfs_io_command "fcollapse"
 }
 
+# check that xfs_io, kernel, and filesystem all support fallocate with zero
+# range
+_require_xfs_io_falloc_zero()
+{
+	_require_xfs_io_command "fzero"
+}
+
 # check that xfs_io, kernel and filesystem support fiemap
 _require_xfs_io_fiemap()
 {
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
