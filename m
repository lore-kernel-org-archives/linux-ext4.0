From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] xfstests: don't assume that falloc_punch implies falloc in
	test 255
Date: Tue,  5 Mar 2013 12:59:42 -0500
Message-ID: <1362506382-26974-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
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

As of Linux 3.9-rc1, ext4 will support the punch operation on file
systems using indirect blocks, but it can not support the fallocate
operation (since there is no way to mark a block as uninitialized
using indirect block scheme).  This caused test 255 to fail, since it
only used _require_xfS_io_falloc_punch assuming that all file systems
which supported punch can also support fallocate.  Fix this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 255 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/255 b/255
index 0083963..ae1d8e0 100755
--- a/255
+++ b/255
@@ -48,6 +48,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_xfs_io_falloc_punch
+_require_xfs_io_falloc
 _require_xfs_io_fiemap
 
 testfile=$TEST_DIR/255.$$
-- 
1.7.12.rc0.22.gcdd159b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
