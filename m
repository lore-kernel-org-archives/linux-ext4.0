From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/12] xfs/030: fix output on newer filesystems
Date: Fri, 04 Mar 2016 16:37:56 -0800
Message-ID: <20160305003756.28738.26362.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/030           |    5 ++++-
 tests/xfs/030.out.linux |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/030 b/tests/xfs/030
index 4cb1524..33c906c 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -57,7 +57,10 @@ _check_ag()
 		echo "Corrupting $structure - setting bits to $1"
 		_check_repair $1 "$structure" |
 			sed -e '/^error following ag 0 unlinked list$/d' \
-			    -e '/^bad agbno AGBNO for finobt/d'
+			    -e '/^bad agbno AGBNO for finobt/d' \
+			    -e '/^bad agbno AGBNO for rmapbt/d' \
+			    -e '/^bad agbno AGBNO for refcntbt/d' \
+			    -e '/^Missing reverse-mapping record.*/d'
 	done
 }
 
diff --git a/tests/xfs/030.out.linux b/tests/xfs/030.out.linux
index cf3259f..14b9b35 100644
--- a/tests/xfs/030.out.linux
+++ b/tests/xfs/030.out.linux
@@ -231,6 +231,8 @@ bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
+bad agbno AGBNO in agfl, agno 0
+bad agbno AGBNO in agfl, agno 0
         - found root inode chunk
 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
