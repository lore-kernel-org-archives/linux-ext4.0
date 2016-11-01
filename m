From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v9 15/16] xfs: use struct iomap based DAX PMD fault path
Date: Tue,  1 Nov 2016 13:54:17 -0600
Message-ID: <1478030058-1422-16-git-send-email-ross.zwisler@linux.intel.com>
References: <1478030058-1422-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1478030058-1422-1-git-send-email-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

Switch xfs_filemap_pmd_fault() from using dax_pmd_fault() to the new and
improved dax_iomap_pmd_fault().  Also, now that it has no more users,
remove xfs_get_blocks_dax_fault().

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/xfs/xfs_aops.c | 26 +++++---------------------
 fs/xfs/xfs_aops.h |  3 ---
 fs/xfs/xfs_file.c |  2 +-
 3 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3e57a56..561cf14 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1298,8 +1298,7 @@ __xfs_get_blocks(
 	sector_t		iblock,
 	struct buffer_head	*bh_result,
 	int			create,
-	bool			direct,
-	bool			dax_fault)
+	bool			direct)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1420,13 +1419,8 @@ __xfs_get_blocks(
 		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
 		/* direct IO needs special help */
-		if (create) {
-			if (dax_fault)
-				ASSERT(!ISUNWRITTEN(&imap));
-			else
-				xfs_map_direct(inode, bh_result, &imap, offset,
-						is_cow);
-		}
+		if (create)
+			xfs_map_direct(inode, bh_result, &imap, offset, is_cow);
 	}
 
 	/*
@@ -1466,7 +1460,7 @@ xfs_get_blocks(
 	struct buffer_head	*bh_result,
 	int			create)
 {
-	return __xfs_get_blocks(inode, iblock, bh_result, create, false, false);
+	return __xfs_get_blocks(inode, iblock, bh_result, create, false);
 }
 
 int
@@ -1476,17 +1470,7 @@ xfs_get_blocks_direct(
 	struct buffer_head	*bh_result,
 	int			create)
 {
-	return __xfs_get_blocks(inode, iblock, bh_result, create, true, false);
-}
-
-int
-xfs_get_blocks_dax_fault(
-	struct inode		*inode,
-	sector_t		iblock,
-	struct buffer_head	*bh_result,
-	int			create)
-{
-	return __xfs_get_blocks(inode, iblock, bh_result, create, true, true);
+	return __xfs_get_blocks(inode, iblock, bh_result, create, true);
 }
 
 /*
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index b3c6634..34dc00d 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -59,9 +59,6 @@ int	xfs_get_blocks(struct inode *inode, sector_t offset,
 		       struct buffer_head *map_bh, int create);
 int	xfs_get_blocks_direct(struct inode *inode, sector_t offset,
 			      struct buffer_head *map_bh, int create);
-int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
-			         struct buffer_head *map_bh, int create);
-
 int	xfs_end_io_direct_write(struct kiocb *iocb, loff_t offset,
 		ssize_t size, void *private);
 int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8ce5d3f..d818c16 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1545,7 +1545,7 @@ xfs_filemap_pmd_fault(
 	}
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	ret = dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault);
+	ret = dax_iomap_pmd_fault(vma, addr, pmd, flags, &xfs_iomap_ops);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (flags & FAULT_FLAG_WRITE)
-- 
2.7.4
