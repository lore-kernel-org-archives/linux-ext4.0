From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests: only run generic/300 on filesystems supporting
	fallocate()
Date: Fri, 23 Aug 2013 16:41:32 -0400
Message-ID: <20130823204132.GB3778@wallace>
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

Generic/300 fails when run on a test filesystem that does not support
fallocate(), as in the case of an ext4 filesystem created without the
extent feature.  It uses fio's falloc ioengine to generate part of its
I/O load.

Verify that the test filesystem supports fallocate() before proceeding
with the test.  Also, delete any pre-existing test output to avoid
confusion with old results.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/300 |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/generic/300 b/tests/generic/300
index 7c60728..1ac763b 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -43,6 +43,9 @@ _supported_fs generic
 _supported_os Linux
 _need_to_be_root
 _require_scratch
+_require_xfs_io_falloc
+
+rm -f $seqres.full
 
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
