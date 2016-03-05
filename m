From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/12] xfs/122: support rmapxbt
Date: Fri, 04 Mar 2016 16:38:16 -0800
Message-ID: <20160305003815.28738.81125.stgit@birch.djwong.org>
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

Support the extended rmap btree key structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index c590166..451871e 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -77,8 +77,9 @@ sizeof(struct xfs_fs_eofblocks) = 128
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
-sizeof(struct xfs_rmap_key) = 20
+sizeof(struct xfs_rmap_key) = 4
 sizeof(struct xfs_rmap_rec) = 24
+sizeof(struct xfs_rmapx_key) = 20
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
 sizeof(xfs_agi_t) = 336

