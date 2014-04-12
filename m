From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] generic/004: fix filtering of expected error message
Date: Sat, 12 Apr 2014 18:55:15 -0400
Message-ID: <1397343317-14669-2-git-send-email-tytso@mit.edu>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1397343317-14669-1-git-send-email-tytso@mit.edu>
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

The failure message goes to stderr, so we need to redirect stderr to
stdout before running sed.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>
---
 tests/generic/004     | 2 +-
 tests/generic/004.out | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/004 b/tests/generic/004
index 406c29e..23ca349 100755
--- a/tests/generic/004
+++ b/tests/generic/004
@@ -58,7 +58,7 @@ $XFS_IO_PROG -T \
 rm ${testfile}
 
 # test creating a r/o tmpfile.  Should fail
-$XFS_IO_PROG -Tr ${TEST_DIR} -c "close" | _filter_test_dir
+$XFS_IO_PROG -Tr ${TEST_DIR} -c "close" 2>&1 | _filter_test_dir
 
 # success, all done
 status=0
diff --git a/tests/generic/004.out b/tests/generic/004.out
index b85c11c..527b2c2 100644
--- a/tests/generic/004.out
+++ b/tests/generic/004.out
@@ -3,4 +3,4 @@ wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 read 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-/mnt/test: Invalid argument
+TEST_DIR: Invalid argument
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
