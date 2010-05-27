From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: Do not update quota for reserved blocks on error paths v3
Date: Thu, 27 May 2010 15:17:10 +0400
Message-ID: <1274959030-8001-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62470 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab0E0LRR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 May 2010 07:17:17 -0400
Received: by fxm16 with SMTP id 16so68788fxm.19
        for <linux-ext4@vger.kernel.org>; Thu, 27 May 2010 04:17:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have failed some where inside ext4_get_blocks() internals we may
have allocated some new blocks, which was not yet claimed to quota.
We have to free such blocks, but without touching quota. Quota will
be updated later on exit from ext4_get_blocks().
The bug hapens on heavily loaded node.

Changes from v2:
 - After Eric's quota-patches metadata charged immediately to quota
   inside new_meta_blocks(), so we have to free quota credits regardless
   to BLOCKS_RESERVED flag.
Changes from v1:
 - Dectement i_allocated_meta_blocks for metadata blocks.
 - Add some sanity checks.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |   18 +++++++++++++-----
 fs/ext4/inode.c   |   40 ++++++++++++++++++++--------------------
 fs/ext4/mballoc.c |   41 +++++++++++++++++++++++++++++++++++++++--
 4 files changed, 73 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 60bd310..231b132 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -490,6 +490,7 @@ struct ext4_new_group_data {
 #define EXT4_FREE_BLOCKS_METADATA	0x0001
 #define EXT4_FREE_BLOCKS_FORGET		0x0002
 #define EXT4_FREE_BLOCKS_VALIDATED	0x0004
+#define EXT4_FREE_BLOCKS_RESERVED	0x0008
 
 /*
  * ioctl commands
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 377309c..e3cc230 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1057,11 +1057,15 @@ cleanup:
 
 	if (err) {
 		/* free all allocated blocks in error case */
+		int fb_flags = EXT4_FREE_BLOCKS_METADATA;
+		if (EXT4_I(inode)->i_delalloc_reserved_flag)
+			fb_flags |= EXT4_FREE_BLOCKS_RESERVED;
+
 		for (i = 0; i < depth; i++) {
 			if (!ablocks[i])
 				continue;
 			ext4_free_blocks(handle, inode, 0, ablocks[i], 1,
-					 EXT4_FREE_BLOCKS_METADATA);
+					 fb_flags);
 		}
 	}
 	kfree(ablocks);
@@ -3528,12 +3532,16 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	}
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
-		/* free data blocks we just allocated */
-		/* not a good idea to call discard here directly,
-		 * but otherwise we'd need to call it every free() */
+		int fb_flags = 0;
+		/* free data blocks we just allocated
+		 * Not a good idea to call discard here directly,
+		 * but otherwise we'd need to call it every free().
+		 * On delalloc blocks are not yet accounted to quota */
+		if (EXT4_I(inode)->i_delalloc_reserved_flag)
+			fb_flags = EXT4_FREE_BLOCKS_RESERVED;
 		ext4_discard_preallocations(inode);
 		ext4_free_blocks(handle, inode, 0, ext_pblock(&newex),
-				 ext4_ext_get_actual_len(&newex), 0);
+				 ext4_ext_get_actual_len(&newex), fb_flags);
 		goto out2;
 	}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 502b07d..c3b4443 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -591,7 +591,9 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 	int index = 0;
 	ext4_fsblk_t current_block = 0;
 	int ret = 0;
-
+	int fb_flags = EXT4_FREE_BLOCKS_METADATA;
+	if (EXT4_I(inode)->i_delalloc_reserved_flag)
+		fb_flags |= EXT4_FREE_BLOCKS_RESERVED;
 	/*
 	 * Here we try to allocate the requested multiple blocks at once,
 	 * on a best-effort basis.
@@ -686,7 +688,7 @@ allocated:
 	return ret;
 failed_out:
 	for (i = 0; i < index; i++)
-		ext4_free_blocks(handle, inode, 0, new_blocks[i], 1, 0);
+		ext4_free_blocks(handle, inode, 0, new_blocks[i], 1, fb_flags);
 	return ret;
 }
 
@@ -727,6 +729,9 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 	int num;
 	ext4_fsblk_t new_blocks[4];
 	ext4_fsblk_t current_block;
+	int fb_flags = 0;
+	if (EXT4_I(inode)->i_delalloc_reserved_flag)
+		fb_flags |= EXT4_FREE_BLOCKS_RESERVED;
 
 	num = ext4_alloc_blocks(handle, inode, iblock, goal, indirect_blks,
 				*blks, new_blocks, &err);
@@ -782,24 +787,20 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 	return err;
 failed:
 	/* Allocation failed, free what we already allocated */
-	ext4_free_blocks(handle, inode, 0, new_blocks[0], 1, 0);
+	ext4_free_blocks(handle, inode, 0, new_blocks[0], 1, fb_flags);
 	for (i = 1; i <= n ; i++) {
-		/*
-		 * branch[i].bh is newly allocated, so there is no
-		 * need to revoke the block, which is why we don't
-		 * need to set EXT4_FREE_BLOCKS_METADATA.
-		 */
 		ext4_free_blocks(handle, inode, 0, new_blocks[i], 1,
-				 EXT4_FREE_BLOCKS_FORGET);
+				fb_flags | EXT4_FREE_BLOCKS_METADATA |
+				EXT4_FREE_BLOCKS_FORGET);
 	}
 	for (i = n+1; i < indirect_blks; i++)
-		ext4_free_blocks(handle, inode, 0, new_blocks[i], 1, 0);
+		ext4_free_blocks(handle, inode, 0, new_blocks[i], 1,
+				fb_flags | EXT4_FREE_BLOCKS_METADATA);
 
-	ext4_free_blocks(handle, inode, 0, new_blocks[i], num, 0);
+	ext4_free_blocks(handle, inode, 0, new_blocks[i], num, fb_flags);
 
 	return err;
 }
-
 /**
  * ext4_splice_branch - splice the allocated branch onto inode.
  * @inode: owner
@@ -821,6 +822,9 @@ static int ext4_splice_branch(handle_t *handle, struct inode *inode,
 	int i;
 	int err = 0;
 	ext4_fsblk_t current_block;
+	int fb_flags = 0;
+	if (EXT4_I(inode)->i_delalloc_reserved_flag)
+		fb_flags |= EXT4_FREE_BLOCKS_RESERVED;
 
 	/*
 	 * If we're splicing into a [td]indirect block (as opposed to the
@@ -872,22 +876,18 @@ static int ext4_splice_branch(handle_t *handle, struct inode *inode,
 	}
 	return err;
 
+
 err_out:
 	for (i = 1; i <= num; i++) {
-		/*
-		 * branch[i].bh is newly allocated, so there is no
-		 * need to revoke the block, which is why we don't
-		 * need to set EXT4_FREE_BLOCKS_METADATA.
-		 */
 		ext4_free_blocks(handle, inode, where[i].bh, 0, 1,
-				 EXT4_FREE_BLOCKS_FORGET);
+				fb_flags | EXT4_FREE_BLOCKS_METADATA |
+				EXT4_FREE_BLOCKS_FORGET);
 	}
 	ext4_free_blocks(handle, inode, 0, le32_to_cpu(where[num].key),
-			 blks, 0);
+			 blks, fb_flags);
 
 	return err;
 }
-
 /*
  * The ext4_ind_map_blocks() function handles non-extents inodes
  * (i.e., using the traditional indirect/double-indirect i_blocks
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 12b3bc0..c87243b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4503,6 +4503,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_sb_info *sbi;
 	struct ext4_buddy e4b;
 	int err = 0;
+	int res_fl = flags & (EXT4_FREE_BLOCKS_RESERVED |
+				EXT4_FREE_BLOCKS_METADATA);
 	int ret;
 
 	if (bh) {
@@ -4682,11 +4684,46 @@ do_more:
 	}
 	sb->s_dirt = 1;
 error_return:
-	if (freed)
-		dquot_free_block(inode, freed);
+	/*  Update quotas */
+	if (freed) {
+		if (!(res_fl & EXT4_FREE_BLOCKS_RESERVED)) {
+			dquot_free_block(inode, freed);
+			goto out;
+		}
+		/* Blocks reserved case */
+		if (res_fl & EXT4_FREE_BLOCKS_METADATA) {
+			/*
+			 * Meta data blocks was charged to quota and to
+			 * inode's mblock alloc counter in
+			 * ext4_new_meta_blocks(). */
+			spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+			if (EXT4_I(inode)->i_allocated_meta_blocks <
+				freed)
+				goto rsv_error;
+			EXT4_I(inode)->i_allocated_meta_blocks -= freed;
+			spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+			dquot_free_block(inode, freed);
+		} else {
+			/* Data blocks allocated was reserved, but not yet
+			 * claimed to quota. Caller is responsibleo for
+			 * quota reservation update. */
+		}
+	}
+out:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
 	if (ac)
 		kmem_cache_free(ext4_ac_cachep, ac);
 	return;
+
+rsv_error:
+	ext4_msg(sb, KERN_ERR," inode %ld, reservation counters goes"
+		" inconsistent rsv_data=%u, rsv_mdata=%u, alloc_mblk=%u"
+		" freed=%lu", inode->i_ino,
+		EXT4_I(inode)->i_reserved_data_blocks,
+		EXT4_I(inode)->i_reserved_meta_blocks,
+		EXT4_I(inode)->i_allocated_meta_blocks, freed);
+	EXT4_I(inode)->i_allocated_meta_blocks = 0;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	goto out;
 }
-- 
1.6.6.1

