From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/12] xfs/207: fix golden output to match FS_IOC_FSSETXATTR
 hoist
Date: Fri, 04 Mar 2016 16:37:24 -0800
Message-ID: <20160305003724.28738.94718.stgit@birch.djwong.org>
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
 tests/xfs/207.out |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/207.out b/tests/xfs/207.out
index 14eede4..434b8d9 100644
--- a/tests/xfs/207.out
+++ b/tests/xfs/207.out
@@ -3,7 +3,7 @@ Format and mount
 Create the original files
 Set extsz and cowextsz on zero byte file
 Set extsz and cowextsz on 1Mbyte file
-xfs_io: XFS_IOC_FSSETXATTR SCRATCH_MNT/test-207/file2: Invalid argument
+xfs_io: FS_IOC_FSSETXATTR SCRATCH_MNT/test-207/file2: Invalid argument
 Check extsz and cowextsz settings on zero byte file
 [1048576] SCRATCH_MNT/test-207/file1
 [1048576] SCRATCH_MNT/test-207/file1
@@ -11,8 +11,8 @@ Check extsz and cowextsz settings on 1Mbyte file
 [0] SCRATCH_MNT/test-207/file2
 [1048576] SCRATCH_MNT/test-207/file2
 Set cowextsize and check flag
-fsxattr.xflags = 0x20000 [---------------C]
+fsxattr.xflags = 0x20000 [----------------C]
 [1048576] SCRATCH_MNT/test-207/file3
 Unset cowextsize and check flag
-fsxattr.xflags = 0x0 [----------------]
+fsxattr.xflags = 0x0 [-----------------]
 [0] SCRATCH_MNT/test-207/file3

