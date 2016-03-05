From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/12] xfs/206: fix output when mkfs knows about reflink
Date: Fri, 04 Mar 2016 16:37:50 -0800
Message-ID: <20160305003750.28738.48204.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org, xfs@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/206     |    1 +
 tests/xfs/206.out |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/tests/xfs/206 b/tests/xfs/206
index 0f5d97d..24e690a 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -80,6 +80,7 @@ mkfs_filter()
 	    -e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
 	    -e "s/, projid32bit=[0-9]//" \
 	    -e "s/ ftype=[0-9]//" \
+	    -e "s/ reflink=[0-9]//" \
 	    -e "s/\(sectsz\)\(=[0-9]* *\)/\1=512   /" \
 	    -e "s/\(sunit=\)\([0-9]* blks,\)/\10 blks,/" \
 	    -e "s/, lazy-count=[0-9]//" \
diff --git a/tests/xfs/206.out b/tests/xfs/206.out
index 2db839d..e73a954 100644
--- a/tests/xfs/206.out
+++ b/tests/xfs/206.out
@@ -12,6 +12,7 @@ realtime =none                   extsz=4096   blocks=0, rtextents=0
 === xfs_growfs ===
 meta-data=FILE isize=N    agcount=52, agsize=76288719 blks
          =                       sectsz=512   attr=2
+         =                      
 data     =                       bsize=4096   blocks=3905982455, imaxpct=5
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0
@@ -22,6 +23,7 @@ data blocks changed from 3905982455 to 4882478016
 === xfs_info ===
 meta-data=FILE isize=N    agcount=64, agsize=76288719 blks
          =                       sectsz=512   attr=2
+         =                      
 data     =                       bsize=4096   blocks=4882478016, imaxpct=5
          =                       sunit=0      swidth=0 blks
 naming   =version 2              bsize=4096   ascii-ci=0

