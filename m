From: Joe Perches <joe@perches.com>
Subject: [PATCH 8/9] ext4: Neaten ext4_error uses
Date: Thu, 15 Mar 2012 17:07:36 -0700
Message-ID: <7c7a755af1c662399554368aba7e01afa9272b01.1331856300.git.joe@perches.com>
References: <cover.1331856299.git.joe@perches.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1331856299.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4_error appends a newline to the output.
Uses of ext4_error should not end in a newline.

Remove terminating newlines from ext4_error uses.
Coalesce formats.  Add missing space between words
in newly coalesced format.  Align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/balloc.c      |   15 ++++++---------
 fs/ext4/ialloc.c      |   15 ++++++---------
 fs/ext4/mballoc.c     |   25 ++++++++++++-------------
 fs/ext4/move_extent.c |    8 ++++----
 4 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index a5cd777..82f468f 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -254,8 +254,8 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	if (block_group >= ngroups) {
-		ext4_error(sb, "block_group >= groups_count - block_group = %u,"
-			   " groups_count = %u", block_group, ngroups);
+		ext4_error(sb, "block_group >= groups_count - block_group = %u, groups_count = %u",
+			   block_group, ngroups);
 
 		return NULL;
 	}
@@ -263,8 +263,7 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 	group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
 	offset = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
 	if (!sbi->s_group_desc[group_desc]) {
-		ext4_error(sb, "Group descriptor not loaded - "
-			   "block_group = %u, group_desc = %u, desc = %u",
+		ext4_error(sb, "Group descriptor not loaded - block_group = %u, group_desc = %u, desc = %u",
 			   block_group, group_desc, offset);
 		return NULL;
 	}
@@ -324,7 +323,7 @@ static int ext4_valid_block_bitmap(struct super_block *sb,
 
 err_out:
 	ext4_error(sb, "Invalid block bitmap - block_group = %d, block = %llu",
-			block_group, bitmap_blk);
+		   block_group, bitmap_blk);
 	return 0;
 }
 /**
@@ -350,8 +349,7 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
 	bitmap_blk = ext4_block_bitmap(sb, desc);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
-		ext4_error(sb, "Cannot get buffer for block bitmap - "
-			   "block_group = %u, block_bitmap = %llu",
+		ext4_error(sb, "Cannot get buffer for block bitmap - block_group = %u, block_bitmap = %llu",
 			   block_group, bitmap_blk);
 		return NULL;
 	}
@@ -407,8 +405,7 @@ int ext4_wait_block_bitmap(struct super_block *sb, ext4_group_t block_group,
 		return 1;
 	wait_on_buffer(bh);
 	if (!buffer_uptodate(bh)) {
-		ext4_error(sb, "Cannot read block bitmap - "
-			   "block_group = %u, block_bitmap = %llu",
+		ext4_error(sb, "Cannot read block bitmap - block_group = %u, block_bitmap = %llu",
 			   block_group, (unsigned long long) bh->b_blocknr);
 		return 1;
 	}
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 024466a..29cbd9f 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -124,9 +124,8 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 	bitmap_blk = ext4_inode_bitmap(sb, desc);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
-		ext4_error(sb, "Cannot read inode bitmap - "
-			    "block_group = %u, inode_bitmap = %llu",
-			    block_group, bitmap_blk);
+		ext4_error(sb, "Cannot read inode bitmap - block_group = %u, inode_bitmap = %llu",
+			   block_group, bitmap_blk);
 		return NULL;
 	}
 	if (bitmap_uptodate(bh))
@@ -168,8 +167,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 	wait_on_buffer(bh);
 	if (!buffer_uptodate(bh)) {
 		put_bh(bh);
-		ext4_error(sb, "Cannot read inode bitmap - "
-			   "block_group = %u, inode_bitmap = %llu",
+		ext4_error(sb, "Cannot read inode bitmap - block_group = %u, inode_bitmap = %llu",
 			   block_group, bitmap_blk);
 		return NULL;
 	}
@@ -690,8 +688,8 @@ repeat_in_this_group:
 			continue;
 		}
 		if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
-			ext4_error(sb, "reserved inode found cleared - "
-				   "inode=%lu", ino + 1);
+			ext4_error(sb, "reserved inode found cleared - inode=%lu",
+				   ino + 1);
 			continue;
 		}
 		ext4_lock_group(sb, group);
@@ -1101,8 +1099,7 @@ int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 
 	if ((used_blks < 0) || (used_blks > sbi->s_itb_per_group)) {
 		ext4_error(sb, "Something is wrong with group %u\n"
-			   "Used itable blocks: %d"
-			   "itable unused count: %u\n",
+			   "Used itable blocks: %d itable unused count: %u",
 			   group, used_blks,
 			   ext4_itable_unused_count(sb, gdp));
 		ret = 1;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 70b22fb..185cbac 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2758,8 +2758,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 
 	len = EXT4_C2B(sbi, ac->ac_b_ex.fe_len);
 	if (!ext4_data_block_valid(sbi, block, len)) {
-		ext4_error(sb, "Allocating blocks %llu-%llu which overlap "
-			   "fs metadata\n", block, block+len);
+		ext4_error(sb, "Allocating blocks %llu-%llu which overlap fs metadata",
+			   block, block + len);
 		/* File system mounted not to panic on error
 		 * Fix the bitmap and repeat the block allocation
 		 * We leak some of the blocks here.
@@ -3826,14 +3826,14 @@ repeat:
 		err = ext4_mb_load_buddy(sb, group, &e4b);
 		if (err) {
 			ext4_error(sb, "Error loading buddy information for %u",
-					group);
+				   group);
 			continue;
 		}
 
 		bitmap_bh = ext4_read_block_bitmap(sb, group);
 		if (bitmap_bh == NULL) {
 			ext4_error(sb, "Error reading block bitmap for %u",
-					group);
+				   group);
 			ext4_mb_unload_buddy(&e4b);
 			continue;
 		}
@@ -4082,7 +4082,7 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
 		if (ext4_mb_load_buddy(sb, group, &e4b)) {
 			ext4_error(sb, "Error loading buddy information for %u",
-					group);
+				   group);
 			continue;
 		}
 		ext4_lock_group(sb, group);
@@ -4488,8 +4488,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	sbi = EXT4_SB(sb);
 	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
 	    !ext4_data_block_valid(sbi, block, count)) {
-		ext4_error(sb, "Freeing blocks not in datazone - "
-			   "block = %llu, count = %lu", block, count);
+		ext4_error(sb, "Freeing blocks not in datazone - block = %llu, count = %lu",
+			   block, count);
 		goto error_return;
 	}
 
@@ -4587,8 +4587,8 @@ do_more:
 	    in_range(block + count - 1, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group)) {
 
-		ext4_error(sb, "Freeing blocks in system zone - "
-			   "Block = %llu, count = %lu", block, count);
+		ext4_error(sb, "Freeing blocks in system zone - Block = %llu, count = %lu",
+			   block, count);
 		/* err = 0. ext4_std_error should be a no op */
 		goto error_return;
 	}
@@ -4748,8 +4748,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
 	    in_range(block + count - 1, ext4_inode_table(sb, desc),
 		     sbi->s_itb_per_group)) {
-		ext4_error(sb, "Adding blocks in system zones - "
-			   "Block = %llu, count = %lu",
+		ext4_error(sb, "Adding blocks in system zones - Block = %llu, count = %lu",
 			   block, count);
 		err = -EINVAL;
 		goto error_return;
@@ -4892,8 +4891,8 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 
 	ret = ext4_mb_load_buddy(sb, group, &e4b);
 	if (ret) {
-		ext4_error(sb, "Error in loading buddy "
-				"information for %u", group);
+		ext4_error(sb, "Error in loading buddy information for %u",
+			   group);
 		return ret;
 	}
 	bitmap = e4b.bd_bitmap;
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index ce52881..4558376 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -153,13 +153,13 @@ mext_check_null_inode(struct inode *inode1, struct inode *inode2,
 
 	if (inode1 == NULL) {
 		__ext4_error(inode2->i_sb, function, line,
-			"Both inodes should not be NULL: "
-			"inode1 NULL inode2 %lu", inode2->i_ino);
+			     "Both inodes should not be NULL: inode1 NULL inode2 %lu",
+			     inode2->i_ino);
 		ret = -EIO;
 	} else if (inode2 == NULL) {
 		__ext4_error(inode1->i_sb, function, line,
-			"Both inodes should not be NULL: "
-			"inode1 %lu inode2 NULL", inode1->i_ino);
+			     "Both inodes should not be NULL: inode1 %lu inode2 NULL",
+			     inode1->i_ino);
 		ret = -EIO;
 	}
 	return ret;
-- 
1.7.8.111.gad25c.dirty
