From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] e2fsck: update quota when optimizing the extent tree
Date: Sat, 15 Apr 2017 09:41:16 -0400
Message-ID: <20170415134118.17808-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39904 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754157AbdDONl0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 15 Apr 2017 09:41:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If quota is enabled, optimizing the extent tree wouldn't update the
in-memory quota statistics, so that a subsequent e2fsck run would show
that the quota usage statistics on disk were incorrect.

Google-Bug-Id: 36391645

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/e2fsck.c  |  1 +
 e2fsck/e2fsck.h  |  1 +
 e2fsck/extents.c | 23 ++++++++++++++++++-----
 e2fsck/pass1.c   |  1 +
 4 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index 0f9da46a..4baedbac 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -169,6 +169,7 @@ errcode_t e2fsck_reset_context(e2fsck_t ctx)
 	ctx->fs_fragmented = 0;
 	ctx->fs_fragmented_dir = 0;
 	ctx->large_files = 0;
+	ctx->clusters_allocated = 0;
 
 	for (i=0; i < MAX_EXTENT_DEPTH_COUNT; i++)
 		ctx->extent_depth_count[i] = 0;
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index f3568106..ecd3b1e1 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -372,6 +372,7 @@ struct e2fsck_struct {
 	profile_t	profile;
 	int blocks_per_page;
 	ext2_u32_list encrypted_dirs;
+	__u32 clusters_allocated;
 
 	/* Reserve blocks for root and l+f re-creation */
 	blk64_t root_repair_block, lnf_repair_block;
diff --git a/e2fsck/extents.c b/e2fsck/extents.c
index c4167e16..1df31d71 100644
--- a/e2fsck/extents.c
+++ b/e2fsck/extents.c
@@ -208,17 +208,21 @@ static int find_blocks(ext2_filsys fs, blk64_t *blocknr, e2_blkcnt_t blockcnt,
 static errcode_t rebuild_extent_tree(e2fsck_t ctx, struct extent_list *list,
 				     ext2_ino_t ino)
 {
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
+	struct ext2_inode	*inode_ptr;
 	errcode_t		retval;
 	ext2_extent_handle_t	handle;
 	unsigned int		i, ext_written;
 	struct ext2fs_extent	*ex, extent;
+	__u32			start_val;
 
 	list->count = 0;
 	list->blocks_freed = 0;
 	list->ino = ino;
 	list->ext_read = 0;
-	e2fsck_read_inode(ctx, ino, &inode, "rebuild_extents");
+	inode_ptr = (struct ext2_inode *) &inode;
+	e2fsck_read_inode_full(ctx, ino, inode_ptr, sizeof(inode),
+			       "rebuild_extents");
 
 	/* Skip deleted inodes and inline data files */
 	if (inode.i_links_count == 0 ||
@@ -248,16 +252,19 @@ extents_loaded:
 	memset(inode.i_block, 0, sizeof(inode.i_block));
 
 	/* Make a note of freed blocks */
-	retval = ext2fs_iblk_sub_blocks(ctx->fs, &inode, list->blocks_freed);
+	quota_data_sub(ctx->qctx, &inode, ino,
+		       list->blocks_freed * ctx->fs->blocksize);
+	retval = ext2fs_iblk_sub_blocks(ctx->fs, inode_ptr, list->blocks_freed);
 	if (retval)
 		goto err;
 
 	/* Now stuff extents into the file */
-	retval = ext2fs_extent_open2(ctx->fs, ino, &inode, &handle);
+	retval = ext2fs_extent_open2(ctx->fs, ino, inode_ptr, &handle);
 	if (retval)
 		goto err;
 
 	ext_written = 0;
+	start_val = ctx->clusters_allocated;
 	for (i = 0, ex = list->extents; i < list->count; i++, ex++) {
 		memcpy(&extent, ex, sizeof(struct ext2fs_extent));
 		extent.e_flags &= EXT2_EXTENT_FLAGS_UNINIT;
@@ -295,11 +302,17 @@ extents_loaded:
 		ext_written++;
 	}
 
+	if (start_val != ctx->clusters_allocated) {
+		__u32 num = ctx->clusters_allocated - start_val;
+		quota_data_add(ctx->qctx, &inode, ino,
+			       num * ctx->fs->blocksize);
+	}
+
 #if defined(DEBUG) || defined(DEBUG_SUMMARY)
 	printf("rebuild: ino=%d extents=%d->%d\n", ino, list->ext_read,
 	       ext_written);
 #endif
-	e2fsck_write_inode(ctx, ino, &inode, "rebuild_extents");
+	e2fsck_write_inode(ctx, ino, inode_ptr, "rebuild_extents");
 
 err2:
 	ext2fs_extent_free(handle);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 188cc562..99e8f66a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -4017,6 +4017,7 @@ static errcode_t e2fsck_get_alloc_block(ext2_filsys fs, blk64_t goal,
 	}
 
 	*ret = new_block;
+	ctx->clusters_allocated++;
 	return (0);
 }
 
-- 
2.11.0.rc0.7.gbe5a750
