From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] e2fsck: update quota when optimizing the extent tree
Date: Fri, 21 Apr 2017 16:06:00 -0400
Message-ID: <20170421200600.zvgjbblbrftvlfb4@thunk.org>
References: <20170415134118.17808-1-tytso@mit.edu>
 <20170416191739.GA5185@birch.djwong.org>
 <20170421073743.btwz6274h4ou3bze@thunk.org>
 <20170421162711.GA3972@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35446 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425897AbdDUUGF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Apr 2017 16:06:05 -0400
Content-Disposition: inline
In-Reply-To: <20170421162711.GA3972@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oops, Sorry.  Now with the corret version of the patch.

      	      	       	   	  - Ted

>From bc177d425d4fe33b0ae774b218b055465a840ca1 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sat, 15 Apr 2017 00:29:46 -0400
Subject: [PATCH] e2fsck: update quota when optimizing the extent tree

If quota is enabled, optimizing the extent tree wouldn't update the
in-memory quota statistics, so that a subsequent e2fsck run would show
that the quota usage statistics on disk were incorrect.

Google-Bug-Id: 36391645

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/extents.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/e2fsck/extents.c b/e2fsck/extents.c
index c4167e16..7f28e6dd 100644
--- a/e2fsck/extents.c
+++ b/e2fsck/extents.c
@@ -208,17 +208,19 @@ static int find_blocks(ext2_filsys fs, blk64_t *blocknr, e2_blkcnt_t blockcnt,
 static errcode_t rebuild_extent_tree(e2fsck_t ctx, struct extent_list *list,
 				     ext2_ino_t ino)
 {
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	errcode_t		retval;
 	ext2_extent_handle_t	handle;
 	unsigned int		i, ext_written;
 	struct ext2fs_extent	*ex, extent;
+	blk64_t			start_val, delta;
 
 	list->count = 0;
 	list->blocks_freed = 0;
 	list->ino = ino;
 	list->ext_read = 0;
-	e2fsck_read_inode(ctx, ino, &inode, "rebuild_extents");
+	e2fsck_read_inode_full(ctx, ino, EXT2_INODE(&inode), sizeof(inode),
+			       "rebuild_extents");
 
 	/* Skip deleted inodes and inline data files */
 	if (inode.i_links_count == 0 ||
@@ -248,16 +250,20 @@ extents_loaded:
 	memset(inode.i_block, 0, sizeof(inode.i_block));
 
 	/* Make a note of freed blocks */
-	retval = ext2fs_iblk_sub_blocks(ctx->fs, &inode, list->blocks_freed);
+	quota_data_sub(ctx->qctx, &inode, ino,
+		       list->blocks_freed * ctx->fs->blocksize);
+	retval = ext2fs_iblk_sub_blocks(ctx->fs, EXT2_INODE(&inode),
+					list->blocks_freed);
 	if (retval)
 		goto err;
 
 	/* Now stuff extents into the file */
-	retval = ext2fs_extent_open2(ctx->fs, ino, &inode, &handle);
+	retval = ext2fs_extent_open2(ctx->fs, ino, EXT2_INODE(&inode), &handle);
 	if (retval)
 		goto err;
 
 	ext_written = 0;
+	start_val = ext2fs_inode_i_blocks(ctx->fs, EXT2_INODE(&inode));
 	for (i = 0, ex = list->extents; i < list->count; i++, ex++) {
 		memcpy(&extent, ex, sizeof(struct ext2fs_extent));
 		extent.e_flags &= EXT2_EXTENT_FLAGS_UNINIT;
@@ -295,11 +301,21 @@ extents_loaded:
 		ext_written++;
 	}
 
+	delta = ext2fs_inode_i_blocks(ctx->fs, EXT2_INODE(&inode)) - start_val;
+	if (delta) {
+		if (!ext2fs_has_feature_huge_file(ctx->fs->super) ||
+		    !(inode.i_flags & EXT4_HUGE_FILE_FL))
+			delta <<= 9;
+		else
+			delta *= ctx->fs->blocksize;
+		quota_data_add(ctx->qctx, &inode, ino, delta);
+	}
+
 #if defined(DEBUG) || defined(DEBUG_SUMMARY)
 	printf("rebuild: ino=%d extents=%d->%d\n", ino, list->ext_read,
 	       ext_written);
 #endif
-	e2fsck_write_inode(ctx, ino, &inode, "rebuild_extents");
+	e2fsck_write_inode(ctx, ino, EXT2_INODE(&inode), "rebuild_extents");
 
 err2:
 	ext2fs_extent_free(handle);
-- 
2.11.0.rc0.7.gbe5a750
