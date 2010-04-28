From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: ext4: Do not dec quota for reserved blocks on error paths v2
Date: Wed, 28 Apr 2010 20:53:01 +0400
Message-ID: <87bpd3ecya.fsf@openvz.org>
References: <87633dcxhp.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57587 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab0D1QxH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Apr 2010 12:53:07 -0400
Received: by bwz19 with SMTP id 19so3417bwz.21
        for <linux-ext4@vger.kernel.org>; Wed, 28 Apr 2010 09:53:04 -0700 (PDT)
In-Reply-To: <87633dcxhp.fsf@openvz.org> (Dmitry Monakhov's message of "Tue,
	27 Apr 2010 08:47:46 +0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

If we have failed some where inside ext4_get_blocks() internals we may
have allocated some new blocks, which was not yet claimed to quota.
We have to free such blocks, but without touching quota. Quota will
be updated later on exit from ext4_get_blocks().
There are two possible ways to understand what we have to skip quota update:
1) Caller pass corresponding flag to ext4_free_blocks()
2) check that free_blocks() was indirectly called by get_blocks() 
   (i.e EXT4_I(inode)->i_delalloc_reserved_flag is set)
Second is simpler, but may result in unpredictable consequences later.
So i've chosen the first one, because caller must know which blocks it
is freeing.

Eric, please take your attention to metadata blocks handling when
you will work on new versing of  "ext4: don't use quota reservation for
speculative metadata blocks" patch.

The bug happens on heavily loaded node, or with 227'th xfstestcase and
result in incorrect i_blocks (less than expected). So truncation for
that file result in i_blocks overflow.
Seems this was the last bug which was easily triggered by 227'th testcase.


--=-=-=
Content-Disposition: inline;
 filename=0001-ext4-Do-not-drop-quota-for-reserved-blocks-on-error-.patch

>From 7c31f4f115edb3409aeb4dff66c360d70ecd7ec3 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Wed, 28 Apr 2010 20:20:19 +0400
Subject: [PATCH] ext4: Do not drop quota for reserved blocks on error paths v2

If we have failed some where inside ext4_get_blocks() internals we may
have allocated some new blocks, which was not yet claimed to quota.
We have to free such blocks, but without touching quota. Quota will
be updated later on exit from ext4_get_blocks().
The bug hapens on heavily loaded node.

Charges from v1:
 - Dectement i_allocated_meta_blocks for metadata blocks.
 - Add some sanity checks.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |   18 +++++++++++++-----
 fs/ext4/inode.c   |   37 +++++++++++++++++++------------------
 fs/ext4/mballoc.c |   32 ++++++++++++++++++++++++++++++--
 4 files changed, 63 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c69efb2..9fcd0a1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -401,6 +401,7 @@ struct ext4_new_group_data {
 #define EXT4_FREE_BLOCKS_METADATA	0x0001
 #define EXT4_FREE_BLOCKS_FORGET		0x0002
 #define EXT4_FREE_BLOCKS_VALIDATED	0x0004
+#define EXT4_FREE_BLOCKS_RESERVED	0x0008
 
 /*
  * ioctl commands
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6856272..46a6f7f 100644
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
@@ -3553,12 +3557,16 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
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
index e4e0a7d..6f0579b 100644
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
@@ -782,20 +787,17 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
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
@@ -821,6 +823,9 @@ static int ext4_splice_branch(handle_t *handle, struct inode *inode,
 	int i;
 	int err = 0;
 	ext4_fsblk_t current_block;
+	int fb_flags = 0;
+	if (EXT4_I(inode)->i_delalloc_reserved_flag)
+		fb_flags |= EXT4_FREE_BLOCKS_RESERVED;
 
 	/*
 	 * If we're splicing into a [td]indirect block (as opposed to the
@@ -874,16 +879,12 @@ static int ext4_splice_branch(handle_t *handle, struct inode *inode,
 
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
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3c27377..a2e9b40 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4635,11 +4635,39 @@ do_more:
 	}
 	sb->s_dirt = 1;
 error_return:
-	if (freed)
-		dquot_free_block(inode, freed);
+	if (freed) {
+		if (flags & EXT4_FREE_BLOCKS_RESERVED) {
+			/* Blocks was allocated, but not yet claimed to quota.
+			 * Skip quota update for this case.
+			 * Meta data blocks was charged to inode's mblock
+			 * alloc counter in ext4_new_meta_blocks(). Roll back
+			 * this counter.  */
+			if (flags & EXT4_FREE_BLOCKS_METADATA) {
+				spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+				if (EXT4_I(inode)->i_allocated_meta_blocks <
+					freed)
+					goto rsv_error;
+				EXT4_I(inode)->i_allocated_meta_blocks -= freed;
+				spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+			}
+		} else
+			dquot_free_block(inode, freed);
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


--=-=-=--
