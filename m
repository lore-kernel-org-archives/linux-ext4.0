From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/11] xfs/129: require loop
Date: Sat, 19 Dec 2015 01:11:25 -0800
Message-ID: <20151219091125.15320.31598.stgit@birch.djwong.org>
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

Missed a _require_loop for xfs/129.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/129 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/129 b/tests/xfs/129
index 6fb9bac..c8c47a2 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -46,6 +46,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
+_require_loop
 _require_scratch_reflink
 
 rm -f "$seqres.full"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
