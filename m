From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/31] libext2fs: During punch,
 only free a cluster if we're sure that all blocks in the cluster are
 being punched
Date: Mon, 30 Sep 2013 18:29:03 -0700
Message-ID: <20131001012903.28415.39499.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22747 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3JAB3H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:29:07 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When bigalloc is enabled, using ext2fs_block_alloc_stats2() to free any block
in a cluster has the effect of freeing the entire cluster.  This is problematic
if a caller instructs us to punch, say, blocks 12-15 of a 16-block cluster,
because blocks 0-11 now point to a "free" cluster.

The naive way to solve this problem is to see if any of the other blocks in
this logical cluster map to a physical cluster.  If so, then we know that the
cluster is still in use and it mustn't be freed.  Otherwise, we are punching
the last mapped block in this cluster, so we can free the cluster.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/bmap.c   |   28 ++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h |    3 +++
 lib/ext2fs/punch.c  |   30 +++++++++++++++++++++++++-----
 3 files changed, 56 insertions(+), 5 deletions(-)


diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 5074587..a6e35a9 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -173,6 +173,34 @@ static errcode_t implied_cluster_alloc(ext2_filsys fs, ext2_ino_t ino,
 	return 0;
 }
 
+errcode_t ext2fs_map_cluster_block(ext2_filsys fs, ext2_ino_t ino,
+				   struct ext2_inode *inode, blk64_t lblk,
+				   blk64_t *pblk)
+{
+	ext2_extent_handle_t handle;
+	errcode_t retval;
+
+	/* Need bigalloc and extents to be enabled */
+	*pblk = 0;
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_BIGALLOC) ||
+	    !(inode->i_flags & EXT4_EXTENTS_FL))
+		return 0;
+
+	retval = ext2fs_extent_open2(fs, ino, inode, &handle);
+	if (retval)
+		goto out;
+
+	retval = implied_cluster_alloc(fs, ino, inode, handle, lblk, pblk);
+	if (retval)
+		goto out2;
+
+out2:
+	ext2fs_extent_free(handle);
+out:
+	return retval;
+}
+
 static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
 			     struct ext2_inode *inode,
 			     ext2_extent_handle_t handle,
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9fef6d3..88da8db 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -925,6 +925,9 @@ extern errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino,
 			      struct ext2_inode *inode,
 			      char *block_buf, int bmap_flags, blk64_t block,
 			      int *ret_flags, blk64_t *phys_blk);
+errcode_t ext2fs_map_cluster_block(ext2_filsys fs, ext2_ino_t ino,
+				   struct ext2_inode *inode, blk64_t lblk,
+				   blk64_t *pblk);
 
 #if 0
 /* bmove.c */
diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 4471f46..e0193b0 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -183,8 +183,8 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 	ext2_extent_handle_t	handle = 0;
 	struct ext2fs_extent	extent;
 	errcode_t		retval;
-	blk64_t			free_start, next;
-	__u32			free_count, newlen;
+	blk64_t			free_start, next, lfree_start, pblk;
+	__u32			free_count, newlen, cluster_freed;
 	int			freed = 0;
 	int			op;
 
@@ -210,6 +210,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 			/* Start of deleted region before extent; 
 			   adjust beginning of extent */
 			free_start = extent.e_pblk;
+			lfree_start = extent.e_lblk;
 			if (next > end)
 				free_count = end - extent.e_lblk + 1;
 			else
@@ -225,6 +226,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 			dbg_printf("Case #%d\n", 2);
 			newlen = start - extent.e_lblk;
 			free_start = extent.e_pblk + newlen;
+			lfree_start = extent.e_lblk + newlen;
 			free_count = extent.e_len - newlen;
 			extent.e_len = newlen;
 		} else {
@@ -240,6 +242,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 
 			extent.e_len = start - extent.e_lblk;
 			free_start = extent.e_pblk + extent.e_len;
+			lfree_start = extent.e_lblk + extent.e_len;
 			free_count = end - start + 1;
 
 			dbg_print_extent("inserting", &newex);
@@ -280,9 +283,26 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 			goto errout;
 		dbg_printf("Free start %llu, free count = %u\n",
 		       free_start, free_count);
-		while (free_count-- > 0) {
-			ext2fs_block_alloc_stats2(fs, free_start++, -1);
-			freed++;
+		while (free_count > 0) {
+			retval = ext2fs_map_cluster_block(fs, ino, inode,
+							  lfree_start, &pblk);
+			if (retval)
+				goto errout;
+			if (!pblk) {
+				ext2fs_block_alloc_stats2(fs, free_start, -1);
+				freed++;
+				cluster_freed = EXT2FS_CLUSTER_RATIO(fs) -
+					(free_start & EXT2FS_CLUSTER_MASK(fs));
+				if (cluster_freed > free_count)
+					cluster_freed = free_count;
+				free_count -= cluster_freed;
+				free_start += cluster_freed;
+				lfree_start += cluster_freed;
+				continue;
+			}
+			free_count--;
+			free_start++;
+			lfree_start++;
 		}
 	next_extent:
 		retval = ext2fs_extent_get(handle, op,

