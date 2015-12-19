From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/11] xfs/128: allow larger margin for disk space usage
Date: Sat, 19 Dec 2015 01:11:18 -0800
Message-ID: <20151219091118.15320.82351.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
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

The free blocks count can vary from our calculations by up to 8% on a
1k-block filesystem, so permit that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/128 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/128 b/tests/xfs/128
index 49652cb..f461c1a 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -59,7 +59,7 @@ FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
 
 echo "Create the original file and reflink to file2, file3"
 BLKS=2000
-MARGIN=100
+MARGIN=160
 BLKSZ=65536
 REAL_BLKSZ="$(stat -f $TESTDIR -c '%S')"
 BLKSZ_FACTOR=$((BLKSZ / REAL_BLKSZ))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
