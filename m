From: Joe Perches <joe@perches.com>
Subject: [PATCH 9/9] ext4: Rename ext4_warning to ext4_warn and ext4_error to ext4_err
Date: Thu, 15 Mar 2012 17:07:37 -0700
Message-ID: <63e631fd75c084fa0f40d41f8f935cab2b46948d.1331856300.git.joe@perches.com>
References: <cover.1331856299.git.joe@perches.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:33116 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1032384Ab2CPAJg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Mar 2012 20:09:36 -0400
In-Reply-To: <cover.1331856299.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make the logging macros more like the current kernel logging style.

Neaten the macro definitions.
Align arguments and 80 column wrapping.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/balloc.c   |   22 ++++----
 fs/ext4/ext4.h     |    8 ++--
 fs/ext4/ialloc.c   |   32 ++++++------
 fs/ext4/indirect.c |    6 +-
 fs/ext4/inode.c    |   20 ++++----
 fs/ext4/mballoc.c  |   44 +++++++++---------
 fs/ext4/mmp.c      |   30 ++++++------
 fs/ext4/namei.c    |   66 +++++++++++++-------------
 fs/ext4/page-io.c  |   12 ++--
 fs/ext4/resize.c   |  133 +++++++++++++++++++++++++--------------------------
 fs/ext4/super.c    |   20 ++++----
 11 files changed, 194 insertions(+), 199 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 82f468f..c77446c 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -171,7 +171,7 @@ void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 	/* If checksum is bad mark all blocks used to prevent allocation
 	 * essentially implementing a per-group read-only flag. */
 	if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
-		ext4_error(sb, "Checksum bad for group %u", block_group);
+		ext4_err(sb, "Checksum bad for group %u", block_group);
 		ext4_free_group_clusters_set(sb, gdp, 0);
 		ext4_free_inodes_set(sb, gdp, 0);
 		ext4_itable_unused_set(sb, gdp, 0);
@@ -254,8 +254,8 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	if (block_group >= ngroups) {
-		ext4_error(sb, "block_group >= groups_count - block_group = %u, groups_count = %u",
-			   block_group, ngroups);
+		ext4_err(sb, "block_group >= groups_count - block_group = %u, groups_count = %u",
+			 block_group, ngroups);
 
 		return NULL;
 	}
@@ -263,8 +263,8 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 	group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
 	offset = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
 	if (!sbi->s_group_desc[group_desc]) {
-		ext4_error(sb, "Group descriptor not loaded - block_group = %u, group_desc = %u, desc = %u",
-			   block_group, group_desc, offset);
+		ext4_err(sb, "Group descriptor not loaded - block_group = %u, group_desc = %u, desc = %u",
+			 block_group, group_desc, offset);
 		return NULL;
 	}
 
@@ -322,8 +322,8 @@ static int ext4_valid_block_bitmap(struct super_block *sb,
 		return 1;
 
 err_out:
-	ext4_error(sb, "Invalid block bitmap - block_group = %d, block = %llu",
-		   block_group, bitmap_blk);
+	ext4_err(sb, "Invalid block bitmap - block_group = %d, block = %llu",
+		 block_group, bitmap_blk);
 	return 0;
 }
 /**
@@ -349,8 +349,8 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
 	bitmap_blk = ext4_block_bitmap(sb, desc);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
-		ext4_error(sb, "Cannot get buffer for block bitmap - block_group = %u, block_bitmap = %llu",
-			   block_group, bitmap_blk);
+		ext4_err(sb, "Cannot get buffer for block bitmap - block_group = %u, block_bitmap = %llu",
+			 block_group, bitmap_blk);
 		return NULL;
 	}
 
@@ -405,8 +405,8 @@ int ext4_wait_block_bitmap(struct super_block *sb, ext4_group_t block_group,
 		return 1;
 	wait_on_buffer(bh);
 	if (!buffer_uptodate(bh)) {
-		ext4_error(sb, "Cannot read block bitmap - block_group = %u, block_bitmap = %llu",
-			   block_group, (unsigned long long) bh->b_blocknr);
+		ext4_err(sb, "Cannot read block bitmap - block_group = %u, block_bitmap = %llu",
+			 block_group, (unsigned long long) bh->b_blocknr);
 		return 1;
 	}
 	clear_buffer_new(bh);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2aaf549..348df50 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1960,8 +1960,8 @@ extern void ext4_kvfree(void *ptr);
 extern __printf(4, 5)
 void __ext4_error(struct super_block *, const char *, unsigned int,
 		  const char *, ...);
-#define ext4_error(sb, message...)	__ext4_error(sb, __func__,	\
-						     __LINE__, ## message)
+#define ext4_err(sb, fmt, ...)	\
+	__ext4_error(sb, __func__, __LINE__, fmt, ##__VA_ARGS__)
 extern __printf(5, 6)
 void ext4_error_inode(struct inode *, const char *, unsigned int, ext4_fsblk_t,
 		      const char *, ...);
@@ -1978,8 +1978,8 @@ void __ext4_abort(struct super_block *, const char *, unsigned int,
 extern __printf(4, 5)
 void __ext4_warning(struct super_block *, const char *, unsigned int,
 		    const char *, ...);
-#define ext4_warning(sb, message...)	__ext4_warning(sb, __func__, \
-						       __LINE__, ## message)
+#define ext4_warn(sb, fmt, ...)						\
+	__ext4_warning(sb, __func__, __LINE__, fmt, ##__VA_ARGS__)
 extern __printf(3, 4)
 void ext4_msg(struct super_block *, const char *, const char *, ...);
 extern void __dump_mmp_msg(struct super_block *, struct mmp_struct *mmp,
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 29cbd9f..f4522eb 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -79,7 +79,7 @@ static unsigned ext4_init_inode_bitmap(struct super_block *sb,
 	/* If checksum is bad mark all blocks and inodes use to prevent
 	 * allocation, essentially implementing a per-group read-only flag. */
 	if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
-		ext4_error(sb, "Checksum bad for group %u", block_group);
+		ext4_err(sb, "Checksum bad for group %u", block_group);
 		ext4_free_group_clusters_set(sb, gdp, 0);
 		ext4_free_inodes_set(sb, gdp, 0);
 		ext4_itable_unused_set(sb, gdp, 0);
@@ -124,8 +124,8 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 	bitmap_blk = ext4_inode_bitmap(sb, desc);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
-		ext4_error(sb, "Cannot read inode bitmap - block_group = %u, inode_bitmap = %llu",
-			   block_group, bitmap_blk);
+		ext4_err(sb, "Cannot read inode bitmap - block_group = %u, inode_bitmap = %llu",
+			 block_group, bitmap_blk);
 		return NULL;
 	}
 	if (bitmap_uptodate(bh))
@@ -167,8 +167,8 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 	wait_on_buffer(bh);
 	if (!buffer_uptodate(bh)) {
 		put_bh(bh);
-		ext4_error(sb, "Cannot read inode bitmap - block_group = %u, inode_bitmap = %llu",
-			   block_group, bitmap_blk);
+		ext4_err(sb, "Cannot read inode bitmap - block_group = %u, inode_bitmap = %llu",
+			 block_group, bitmap_blk);
 		return NULL;
 	}
 	return bh;
@@ -239,7 +239,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 
 	es = EXT4_SB(sb)->s_es;
 	if (ino < EXT4_FIRST_INO(sb) || ino > le32_to_cpu(es->s_inodes_count)) {
-		ext4_error(sb, "reserved or nonexistent inode %lu", ino);
+		ext4_err(sb, "reserved or nonexistent inode %lu", ino);
 		goto error_return;
 	}
 	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
@@ -294,7 +294,7 @@ out:
 			fatal = err;
 		ext4_mark_super_dirty(sb);
 	} else
-		ext4_error(sb, "bit already cleared for inode %lu", ino);
+		ext4_err(sb, "bit already cleared for inode %lu", ino);
 
 error_return:
 	brelse(bitmap_bh);
@@ -688,8 +688,8 @@ repeat_in_this_group:
 			continue;
 		}
 		if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
-			ext4_error(sb, "reserved inode found cleared - inode=%lu",
-				   ino + 1);
+			ext4_err(sb, "reserved inode found cleared - inode=%lu",
+				 ino + 1);
 			continue;
 		}
 		ext4_lock_group(sb, group);
@@ -922,7 +922,7 @@ struct inode *ext4_orphan_get(struct super_block *sb, unsigned long ino)
 
 	/* Error cases - e2fsck has already cleaned up for us */
 	if (ino > max_ino) {
-		ext4_warning(sb, "bad orphan ino %lu!  e2fsck was run?", ino);
+		ext4_warn(sb, "bad orphan ino %lu!  e2fsck was run?", ino);
 		goto error;
 	}
 
@@ -930,7 +930,7 @@ struct inode *ext4_orphan_get(struct super_block *sb, unsigned long ino)
 	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
 	bitmap_bh = ext4_read_inode_bitmap(sb, block_group);
 	if (!bitmap_bh) {
-		ext4_warning(sb, "inode bitmap error for orphan %lu", ino);
+		ext4_warn(sb, "inode bitmap error for orphan %lu", ino);
 		goto error;
 	}
 
@@ -962,7 +962,7 @@ iget_failed:
 	err = PTR_ERR(inode);
 	inode = NULL;
 bad_orphan:
-	ext4_warning(sb, "bad orphan inode %lu!  e2fsck was run?", ino);
+	ext4_warn(sb, "bad orphan inode %lu!  e2fsck was run?", ino);
 	pr_notice("ext4_test_bit(bit=%d, block=%llu) = %d\n",
 		  bit, (unsigned long long)bitmap_bh->b_blocknr,
 		  ext4_test_bit(bit, bitmap_bh->b_data));
@@ -1098,10 +1098,10 @@ int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 			    sbi->s_inodes_per_block);
 
 	if ((used_blks < 0) || (used_blks > sbi->s_itb_per_group)) {
-		ext4_error(sb, "Something is wrong with group %u\n"
-			   "Used itable blocks: %d itable unused count: %u",
-			   group, used_blks,
-			   ext4_itable_unused_count(sb, gdp));
+		ext4_err(sb, "Something is wrong with group %u\n"
+			 "Used itable blocks: %d itable unused count: %u",
+			 group, used_blks,
+			 ext4_itable_unused_count(sb, gdp));
 		ret = 1;
 		goto err_out;
 	}
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index bd02261..db428a0 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -101,9 +101,9 @@ static int ext4_block_to_path(struct inode *inode,
 		offsets[n++] = i_block & (ptrs - 1);
 		final = ptrs;
 	} else {
-		ext4_warning(inode->i_sb, "block %lu > max in inode %lu",
-			     i_block + direct_blocks +
-			     indirect_blocks + double_blocks, inode->i_ino);
+		ext4_warn(inode->i_sb, "block %lu > max in inode %lu",
+			  i_block + direct_blocks +
+			  indirect_blocks + double_blocks, inode->i_ino);
 	}
 	if (boundary)
 		*boundary = final - 1 - (i_block & (ptrs - 1));
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2fbfee2..29e2f29 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -185,8 +185,8 @@ void ext4_evict_inode(struct inode *inode)
 	inode->i_size = 0;
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
-		ext4_warning(inode->i_sb,
-			     "couldn't mark inode dirty (err %d)", err);
+		ext4_warn(inode->i_sb,
+			  "couldn't mark inode dirty (err %d)", err);
 		goto stop_handle;
 	}
 	if (inode->i_blocks)
@@ -203,8 +203,8 @@ void ext4_evict_inode(struct inode *inode)
 		if (err > 0)
 			err = ext4_journal_restart(handle, 3);
 		if (err != 0) {
-			ext4_warning(inode->i_sb,
-				     "couldn't extend journal (err %d)", err);
+			ext4_warn(inode->i_sb,
+				  "couldn't extend journal (err %d)", err);
 		stop_handle:
 			ext4_journal_stop(handle);
 			ext4_orphan_del(NULL, inode);
@@ -1578,9 +1578,9 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 		ext4_update_i_disksize(mpd->inode, disksize);
 		err = ext4_mark_inode_dirty(handle, mpd->inode);
 		if (err)
-			ext4_error(mpd->inode->i_sb,
-				   "Failed to mark inode %lu dirty",
-				   mpd->inode->i_ino);
+			ext4_err(mpd->inode->i_sb,
+				 "Failed to mark inode %lu dirty",
+				 mpd->inode->i_ino);
 	}
 
 submit_io:
@@ -4442,9 +4442,9 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 						     EXT4_STATE_NO_EXPAND);
 				if (mnt_count !=
 					le16_to_cpu(sbi->s_es->s_mnt_count)) {
-					ext4_warning(inode->i_sb,
-					"Unable to expand inode %lu. Delete some EAs or run e2fsck.",
-					inode->i_ino);
+					ext4_warn(inode->i_sb,
+						  "Unable to expand inode %lu. Delete some EAs or run e2fsck.",
+						  inode->i_ino);
 					mnt_count =
 					  le16_to_cpu(sbi->s_es->s_mnt_count);
 				}
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 185cbac..064c557 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2758,8 +2758,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 
 	len = EXT4_C2B(sbi, ac->ac_b_ex.fe_len);
 	if (!ext4_data_block_valid(sbi, block, len)) {
-		ext4_error(sb, "Allocating blocks %llu-%llu which overlap fs metadata",
-			   block, block + len);
+		ext4_err(sb, "Allocating blocks %llu-%llu which overlap fs metadata",
+			 block, block + len);
 		/* File system mounted not to panic on error
 		 * Fix the bitmap and repeat the block allocation
 		 * We leak some of the blocks here.
@@ -3656,13 +3656,13 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 
 	bitmap_bh = ext4_read_block_bitmap(sb, group);
 	if (bitmap_bh == NULL) {
-		ext4_error(sb, "Error reading block bitmap for %u", group);
+		ext4_err(sb, "Error reading block bitmap for %u", group);
 		return 0;
 	}
 
 	err = ext4_mb_load_buddy(sb, group, &e4b);
 	if (err) {
-		ext4_error(sb, "Error loading buddy information for %u", group);
+		ext4_err(sb, "Error loading buddy information for %u", group);
 		put_bh(bitmap_bh);
 		return 0;
 	}
@@ -3825,15 +3825,15 @@ repeat:
 
 		err = ext4_mb_load_buddy(sb, group, &e4b);
 		if (err) {
-			ext4_error(sb, "Error loading buddy information for %u",
-				   group);
+			ext4_err(sb, "Error loading buddy information for %u",
+				 group);
 			continue;
 		}
 
 		bitmap_bh = ext4_read_block_bitmap(sb, group);
 		if (bitmap_bh == NULL) {
-			ext4_error(sb, "Error reading block bitmap for %u",
-				   group);
+			ext4_err(sb, "Error reading block bitmap for %u",
+				 group);
 			ext4_mb_unload_buddy(&e4b);
 			continue;
 		}
@@ -4081,8 +4081,8 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
 
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
 		if (ext4_mb_load_buddy(sb, group, &e4b)) {
-			ext4_error(sb, "Error loading buddy information for %u",
-				   group);
+			ext4_err(sb, "Error loading buddy information for %u",
+				 group);
 			continue;
 		}
 		ext4_lock_group(sb, group);
@@ -4488,8 +4488,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	sbi = EXT4_SB(sb);
 	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
 	    !ext4_data_block_valid(sbi, block, count)) {
-		ext4_error(sb, "Freeing blocks not in datazone - block = %llu, count = %lu",
-			   block, count);
+		ext4_err(sb, "Freeing blocks not in datazone - block = %llu, count = %lu",
+			 block, count);
 		goto error_return;
 	}
 
@@ -4587,8 +4587,8 @@ do_more:
 	    in_range(block + count - 1, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group)) {
 
-		ext4_error(sb, "Freeing blocks in system zone - Block = %llu, count = %lu",
-			   block, count);
+		ext4_err(sb, "Freeing blocks in system zone - Block = %llu, count = %lu",
+			 block, count);
 		/* err = 0. ext4_std_error should be a no op */
 		goto error_return;
 	}
@@ -4725,8 +4725,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	 * boundary.
 	 */
 	if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) {
-		ext4_warning(sb, "too much blocks added to group %u\n",
-			     block_group);
+		ext4_warn(sb, "too much blocks added to group %u\n",
+			  block_group);
 		err = -EINVAL;
 		goto error_return;
 	}
@@ -4748,8 +4748,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
 	    in_range(block + count - 1, ext4_inode_table(sb, desc),
 		     sbi->s_itb_per_group)) {
-		ext4_error(sb, "Adding blocks in system zones - Block = %llu, count = %lu",
-			   block, count);
+		ext4_err(sb, "Adding blocks in system zones - Block = %llu, count = %lu",
+			 block, count);
 		err = -EINVAL;
 		goto error_return;
 	}
@@ -4772,8 +4772,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	for (i = 0, blocks_freed = 0; i < count; i++) {
 		BUFFER_TRACE(bitmap_bh, "clear bit");
 		if (!mb_test_bit(bit + i, bitmap_bh->b_data)) {
-			ext4_error(sb, "bit already cleared for block %llu",
-				   (ext4_fsblk_t)(block + i));
+			ext4_err(sb, "bit already cleared for block %llu",
+				 (ext4_fsblk_t)(block + i));
 			BUFFER_TRACE(bitmap_bh, "bit already cleared");
 		} else {
 			blocks_freed++;
@@ -4891,8 +4891,8 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 
 	ret = ext4_mb_load_buddy(sb, group, &e4b);
 	if (ret) {
-		ext4_error(sb, "Error in loading buddy information for %u",
-			   group);
+		ext4_err(sb, "Error in loading buddy information for %u",
+			 group);
 		return ret;
 	}
 	bitmap = e4b.bd_bitmap;
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 1767b2a..9aba1b4 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -53,8 +53,7 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 		}
 	}
 	if (!*bh) {
-		ext4_warning(sb, "Error while reading MMP block %llu",
-			     mmp_block);
+		ext4_warn(sb, "Error while reading MMP block %llu", mmp_block);
 		return -EIO;
 	}
 
@@ -126,19 +125,19 @@ static int kmmpd(void *data)
 		 */
 		if (retval) {
 			if ((failed_writes % 60) == 0)
-				ext4_error(sb, "Error writing to MMP block");
+				ext4_err(sb, "Error writing to MMP block");
 			failed_writes++;
 		}
 
 		if (!(le32_to_cpu(es->s_feature_incompat) &
 		    EXT4_FEATURE_INCOMPAT_MMP)) {
-			ext4_warning(sb, "kmmpd being stopped since MMP feature has been disabled");
+			ext4_warn(sb, "kmmpd being stopped since MMP feature has been disabled");
 			EXT4_SB(sb)->s_mmp_tsk = NULL;
 			goto failed;
 		}
 
 		if (sb->s_flags & MS_RDONLY) {
-			ext4_warning(sb, "kmmpd being stopped since filesystem has been remounted as readonly");
+			ext4_warn(sb, "kmmpd being stopped since filesystem has been remounted as readonly");
 			EXT4_SB(sb)->s_mmp_tsk = NULL;
 			goto failed;
 		}
@@ -160,8 +159,8 @@ static int kmmpd(void *data)
 
 			retval = read_mmp_block(sb, &bh_check, mmp_block);
 			if (retval) {
-				ext4_error(sb, "error reading MMP data: %d",
-					   retval);
+				ext4_err(sb, "error reading MMP data: %d",
+					 retval);
 
 				EXT4_SB(sb)->s_mmp_tsk = NULL;
 				goto failed;
@@ -175,7 +174,7 @@ static int kmmpd(void *data)
 					     "Error while updating MMP info. "
 					     "The filesystem seems to have been"
 					     " multiply mounted.");
-				ext4_error(sb, "abort");
+				ext4_err(sb, "abort");
 				goto failed;
 			}
 			put_bh(bh_check);
@@ -237,7 +236,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 
 	if (mmp_block < le32_to_cpu(es->s_first_data_block) ||
 	    mmp_block >= ext4_blocks_count(es)) {
-		ext4_warning(sb, "Invalid MMP block in superblock");
+		ext4_warn(sb, "Invalid MMP block in superblock");
 		goto failed;
 	}
 
@@ -271,11 +270,11 @@ int ext4_multi_mount_protect(struct super_block *sb,
 
 	/* Print MMP interval if more than 20 secs. */
 	if (wait_time > EXT4_MMP_MIN_CHECK_INTERVAL * 4)
-		ext4_warning(sb, "MMP interval %u higher than expected, please wait",
-			     wait_time * 2);
+		ext4_warn(sb, "MMP interval %u higher than expected, please wait",
+			  wait_time * 2);
 
 	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
-		ext4_warning(sb, "MMP startup interrupted, failing mount");
+		ext4_warn(sb, "MMP startup interrupted, failing mount");
 		goto failed;
 	}
 
@@ -304,7 +303,7 @@ skip:
 	 * wait for MMP interval and check mmp_seq.
 	 */
 	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
-		ext4_warning(sb, "MMP startup interrupted, failing mount");
+		ext4_warn(sb, "MMP startup interrupted, failing mount");
 		goto failed;
 	}
 
@@ -320,7 +319,7 @@ skip:
 
 	mmpd_data = kmalloc(sizeof(struct mmpd_data), GFP_KERNEL);
 	if (!mmpd_data) {
-		ext4_warning(sb, "not enough memory for mmpd_data");
+		ext4_warn(sb, "not enough memory for mmpd_data");
 		goto failed;
 	}
 	mmpd_data->sb = sb;
@@ -335,8 +334,7 @@ skip:
 	if (IS_ERR(EXT4_SB(sb)->s_mmp_tsk)) {
 		EXT4_SB(sb)->s_mmp_tsk = NULL;
 		kfree(mmpd_data);
-		ext4_warning(sb, "Unable to create kmmpd thread for %s",
-			     sb->s_id);
+		ext4_warn(sb, "Unable to create kmmpd thread for %s", sb->s_id);
 		goto failed;
 	}
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 99f86a7..ff8a843 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -364,8 +364,8 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 	if (root->info.hash_version != DX_HASH_TEA &&
 	    root->info.hash_version != DX_HASH_HALF_MD4 &&
 	    root->info.hash_version != DX_HASH_LEGACY) {
-		ext4_warning(dir->i_sb, "Unrecognised inode hash code %d",
-			     root->info.hash_version);
+		ext4_warn(dir->i_sb, "Unrecognised inode hash code %d",
+			  root->info.hash_version);
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
 		goto fail;
@@ -379,16 +379,16 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 	hash = hinfo->hash;
 
 	if (root->info.unused_flags & 1) {
-		ext4_warning(dir->i_sb, "Unimplemented inode hash flags: %#06x",
-			     root->info.unused_flags);
+		ext4_warn(dir->i_sb, "Unimplemented inode hash flags: %#06x",
+			  root->info.unused_flags);
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
 		goto fail;
 	}
 
 	if ((indirect = root->info.indirect_levels) > 1) {
-		ext4_warning(dir->i_sb, "Unimplemented inode hash depth: %#06x",
-			     root->info.indirect_levels);
+		ext4_warn(dir->i_sb, "Unimplemented inode hash depth: %#06x",
+			  root->info.indirect_levels);
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
 		goto fail;
@@ -399,7 +399,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 
 	if (dx_get_limit(entries) != dx_root_limit(dir,
 						   root->info.info_length)) {
-		ext4_warning(dir->i_sb, "dx entry: limit != root limit");
+		ext4_warn(dir->i_sb, "dx entry: limit != root limit");
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
 		goto fail;
@@ -410,8 +410,8 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 	{
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
-			ext4_warning(dir->i_sb,
-				     "dx entry: no count or count > limit");
+			ext4_warn(dir->i_sb,
+				  "dx entry: no count or count > limit");
 			brelse(bh);
 			*err = ERR_BAD_DX_DIR;
 			goto fail2;
@@ -457,8 +457,8 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
 		if (dx_get_limit(entries) != dx_node_limit (dir)) {
-			ext4_warning(dir->i_sb,
-				     "dx entry: limit != node limit");
+			ext4_warn(dir->i_sb,
+				  "dx entry: limit != node limit");
 			brelse(bh);
 			*err = ERR_BAD_DX_DIR;
 			goto fail2;
@@ -473,9 +473,9 @@ fail2:
 	}
 fail:
 	if (*err == ERR_BAD_DX_DIR)
-		ext4_warning(dir->i_sb,
-			     "Corrupt dir inode %lu, running e2fsck is recommended.",
-			     dir->i_ino);
+		ext4_warn(dir->i_sb,
+			  "Corrupt dir inode %lu, running e2fsck is recommended.",
+			  dir->i_ino);
 	return NULL;
 }
 
@@ -1009,9 +1009,9 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
 		retval = ext4_htree_next_block(dir, hinfo.hash, frame,
 					       frames, NULL);
 		if (retval < 0) {
-			ext4_warning(sb,
-			     "error reading index page in directory #%lu",
-			     dir->i_ino);
+			ext4_warn(sb,
+				  "error reading index page in directory #%lu",
+				  dir->i_ino);
 			*err = retval;
 			goto errout;
 		}
@@ -1547,7 +1547,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 
 		if (levels && (dx_get_count(frames->entries) ==
 			       dx_get_limit(frames->entries))) {
-			ext4_warning(sb, "Directory index full!");
+			ext4_warn(sb, "Directory index full!");
 			err = -ENOSPC;
 			goto cleanup;
 		}
@@ -1913,9 +1913,9 @@ static int empty_dir(struct inode *inode)
 			EXT4_ERROR_INODE(inode,
 				"error %d reading directory lblock 0", err);
 		else
-			ext4_warning(inode->i_sb,
-				     "bad directory (dir #%lu) - no data block",
-				     inode->i_ino);
+			ext4_warn(inode->i_sb,
+				  "bad directory (dir #%lu) - no data block",
+				  inode->i_ino);
 		return 1;
 	}
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
@@ -1924,9 +1924,9 @@ static int empty_dir(struct inode *inode)
 			!le32_to_cpu(de1->inode) ||
 			strcmp(".", de->name) ||
 			strcmp("..", de1->name)) {
-		ext4_warning(inode->i_sb,
-			     "bad directory (dir #%lu) - no `.' or `..'",
-			     inode->i_ino);
+		ext4_warn(inode->i_sb,
+			  "bad directory (dir #%lu) - no `.' or `..'",
+			  inode->i_ino);
 		brelse(bh);
 		return 1;
 	}
@@ -2159,9 +2159,9 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	if (retval)
 		goto end_rmdir;
 	if (!EXT4_DIR_LINK_EMPTY(inode))
-		ext4_warning(inode->i_sb,
-			     "empty directory has too many links (%d)",
-			     inode->i_nlink);
+		ext4_warn(inode->i_sb,
+			  "empty directory has too many links (%d)",
+			  inode->i_nlink);
 	inode->i_version++;
 	clear_nlink(inode);
 	/* There's no need to set i_disksize: the fact that i_nlink is
@@ -2214,9 +2214,9 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 		goto end_unlink;
 
 	if (!inode->i_nlink) {
-		ext4_warning(inode->i_sb,
-			     "Deleting nonexistent file (%lu), %d",
-			     inode->i_ino, inode->i_nlink);
+		ext4_warn(inode->i_sb,
+			  "Deleting nonexistent file (%lu), %d",
+			  inode->i_ino, inode->i_nlink);
 		set_nlink(inode, 1);
 	}
 	retval = ext4_delete_entry(handle, dir, de, bh);
@@ -2518,9 +2518,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 	if (retval) {
-		ext4_warning(old_dir->i_sb,
-				"Deleting old file (%lu), %d, error=%d",
-				old_dir->i_ino, old_dir->i_nlink, retval);
+		ext4_warn(old_dir->i_sb,
+			  "Deleting old file (%lu), %d, error=%d",
+			  old_dir->i_ino, old_dir->i_nlink, retval);
 	}
 
 	if (new_inode) {
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index a5afbad..b1b492a 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -238,12 +238,12 @@ static void ext4_end_bio(struct bio *bio, int error)
 
 	if (error) {
 		io_end->flag |= EXT4_IO_END_ERROR;
-		ext4_warning(inode->i_sb, "I/O error writing to inode %lu (offset %llu size %ld starting block %llu)",
-			     inode->i_ino,
-			     (unsigned long long) io_end->offset,
-			     (long) io_end->size,
-			     (unsigned long long)
-			     bi_sector >> (inode->i_blkbits - 9));
+		ext4_warn(inode->i_sb, "I/O error writing to inode %lu (offset %llu size %ld starting block %llu)",
+			  inode->i_ino,
+			  (unsigned long long) io_end->offset,
+			  (long) io_end->size,
+			  (unsigned long long)
+			  bi_sector >> (inode->i_blkbits - 9));
 	}
 
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index ed3a306..bd133fd 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -29,7 +29,7 @@ int ext4_resize_begin(struct super_block *sb)
 	 * with error, because it can destroy the filesystem easily.
 	 */
 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
-		ext4_warning(sb, "There are errors in the filesystem, so online resizing is not allowed");
+		ext4_warn(sb, "There are errors in the filesystem, so online resizing is not allowed");
 		return -EPERM;
 	}
 
@@ -76,53 +76,51 @@ static int verify_group_input(struct super_block *sb,
 
 	ext4_get_group_no_and_offset(sb, start, NULL, &offset);
 	if (group != sbi->s_groups_count)
-		ext4_warning(sb, "Cannot add at group %u (only %u groups)",
-			     input->group, sbi->s_groups_count);
+		ext4_warn(sb, "Cannot add at group %u (only %u groups)",
+			  input->group, sbi->s_groups_count);
 	else if (offset != 0)
-			ext4_warning(sb, "Last group not full");
+		ext4_warn(sb, "Last group not full");
 	else if (input->reserved_blocks > input->blocks_count / 5)
-		ext4_warning(sb, "Reserved blocks too high (%u)",
-			     input->reserved_blocks);
+		ext4_warn(sb, "Reserved blocks too high (%u)",
+			  input->reserved_blocks);
 	else if (free_blocks_count < 0)
-		ext4_warning(sb, "Bad blocks count %u",
-			     input->blocks_count);
+		ext4_warn(sb, "Bad blocks count %u", input->blocks_count);
 	else if (!(bh = sb_bread(sb, end - 1)))
-		ext4_warning(sb, "Cannot read last block (%llu)",
-			     end - 1);
+		ext4_warn(sb, "Cannot read last block (%llu)", end - 1);
 	else if (outside(input->block_bitmap, start, end))
-		ext4_warning(sb, "Block bitmap not in group (block %llu)",
-			     (unsigned long long)input->block_bitmap);
+		ext4_warn(sb, "Block bitmap not in group (block %llu)",
+			  (unsigned long long)input->block_bitmap);
 	else if (outside(input->inode_bitmap, start, end))
-		ext4_warning(sb, "Inode bitmap not in group (block %llu)",
-			     (unsigned long long)input->inode_bitmap);
+		ext4_warn(sb, "Inode bitmap not in group (block %llu)",
+			  (unsigned long long)input->inode_bitmap);
 	else if (outside(input->inode_table, start, end) ||
 		 outside(itend - 1, start, end))
-		ext4_warning(sb, "Inode table not in group (blocks %llu-%llu)",
-			     (unsigned long long)input->inode_table, itend - 1);
+		ext4_warn(sb, "Inode table not in group (blocks %llu-%llu)",
+			  (unsigned long long)input->inode_table, itend - 1);
 	else if (input->inode_bitmap == input->block_bitmap)
-		ext4_warning(sb, "Block bitmap same as inode bitmap (%llu)",
-			     (unsigned long long)input->block_bitmap);
+		ext4_warn(sb, "Block bitmap same as inode bitmap (%llu)",
+			  (unsigned long long)input->block_bitmap);
 	else if (inside(input->block_bitmap, input->inode_table, itend))
-		ext4_warning(sb, "Block bitmap (%llu) in inode table (%llu-%llu)",
-			     (unsigned long long)input->block_bitmap,
-			     (unsigned long long)input->inode_table, itend - 1);
+		ext4_warn(sb, "Block bitmap (%llu) in inode table (%llu-%llu)",
+			  (unsigned long long)input->block_bitmap,
+			  (unsigned long long)input->inode_table, itend - 1);
 	else if (inside(input->inode_bitmap, input->inode_table, itend))
-		ext4_warning(sb, "Inode bitmap (%llu) in inode table (%llu-%llu)",
-			     (unsigned long long)input->inode_bitmap,
-			     (unsigned long long)input->inode_table, itend - 1);
+		ext4_warn(sb, "Inode bitmap (%llu) in inode table (%llu-%llu)",
+			  (unsigned long long)input->inode_bitmap,
+			  (unsigned long long)input->inode_table, itend - 1);
 	else if (inside(input->block_bitmap, start, metaend))
-		ext4_warning(sb, "Block bitmap (%llu) in GDT table (%llu-%llu)",
-			     (unsigned long long)input->block_bitmap,
-			     start, metaend - 1);
+		ext4_warn(sb, "Block bitmap (%llu) in GDT table (%llu-%llu)",
+			  (unsigned long long)input->block_bitmap,
+			  start, metaend - 1);
 	else if (inside(input->inode_bitmap, start, metaend))
-		ext4_warning(sb, "Inode bitmap (%llu) in GDT table (%llu-%llu)",
-			     (unsigned long long)input->inode_bitmap,
-			     start, metaend - 1);
+		ext4_warn(sb, "Inode bitmap (%llu) in GDT table (%llu-%llu)",
+			  (unsigned long long)input->inode_bitmap,
+			  start, metaend - 1);
 	else if (inside(input->inode_table, start, metaend) ||
 		 inside(itend - 1, start, metaend))
-		ext4_warning(sb, "Inode table (%llu-%llu) overlaps GDT table (%llu-%llu)",
-			     (unsigned long long)input->inode_table,
-			     itend - 1, start, metaend - 1);
+		ext4_warn(sb, "Inode table (%llu-%llu) overlaps GDT table (%llu-%llu)",
+			  (unsigned long long)input->inode_table,
+			  itend - 1, start, metaend - 1);
 	else
 		err = 0;
 	brelse(bh);
@@ -644,11 +642,11 @@ static int verify_reserved_gdb(struct super_block *sb,
 	while ((grp = ext4_list_backups(sb, &three, &five, &seven)) < end) {
 		if (le32_to_cpu(*p++) !=
 		    grp * EXT4_BLOCKS_PER_GROUP(sb) + blk){
-			ext4_warning(sb, "reserved GDT %llu missing grp %d (%llu)",
-				     blk, grp,
-				     grp *
-				     (ext4_fsblk_t)EXT4_BLOCKS_PER_GROUP(sb) +
-				     blk);
+			ext4_warn(sb, "reserved GDT %llu missing grp %d (%llu)",
+				  blk, grp,
+				  grp *
+				  (ext4_fsblk_t)EXT4_BLOCKS_PER_GROUP(sb) +
+				  blk);
 			return -EINVAL;
 		}
 		if (++gdbackups > EXT4_ADDR_PER_BLOCK(sb))
@@ -696,8 +694,8 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
          */
 	if (EXT4_SB(sb)->s_sbh->b_blocknr !=
 	    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) {
-		ext4_warning(sb, "won't resize using backup superblock at %llu",
-			(unsigned long long)EXT4_SB(sb)->s_sbh->b_blocknr);
+		ext4_warn(sb, "won't resize using backup superblock at %llu",
+			  (unsigned long long)EXT4_SB(sb)->s_sbh->b_blocknr);
 		return -EPERM;
 	}
 
@@ -720,8 +718,8 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 
 	data = (__le32 *)dind->b_data;
 	if (le32_to_cpu(data[gdb_num % EXT4_ADDR_PER_BLOCK(sb)]) != gdblock) {
-		ext4_warning(sb, "new group %u GDT block %llu not reserved",
-			     group, gdblock);
+		ext4_warn(sb, "new group %u GDT block %llu not reserved",
+			  group, gdblock);
 		err = -EINVAL;
 		goto exit_dind;
 	}
@@ -748,8 +746,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 				     GFP_NOFS);
 	if (!n_group_desc) {
 		err = -ENOMEM;
-		ext4_warning(sb, "not enough memory for %lu groups",
-			     gdb_num + 1);
+		ext4_warn(sb, "not enough memory for %lu groups", gdb_num + 1);
 		goto exit_inode;
 	}
 
@@ -856,9 +853,9 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 	/* Get each reserved primary GDT block and verify it holds backups */
 	for (res = 0; res < reserved_gdb; res++, blk++) {
 		if (le32_to_cpu(*data) != blk) {
-			ext4_warning(sb, "reserved block %llu not at offset %ld",
-				     blk,
-				     (long)(data - (__le32 *)dind->b_data));
+			ext4_warn(sb, "reserved block %llu not at offset %ld",
+				  blk,
+				  (long)(data - (__le32 *)dind->b_data));
 			err = -EINVAL;
 			goto exit_bh;
 		}
@@ -1003,8 +1000,8 @@ static void update_backups(struct super_block *sb,
 	 */
 exit_err:
 	if (err) {
-		ext4_warning(sb, "can't update backup for group %u (err %d), forcing fsck on next reboot",
-			     group, err);
+		ext4_warn(sb, "can't update backup for group %u (err %d), forcing fsck on next reboot",
+			  group, err);
 		sbi->s_mount_state &= ~EXT4_VALID_FS;
 		sbi->s_es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
 		mark_buffer_dirty(sbi->s_sbh);
@@ -1383,19 +1380,19 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 
 	if (gdb_off == 0 && !EXT4_HAS_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
-		ext4_warning(sb, "Can't resize non-sparse filesystem further");
+		ext4_warn(sb, "Can't resize non-sparse filesystem further");
 		return -EPERM;
 	}
 
 	if (ext4_blocks_count(es) + input->blocks_count <
 	    ext4_blocks_count(es)) {
-		ext4_warning(sb, "blocks_count overflow");
+		ext4_warn(sb, "blocks_count overflow");
 		return -EINVAL;
 	}
 
 	if (le32_to_cpu(es->s_inodes_count) + EXT4_INODES_PER_GROUP(sb) <
 	    le32_to_cpu(es->s_inodes_count)) {
-		ext4_warning(sb, "inodes_count overflow");
+		ext4_warn(sb, "inodes_count overflow");
 		return -EINVAL;
 	}
 
@@ -1403,13 +1400,13 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 		if (!EXT4_HAS_COMPAT_FEATURE(sb,
 					     EXT4_FEATURE_COMPAT_RESIZE_INODE)
 		    || !le16_to_cpu(es->s_reserved_gdt_blocks)) {
-			ext4_warning(sb,
-				     "No reserved GDT blocks, can't resize");
+			ext4_warn(sb,
+				  "No reserved GDT blocks, can't resize");
 			return -EPERM;
 		}
 		inode = ext4_iget(sb, EXT4_RESIZE_INO);
 		if (IS_ERR(inode)) {
-			ext4_warning(sb, "Error opening resize inode");
+			ext4_warn(sb, "Error opening resize inode");
 			return PTR_ERR(inode);
 		}
 	}
@@ -1444,13 +1441,13 @@ static int ext4_group_extend_no_check(struct super_block *sb,
 	handle = ext4_journal_start_sb(sb, 3);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
-		ext4_warning(sb, "error %d on journal start", err);
+		ext4_warn(sb, "error %d on journal start", err);
 		return err;
 	}
 
 	err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
 	if (err) {
-		ext4_warning(sb, "error %d on journal write access", err);
+		ext4_warn(sb, "error %d on journal write access", err);
 		goto errout;
 	}
 
@@ -1512,12 +1509,12 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 		pr_err("filesystem on %s: too large to resize to %llu blocks safely\n",
 		       sb->s_id, n_blocks_count);
 		if (sizeof(sector_t) < 8)
-			ext4_warning(sb, "CONFIG_LBDAF not enabled");
+			ext4_warn(sb, "CONFIG_LBDAF not enabled");
 		return -EINVAL;
 	}
 
 	if (n_blocks_count < o_blocks_count) {
-		ext4_warning(sb, "can't shrink FS - resize aborted");
+		ext4_warn(sb, "can't shrink FS - resize aborted");
 		return -EINVAL;
 	}
 
@@ -1525,14 +1522,14 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	ext4_get_group_no_and_offset(sb, o_blocks_count, &group, &last);
 
 	if (last == 0) {
-		ext4_warning(sb, "need to use ext2online to resize further");
+		ext4_warn(sb, "need to use ext2online to resize further");
 		return -EPERM;
 	}
 
 	add = EXT4_BLOCKS_PER_GROUP(sb) - last;
 
 	if (o_blocks_count + add < o_blocks_count) {
-		ext4_warning(sb, "blocks_count overflow");
+		ext4_warn(sb, "blocks_count overflow");
 		return -EINVAL;
 	}
 
@@ -1540,13 +1537,13 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 		add = n_blocks_count - o_blocks_count;
 
 	if (o_blocks_count + add < n_blocks_count)
-		ext4_warning(sb, "will only finish group (%llu blocks, %u new)",
-			     o_blocks_count + add, add);
+		ext4_warn(sb, "will only finish group (%llu blocks, %u new)",
+			  o_blocks_count + add, add);
 
 	/* See if the device is actually as big as what was requested */
 	bh = sb_bread(sb, o_blocks_count + add - 1);
 	if (!bh) {
-		ext4_warning(sb, "can't read last block, resize aborted");
+		ext4_warn(sb, "can't read last block, resize aborted");
 		return -ENOSPC;
 	}
 	brelse(bh);
@@ -1585,7 +1582,7 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 
 	if (n_blocks_count < o_blocks_count) {
 		/* On-line shrinking not supported */
-		ext4_warning(sb, "can't shrink FS - resize aborted");
+		ext4_warn(sb, "can't shrink FS - resize aborted");
 		return -EINVAL;
 	}
 
@@ -1605,20 +1602,20 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 	if (desc_blocks &&
 	    (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_RESIZE_INODE) ||
 	     le16_to_cpu(es->s_reserved_gdt_blocks) < desc_blocks)) {
-		ext4_warning(sb, "No reserved GDT blocks, can't resize");
+		ext4_warn(sb, "No reserved GDT blocks, can't resize");
 		return -EPERM;
 	}
 
 	resize_inode = ext4_iget(sb, EXT4_RESIZE_INO);
 	if (IS_ERR(resize_inode)) {
-		ext4_warning(sb, "Error opening resize inode");
+		ext4_warn(sb, "Error opening resize inode");
 		return PTR_ERR(resize_inode);
 	}
 
 	/* See if the device is actually as big as what was requested */
 	bh = sb_bread(sb, n_blocks_count - 1);
 	if (!bh) {
-		ext4_warning(sb, "can't read last block, resize aborted");
+		ext4_warn(sb, "can't read last block, resize aborted");
 		return -ENOSPC;
 	}
 	brelse(bh);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cade67b..18e68f1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -621,7 +621,7 @@ void __ext4_std_error(struct super_block *sb, const char *function,
 }
 
 /*
- * ext4_abort is a much stronger failure handler than ext4_error.  The
+ * ext4_abort is a much stronger failure handler than ext4_err.  The
  * abort function may be used to deal with unrecoverable failures such
  * as journal IO errors or ENOMEM at a critical moment in log management.
  *
@@ -737,9 +737,9 @@ void ext4_update_dynamic_rev(struct super_block *sb)
 	if (le32_to_cpu(es->s_rev_level) > EXT4_GOOD_OLD_REV)
 		return;
 
-	ext4_warning(sb,
-		     "updating to rev %d because of new feature flag, running e2fsck is recommended",
-		     EXT4_DYNAMIC_REV);
+	ext4_warn(sb,
+		  "updating to rev %d because of new feature flag, running e2fsck is recommended",
+		  EXT4_DYNAMIC_REV);
 
 	es->s_first_ino = cpu_to_le32(EXT4_GOOD_OLD_FIRST_INO);
 	es->s_inode_size = cpu_to_le16(EXT4_GOOD_OLD_INODE_SIZE);
@@ -3289,8 +3289,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	} else {
 		if (clustersize != blocksize) {
-			ext4_warning(sb, "fragment/cluster size (%d) != block size (%d)",
-				     clustersize, blocksize);
+			ext4_warn(sb, "fragment/cluster size (%d) != block size (%d)",
+				  clustersize, blocksize);
 			clustersize = blocksize;
 		}
 		if (sbi->s_blocks_per_group > blocksize * 8) {
@@ -4080,7 +4080,7 @@ static void ext4_clear_journal_err(struct super_block *sb,
 
 	/*
 	 * Now check for any error status which may have been recorded in the
-	 * journal by a prior ext4_error() or ext4_abort()
+	 * journal by a prior ext4_err() or ext4_abort()
 	 */
 
 	j_errno = jbd2_journal_errno(journal);
@@ -4088,9 +4088,9 @@ static void ext4_clear_journal_err(struct super_block *sb,
 		char nbuf[16];
 
 		errstr = ext4_decode_error(sb, j_errno, nbuf);
-		ext4_warning(sb, "Filesystem error recorded from previous mount: %s",
-			     errstr);
-		ext4_warning(sb, "Marking fs in need of filesystem check");
+		ext4_warn(sb, "Filesystem error recorded from previous mount: %s",
+			  errstr);
+		ext4_warn(sb, "Marking fs in need of filesystem check");
 
 		EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
-- 
1.7.8.111.gad25c.dirty

