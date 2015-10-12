From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/8] ext4: make the bitmap read routines return real error
 codes
Date: Mon, 12 Oct 2015 14:54:58 -0700
Message-ID: <20151012215458.28872.63722.stgit@birch.djwong.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43837 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbbJLVzD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:55:03 -0400
In-Reply-To: <20151012215416.28872.8160.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make the bitmap reaading routines return real error codes (EIO,
EFSCORRUPTED, EFSBADCRC) which can then be reflected back to
userspace for more precise diagnosis work.

In particular, this means that mballoc no longer claims that we're out
of memory if the block bitmaps become corrupt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/balloc.c  |  100 ++++++++++++++++++++++++-------------------
 fs/ext4/ext4.h    |   10 +++-
 fs/ext4/ialloc.c  |  122 +++++++++++++++++++++++++++++++++--------------------
 fs/ext4/mballoc.c |   50 +++++++++++-----------
 4 files changed, 162 insertions(+), 120 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index f831e10..1a57b23 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -191,6 +191,7 @@ static int ext4_init_block_bitmap(struct super_block *sb,
 	/* If checksum is bad mark all blocks used to prevent allocation
 	 * essentially implementing a per-group read-only flag. */
 	if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
+		ext4_error(sb, "Checksum bad for group %u", block_group);
 		grp = ext4_get_group_info(sb, block_group);
 		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
 			percpu_counter_sub(&sbi->s_freeclusters_counter,
@@ -360,71 +361,78 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
 	return 0;
 }
 
-static void ext4_validate_block_bitmap(struct super_block *sb,
-				       struct ext4_group_desc *desc,
-				       ext4_group_t block_group,
-				       struct buffer_head *bh)
+static int ext4_validate_block_bitmap(struct super_block *sb,
+				      struct ext4_group_desc *desc,
+				      ext4_group_t block_group,
+				      struct buffer_head *bh)
 {
 	ext4_fsblk_t	blk;
 	struct ext4_group_info *grp = ext4_get_group_info(sb, block_group);
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (buffer_verified(bh) || EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
-		return;
+	if (buffer_verified(bh))
+		return 0;
+	if (EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
+		return -EFSCORRUPTED;
 
 	ext4_lock_group(sb, block_group);
-	blk = ext4_valid_block_bitmap(sb, desc, block_group, bh);
-	if (unlikely(blk != 0)) {
+	if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
+			desc, bh))) {
 		ext4_unlock_group(sb, block_group);
-		ext4_error(sb, "bg %u: block %llu: invalid block bitmap",
-			   block_group, blk);
+		ext4_error(sb, "bg %u: bad block bitmap checksum", block_group);
 		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
 			percpu_counter_sub(&sbi->s_freeclusters_counter,
 					   grp->bb_free);
 		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
-		return;
+		return -EFSBADCRC;
 	}
-	if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
-			desc, bh))) {
+	blk = ext4_valid_block_bitmap(sb, desc, block_group, bh);
+	if (unlikely(blk != 0)) {
 		ext4_unlock_group(sb, block_group);
-		ext4_error(sb, "bg %u: bad block bitmap checksum", block_group);
+		ext4_error(sb, "bg %u: block %llu: invalid block bitmap",
+			   block_group, blk);
 		if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
 			percpu_counter_sub(&sbi->s_freeclusters_counter,
 					   grp->bb_free);
 		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
-		return;
+		return -EFSCORRUPTED;
 	}
 	set_buffer_verified(bh);
 	ext4_unlock_group(sb, block_group);
+	return 0;
 }
 
 /**
  * ext4_read_block_bitmap_nowait()
  * @sb:			super block
  * @block_group:	given block group
+ * @bbh:		pointer to buffer_head
  *
  * Read the bitmap for a given block_group,and validate the
  * bits for block/inode/inode tables are set in the bitmaps
  *
  * Return buffer_head on success or NULL in case of failure.
  */
-struct buffer_head *
-ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
+int
+ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group,
+			      struct buffer_head **bbh)
 {
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh;
 	ext4_fsblk_t bitmap_blk;
+	int err;
 
+	*bbh = NULL;
 	desc = ext4_get_group_desc(sb, block_group, NULL);
 	if (!desc)
-		return NULL;
+		return -EFSCORRUPTED;
 	bitmap_blk = ext4_block_bitmap(sb, desc);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
 		ext4_error(sb, "Cannot get buffer for block bitmap - "
 			   "block_group = %u, block_bitmap = %llu",
 			   block_group, bitmap_blk);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	if (bitmap_uptodate(bh))
@@ -437,7 +445,6 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
 	}
 	ext4_lock_group(sb, block_group);
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-		int err;
 
 		err = ext4_init_block_bitmap(sb, bh, block_group, desc);
 		set_bitmap_uptodate(bh);
@@ -445,7 +452,7 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
 		ext4_unlock_group(sb, block_group);
 		unlock_buffer(bh);
 		if (err)
-			ext4_error(sb, "Checksum bad for grp %u", block_group);
+			goto out;
 		goto verify;
 	}
 	ext4_unlock_group(sb, block_group);
@@ -466,13 +473,17 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
 	bh->b_end_io = ext4_end_bitmap_read;
 	get_bh(bh);
 	submit_bh(READ | REQ_META | REQ_PRIO, bh);
-	return bh;
+	*bbh = bh;
+	return 0;
 verify:
-	ext4_validate_block_bitmap(sb, desc, block_group, bh);
-	if (buffer_verified(bh))
-		return bh;
+	err = ext4_validate_block_bitmap(sb, desc, block_group, bh);
+	if (err)
+		goto out;
+	*bbh = bh;
+	return 0;
+out:
 	put_bh(bh);
-	return NULL;
+	return err;
 }
 
 /* Returns 0 on success, 1 on error */
@@ -485,34 +496,34 @@ int ext4_wait_block_bitmap(struct super_block *sb, ext4_group_t block_group,
 		return 0;
 	desc = ext4_get_group_desc(sb, block_group, NULL);
 	if (!desc)
-		return 1;
+		return -EFSCORRUPTED;
 	wait_on_buffer(bh);
 	if (!buffer_uptodate(bh)) {
 		ext4_error(sb, "Cannot read block bitmap - "
 			   "block_group = %u, block_bitmap = %llu",
 			   block_group, (unsigned long long) bh->b_blocknr);
-		return 1;
+		return -EIO;
 	}
 	clear_buffer_new(bh);
 	/* Panic or remount fs read-only if block bitmap is invalid */
-	ext4_validate_block_bitmap(sb, desc, block_group, bh);
-	/* ...but check for error just in case errors=continue. */
-	return !buffer_verified(bh);
+	return ext4_validate_block_bitmap(sb, desc, block_group, bh);
 }
 
-struct buffer_head *
-ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
+int
+ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group,
+		       struct buffer_head **bbh)
 {
-	struct buffer_head *bh;
-
-	bh = ext4_read_block_bitmap_nowait(sb, block_group);
-	if (!bh)
-		return NULL;
-	if (ext4_wait_block_bitmap(sb, block_group, bh)) {
-		put_bh(bh);
-		return NULL;
+	int err;
+
+	err = ext4_read_block_bitmap_nowait(sb, block_group, bbh);
+	if (err)
+		return err;
+	err = ext4_wait_block_bitmap(sb, block_group, *bbh);
+	if (err) {
+		put_bh(*bbh);
+		*bbh = NULL;
 	}
-	return bh;
+	return err;
 }
 
 /**
@@ -664,6 +675,7 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 	ext4_fsblk_t bitmap_count;
 	unsigned int x;
 	struct buffer_head *bitmap_bh = NULL;
+	int err;
 
 	es = EXT4_SB(sb)->s_es;
 	desc_count = 0;
@@ -680,8 +692,8 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 		if (!grp || !EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
 			desc_count += ext4_free_group_clusters(sb, gdp);
 		brelse(bitmap_bh);
-		bitmap_bh = ext4_read_block_bitmap(sb, i);
-		if (bitmap_bh == NULL)
+		err = ext4_read_block_bitmap(sb, i, &bitmap_bh);
+		if (err)
 			continue;
 
 		x = ext4_count_free(bitmap_bh->b_data,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 285b39f..bee6ac4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2033,13 +2033,15 @@ extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 						    struct buffer_head ** bh);
 extern int ext4_should_retry_alloc(struct super_block *sb, int *retries);
 
-extern struct buffer_head *ext4_read_block_bitmap_nowait(struct super_block *sb,
-						ext4_group_t block_group);
+extern int ext4_read_block_bitmap_nowait(struct super_block *sb,
+					 ext4_group_t block_group,
+					 struct buffer_head **bbh);
 extern int ext4_wait_block_bitmap(struct super_block *sb,
 				  ext4_group_t block_group,
 				  struct buffer_head *bh);
-extern struct buffer_head *ext4_read_block_bitmap(struct super_block *sb,
-						  ext4_group_t block_group);
+extern int ext4_read_block_bitmap(struct super_block *sb,
+				  ext4_group_t block_group,
+				  struct buffer_head **bbh);
 extern unsigned ext4_free_clusters_after_init(struct super_block *sb,
 					      ext4_group_t block_group,
 					      struct ext4_group_desc *gdp);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f34b1aa..e3c44cf 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -64,7 +64,7 @@ void ext4_mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
 }
 
 /* Initializes an uninitialized inode bitmap */
-static unsigned ext4_init_inode_bitmap(struct super_block *sb,
+static int ext4_init_inode_bitmap(struct super_block *sb,
 				       struct buffer_head *bh,
 				       ext4_group_t block_group,
 				       struct ext4_group_desc *gdp)
@@ -89,7 +89,7 @@ static unsigned ext4_init_inode_bitmap(struct super_block *sb,
 					   count);
 		}
 		set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &grp->bb_state);
-		return 0;
+		return -EFSBADCRC;
 	}
 
 	memset(bh->b_data, 0, (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
@@ -99,7 +99,7 @@ static unsigned ext4_init_inode_bitmap(struct super_block *sb,
 				   EXT4_INODES_PER_GROUP(sb) / 8);
 	ext4_group_desc_csum_set(sb, block_group, gdp);
 
-	return EXT4_INODES_PER_GROUP(sb);
+	return 0;
 }
 
 void ext4_end_bitmap_read(struct buffer_head *bh, int uptodate)
@@ -112,24 +112,61 @@ void ext4_end_bitmap_read(struct buffer_head *bh, int uptodate)
 	put_bh(bh);
 }
 
+static int ext4_validate_inode_bitmap(struct super_block *sb,
+				      struct ext4_group_desc *desc,
+				      ext4_group_t block_group,
+				      struct buffer_head *bh)
+{
+	ext4_fsblk_t	blk;
+	struct ext4_group_info *grp = ext4_get_group_info(sb, block_group);
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (buffer_verified(bh))
+		return 0;
+	if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
+		return -EFSCORRUPTED;
+
+	ext4_lock_group(sb, block_group);
+	blk = ext4_inode_bitmap(sb, desc);
+	if (!ext4_inode_bitmap_csum_verify(sb, block_group, desc, bh,
+					   EXT4_INODES_PER_GROUP(sb) / 8)) {
+		ext4_unlock_group(sb, block_group);
+		ext4_error(sb, "Corrupt inode bitmap - block_group = %u, "
+			   "inode_bitmap = %llu", block_group, blk);
+		grp = ext4_get_group_info(sb, block_group);
+		if (!EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
+			int count;
+			count = ext4_free_inodes_count(sb, desc);
+			percpu_counter_sub(&sbi->s_freeinodes_counter,
+					   count);
+		}
+		set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &grp->bb_state);
+		return -EFSBADCRC;
+	}
+	set_buffer_verified(bh);
+	ext4_unlock_group(sb, block_group);
+	return 0;
+}
+
 /*
  * Read the inode allocation bitmap for a given block_group, reading
  * into the specified slot in the superblock's bitmap cache.
  *
  * Return buffer_head of bitmap on success or NULL.
  */
-static struct buffer_head *
-ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
+static int
+ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group,
+		       struct buffer_head **bbh)
 {
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh = NULL;
 	ext4_fsblk_t bitmap_blk;
-	struct ext4_group_info *grp;
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int err;
 
+	*bbh = NULL;
 	desc = ext4_get_group_desc(sb, block_group, NULL);
 	if (!desc)
-		return NULL;
+		return -EFSCORRUPTED;
 
 	bitmap_blk = ext4_inode_bitmap(sb, desc);
 	bh = sb_getblk(sb, bitmap_blk);
@@ -137,7 +174,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		ext4_error(sb, "Cannot read inode bitmap - "
 			    "block_group = %u, inode_bitmap = %llu",
 			    block_group, bitmap_blk);
-		return NULL;
+		return -EIO;
 	}
 	if (bitmap_uptodate(bh))
 		goto verify;
@@ -150,13 +187,16 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 
 	ext4_lock_group(sb, block_group);
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
-		ext4_init_inode_bitmap(sb, bh, block_group, desc);
+		err = ext4_init_inode_bitmap(sb, bh, block_group, desc);
 		set_bitmap_uptodate(bh);
 		set_buffer_uptodate(bh);
 		set_buffer_verified(bh);
 		ext4_unlock_group(sb, block_group);
 		unlock_buffer(bh);
-		return bh;
+		if (err)
+			goto out;
+		*bbh = bh;
+		return 0;
 	}
 	ext4_unlock_group(sb, block_group);
 
@@ -182,31 +222,18 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		ext4_error(sb, "Cannot read inode bitmap - "
 			   "block_group = %u, inode_bitmap = %llu",
 			   block_group, bitmap_blk);
-		return NULL;
+		return -EIO;
 	}
 
 verify:
-	ext4_lock_group(sb, block_group);
-	if (!buffer_verified(bh) &&
-	    !ext4_inode_bitmap_csum_verify(sb, block_group, desc, bh,
-					   EXT4_INODES_PER_GROUP(sb) / 8)) {
-		ext4_unlock_group(sb, block_group);
-		put_bh(bh);
-		ext4_error(sb, "Corrupt inode bitmap - block_group = %u, "
-			   "inode_bitmap = %llu", block_group, bitmap_blk);
-		grp = ext4_get_group_info(sb, block_group);
-		if (!EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
-			int count;
-			count = ext4_free_inodes_count(sb, desc);
-			percpu_counter_sub(&sbi->s_freeinodes_counter,
-					   count);
-		}
-		set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &grp->bb_state);
-		return NULL;
-	}
-	ext4_unlock_group(sb, block_group);
-	set_buffer_verified(bh);
-	return bh;
+	err = ext4_validate_inode_bitmap(sb, desc, block_group, bh);
+	if (err)
+		goto out;
+	*bbh = bh;
+	return 0;
+out:
+	put_bh(bh);
+	return err;
 }
 
 /*
@@ -283,11 +310,11 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	}
 	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
 	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
-	bitmap_bh = ext4_read_inode_bitmap(sb, block_group);
 	/* Don't bother if the inode bitmap is corrupt. */
-	grp = ext4_get_group_info(sb, block_group);
-	if (unlikely(EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) || !bitmap_bh)
+	err = ext4_read_inode_bitmap(sb, block_group, &bitmap_bh);
+	if (err)
 		goto error_return;
+	grp = ext4_get_group_info(sb, block_group);
 
 	BUFFER_TRACE(bitmap_bh, "get_write_access");
 	fatal = ext4_journal_get_write_access(handle, bitmap_bh);
@@ -824,9 +851,10 @@ got_group:
 		}
 
 		brelse(inode_bitmap_bh);
-		inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
+		err = ext4_read_inode_bitmap(sb, group, &inode_bitmap_bh);
 		/* Skip groups with suspicious inode tables */
-		if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp) || !inode_bitmap_bh) {
+		if (err || EXT4_MB_GRP_IBITMAP_CORRUPT(grp) ||
+		    !inode_bitmap_bh) {
 			if (++group == ngroups)
 				group = 0;
 			continue;
@@ -901,11 +929,9 @@ got:
 	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		struct buffer_head *block_bitmap_bh;
 
-		block_bitmap_bh = ext4_read_block_bitmap(sb, group);
-		if (!block_bitmap_bh) {
-			err = -EIO;
+		err = ext4_read_block_bitmap(sb, group, &block_bitmap_bh);
+		if (err)
 			goto out;
-		}
 		BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
 		err = ext4_journal_get_write_access(handle, block_bitmap_bh);
 		if (err) {
@@ -1122,9 +1148,10 @@ struct inode *ext4_orphan_get(struct super_block *sb, unsigned long ino)
 
 	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
 	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
-	bitmap_bh = ext4_read_inode_bitmap(sb, block_group);
-	if (!bitmap_bh) {
-		ext4_warning(sb, "inode bitmap error for orphan %lu", ino);
+	err = ext4_read_inode_bitmap(sb, block_group, &bitmap_bh);
+	if (err) {
+		ext4_warning(sb, "inode bitmap error %ld for orphan %lu",
+			     ino, err);
 		goto error;
 	}
 
@@ -1187,6 +1214,7 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
 	struct ext4_super_block *es;
 	unsigned long bitmap_count, x;
 	struct buffer_head *bitmap_bh = NULL;
+	int err;
 
 	es = EXT4_SB(sb)->s_es;
 	desc_count = 0;
@@ -1198,8 +1226,8 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
 			continue;
 		desc_count += ext4_free_inodes_count(sb, gdp);
 		brelse(bitmap_bh);
-		bitmap_bh = ext4_read_inode_bitmap(sb, i);
-		if (!bitmap_bh)
+		err = ext4_read_inode_bitmap(sb, i, &bitmap_bh);
+		if (err)
 			continue;
 
 		x = ext4_count_free(bitmap_bh->b_data,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 34b610e..9a6b4c3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -874,17 +874,21 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			bh[i] = NULL;
 			continue;
 		}
-		if (!(bh[i] = ext4_read_block_bitmap_nowait(sb, group))) {
-			err = -ENOMEM;
+		err = ext4_read_block_bitmap_nowait(sb, group, &bh[i]);
+		if (err)
 			goto out;
-		}
 		mb_debug(1, "read bitmap for group %u\n", group);
 	}
 
 	/* wait for I/O completion */
 	for (i = 0, group = first_group; i < groups_per_page; i++, group++) {
-		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i]))
-			err = -EIO;
+		int err2;
+
+		if (!bh[i])
+			continue;
+		err2 = ext4_wait_block_bitmap(sb, group, bh[i]);
+		if (!err)
+			err = err2;
 	}
 
 	first_block = page->index * blocks_per_page;
@@ -2446,8 +2450,8 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 		meta_group_info[i]->bb_bitmap =
 			kmalloc(sb->s_blocksize, GFP_NOFS);
 		BUG_ON(meta_group_info[i]->bb_bitmap == NULL);
-		bh = ext4_read_block_bitmap(sb, group);
-		BUG_ON(bh == NULL);
+		err = ext4_read_block_bitmap(sb, group, &bh);
+		BUG_ON(err);
 		memcpy(meta_group_info[i]->bb_bitmap, bh->b_data,
 			sb->s_blocksize);
 		put_bh(bh);
@@ -2896,9 +2900,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	sb = ac->ac_sb;
 	sbi = EXT4_SB(sb);
 
-	err = -EIO;
-	bitmap_bh = ext4_read_block_bitmap(sb, ac->ac_b_ex.fe_group);
-	if (!bitmap_bh)
+	err = ext4_read_block_bitmap(sb, ac->ac_b_ex.fe_group, &bitmap_bh);
+	if (err)
 		goto out_err;
 
 	BUFFER_TRACE(bitmap_bh, "getting write access");
@@ -3842,9 +3845,10 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 	if (list_empty(&grp->bb_prealloc_list))
 		return 0;
 
-	bitmap_bh = ext4_read_block_bitmap(sb, group);
-	if (bitmap_bh == NULL) {
-		ext4_error(sb, "Error reading block bitmap for %u", group);
+	err = ext4_read_block_bitmap(sb, group, &bitmap_bh);
+	if (err) {
+		ext4_error(sb, "Error %d reading block bitmap for %u",
+			   err, group);
 		return 0;
 	}
 
@@ -4014,10 +4018,10 @@ repeat:
 			continue;
 		}
 
-		bitmap_bh = ext4_read_block_bitmap(sb, group);
-		if (bitmap_bh == NULL) {
-			ext4_error(sb, "Error reading block bitmap for %u",
-					group);
+		err = ext4_read_block_bitmap(sb, group, &bitmap_bh);
+		if (err) {
+			ext4_error(sb, "Error %d reading block bitmap for %u",
+					err, group);
 			ext4_mb_unload_buddy(&e4b);
 			continue;
 		}
@@ -4760,11 +4764,9 @@ do_more:
 		count -= overflow;
 	}
 	count_clusters = EXT4_NUM_B2C(sbi, count);
-	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
-	if (!bitmap_bh) {
-		err = -EIO;
+	err = ext4_read_block_bitmap(sb, block_group, &bitmap_bh);
+	if (err)
 		goto error_return;
-	}
 	gdp = ext4_get_group_desc(sb, block_group, &gd_bh);
 	if (!gdp) {
 		err = -EIO;
@@ -4930,11 +4932,9 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 		goto error_return;
 	}
 
-	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
-	if (!bitmap_bh) {
-		err = -EIO;
+	err = ext4_read_block_bitmap(sb, block_group, &bitmap_bh);
+	if (err)
 		goto error_return;
-	}
 
 	desc = ext4_get_group_desc(sb, block_group, &gd_bh);
 	if (!desc) {

