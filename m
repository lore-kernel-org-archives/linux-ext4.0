From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH v2 2/3] ext4: fix check for zero range support in ext4/001
Date: Mon, 21 Apr 2014 16:43:09 -0400
Message-ID: <20140421204309.GC960@wallace>
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

Ext4/001 fails when run on a file system that does not support byte range
zeroing.  For example, an EOPNOTSUPP failure occurs when the test is run
on a pre-3.15 extent-mapped file system.  The code in the test intended
to prevent this contains an apparent typo that results in a check for
fallocate() rather than zero range support.

v2: Use new wrapper function for the check.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/ext4/001 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/ext4/001 b/tests/ext4/001
index d575d9a..8239f0e 100755
--- a/tests/ext4/001
+++ b/tests/ext4/001
@@ -45,7 +45,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs ext4
 _supported_os Linux
-_require_xfs_io_falloc "fzero"
+_require_xfs_io_falloc_zero
 
 testfile=$TEST_DIR/001.$$
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
