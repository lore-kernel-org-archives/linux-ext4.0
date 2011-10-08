From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 15/28] ext4: Calculate and verify block bitmap checksum
Date: Sat, 08 Oct 2011 00:55:22 -0700
Message-ID: <20111008075522.20506.22239.stgit@elm3c44.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Compute and verify the checksum of the block bitmap; this checksum is stored in
the block group descriptor.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/balloc.c  |   40 +++++++++++++++++++++------
 fs/ext4/bitmap.c  |   40 +++++++++++++++++++++++++++
 fs/ext4/ext4.h    |   10 +++++++
 fs/ext4/ialloc.c  |    4 +++
 fs/ext4/mballoc.c |   78 +++++++++++++++++++++++++++++++++++++++++++++--------
 5 files changed, 151 insertions(+), 21 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index f8224ad..dd96a7d 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -105,6 +105,9 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 			ext4_free_inodes_set(sb, gdp, 0);
 			ext4_itable_unused_set(sb, gdp, 0);
 			memset(bh->b_data, 0xff, sb->s_blocksize);
+			ext4_block_bitmap_csum_set(sb, block_group, gdp, bh,
+						   EXT4_BLOCKS_PER_GROUP(sb) /
+						   8);
 			return 0;
 		}
 		memset(bh->b_data, 0, sb->s_blocksize);
@@ -175,6 +178,10 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		 */
 		ext4_mark_bitmap_end(group_blocks, sb->s_blocksize * 8,
 				     bh->b_data);
+		ext4_block_bitmap_csum_set(sb, block_group, gdp, bh,
+					   EXT4_BLOCKS_PER_GROUP(sb) / 8);
+		gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group,
+							gdp);
 	}
 	return free_blocks - ext4_group_used_meta_blocks(sb, block_group, gdp);
 }
@@ -232,10 +239,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 	return desc;
 }
 
-static int ext4_valid_block_bitmap(struct super_block *sb,
-					struct ext4_group_desc *desc,
-					unsigned int block_group,
-					struct buffer_head *bh)
+int ext4_valid_block_bitmap(struct super_block *sb,
+			    struct ext4_group_desc *desc,
+			    unsigned int block_group,
+			    struct buffer_head *bh)
 {
 	ext4_grpblk_t offset;
 	ext4_grpblk_t next_zero_bit;
@@ -312,12 +319,12 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 	}
 
 	if (bitmap_uptodate(bh))
-		return bh;
+		goto verify;
 
 	lock_buffer(bh);
 	if (bitmap_uptodate(bh)) {
 		unlock_buffer(bh);
-		return bh;
+		goto verify;
 	}
 	ext4_lock_group(sb, block_group);
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
@@ -336,7 +343,7 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 		 */
 		set_bitmap_uptodate(bh);
 		unlock_buffer(bh);
-		return bh;
+		goto verify;
 	}
 	/*
 	 * submit the buffer_head for read. We can
@@ -353,11 +360,26 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	ext4_valid_block_bitmap(sb, desc, block_group, bh);
+
+verify:
+	if (buffer_verified(bh))
+		return bh;
 	/*
 	 * file system mounted not to panic on error,
-	 * continue with corrupt bitmap
+	 * -EIO with corrupt bitmap
 	 */
+	ext4_lock_group(sb, block_group);
+	if (!ext4_valid_block_bitmap(sb, desc, block_group, bh) ||
+	    !ext4_block_bitmap_csum_verify(sb, block_group, desc, bh,
+					   EXT4_BLOCKS_PER_GROUP(sb) / 8)) {
+		ext4_unlock_group(sb, block_group);
+		put_bh(bh);
+		ext4_error(sb, "Corrupt block bitmap - block_group = %u, "
+			   "block_bitmap = %llu", block_group, bitmap_blk);
+		return NULL;
+	}
+	ext4_unlock_group(sb, block_group);
+	set_buffer_verified(bh);
 	return bh;
 }
 
diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index e9342f6..00ebc7a 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -81,3 +81,43 @@ void ext4_inode_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
 	if (sbi->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION)
 		gdp->bg_inode_bitmap_csum_hi = cpu_to_le16(crc >> 16);
 }
+
+int ext4_block_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
+				  struct ext4_group_desc *gdp,
+				  struct buffer_head *bh, int sz)
+{
+	__u32 hi;
+	__u32 provided, calculated;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	provided = le16_to_cpu(gdp->bg_block_bitmap_csum_lo);
+	calculated = ext4_bitmap_csum(sb, group, bh, sz);
+	if (sbi->s_desc_size >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION) {
+		hi = le16_to_cpu(gdp->bg_block_bitmap_csum_hi);
+		provided |= (hi << 16);
+	} else
+		calculated &= 0xFFFF;
+
+	return provided == calculated;
+}
+
+void ext4_block_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
+				struct ext4_group_desc *gdp,
+				struct buffer_head *bh, int sz)
+{
+	__u32 crc;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	crc = ext4_bitmap_csum(sb, group, bh, sz);
+	gdp->bg_block_bitmap_csum_lo = cpu_to_le16(crc & 0xFFFF);
+	if (sbi->s_desc_size >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION)
+		gdp->bg_block_bitmap_csum_hi = cpu_to_le16(crc >> 16);
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c98bc9f..7cd3541 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1776,8 +1776,18 @@ void ext4_inode_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
 int ext4_inode_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
 				  struct ext4_group_desc *gdp,
 				  struct buffer_head *bh, int sz);
+void ext4_block_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
+				struct ext4_group_desc *gdp,
+				struct buffer_head *bh, int sz);
+int ext4_block_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
+				  struct ext4_group_desc *gdp,
+				  struct buffer_head *bh, int sz);
 
 /* balloc.c */
+extern int ext4_valid_block_bitmap(struct super_block *sb,
+				   struct ext4_group_desc *desc,
+				   unsigned int block_group,
+				   struct buffer_head *bh);
 extern unsigned int ext4_block_group(struct super_block *sb,
 			ext4_fsblk_t blocknr);
 extern ext4_grpblk_t ext4_block_group_offset(struct super_block *sb,
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 6fb00e7..77ae3df 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -981,6 +981,10 @@ got:
 			free = ext4_free_blocks_after_init(sb, group, gdp);
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 			ext4_free_blks_set(sb, gdp, free);
+			ext4_block_bitmap_csum_set(sb, group, gdp,
+						   block_bitmap_bh,
+						   EXT4_BLOCKS_PER_GROUP(sb) /
+						   8);
 			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
 								gdp);
 		}
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..3d6300a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -753,6 +753,44 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 	spin_unlock(&EXT4_SB(sb)->s_bal_lock);
 }
 
+struct ext4_csum_data {
+	struct super_block	*cd_sb;
+	ext4_group_t		cd_group;
+};
+
+static void ext4_end_buffer_read_sync(struct buffer_head *bh, int uptodate)
+{
+	struct ext4_group_desc *desc;
+	struct super_block *sb =
+		((struct ext4_csum_data *)bh->b_private)->cd_sb;
+	ext4_group_t group = ((struct ext4_csum_data *)bh->b_private)->cd_group;
+
+	if (!uptodate)
+		goto out;
+
+	desc = ext4_get_group_desc(sb, group, NULL);
+	if (!desc)
+		goto out;
+
+	if (buffer_verified(bh))
+		goto out;
+
+	ext4_lock_group(sb, group);
+	if (!ext4_valid_block_bitmap(sb, desc, group, bh) ||
+	    !ext4_block_bitmap_csum_verify(sb, group, desc, bh,
+					   EXT4_BLOCKS_PER_GROUP(sb) / 8)) {
+		ext4_unlock_group(sb, group);
+		ext4_error(sb, "Corrupt block bitmap, group = %u", group);
+		goto out;
+	}
+	ext4_unlock_group(sb, group);
+	set_buffer_verified(bh);
+
+out:
+	bh->b_private = NULL;
+	end_buffer_read_sync(bh, uptodate);
+}
+
 /* The buddy information is attached the buddy cache inode
  * for convenience. The information regarding each group
  * is loaded via ext4_mb_load_buddy. The information involve
@@ -785,11 +823,12 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 	int first_block;
 	struct super_block *sb;
 	struct buffer_head *bhs;
-	struct buffer_head **bh;
+	struct buffer_head **bh = NULL;
 	struct inode *inode;
 	char *data;
 	char *bitmap;
 	struct ext4_group_info *grinfo;
+	struct ext4_csum_data *csd;
 
 	mb_debug(1, "init page %lu\n", page->index);
 
@@ -803,6 +842,11 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 	if (groups_per_page == 0)
 		groups_per_page = 1;
 
+	csd = kzalloc(sizeof(struct ext4_csum_data) * groups_per_page,
+		      GFP_NOFS);
+	if (csd == NULL)
+		goto out;
+
 	/* allocate buffer_heads to read bitmaps */
 	if (groups_per_page > 1) {
 		err = -ENOMEM;
@@ -880,22 +924,25 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		 * get set with buffer lock held.
 		 */
 		set_bitmap_uptodate(bh[i]);
-		bh[i]->b_end_io = end_buffer_read_sync;
+		csd[i].cd_sb = sb;
+		csd[i].cd_group = first_group + i;
+		bh[i]->b_private = csd + i;
+		bh[i]->b_end_io = ext4_end_buffer_read_sync;
 		submit_bh(READ, bh[i]);
 		mb_debug(1, "read bitmap for group %u\n", first_group + i);
 	}
 
-	/* wait for I/O completion */
-	for (i = 0; i < groups_per_page; i++)
-		if (bh[i])
-			wait_on_buffer(bh[i]);
-
-	err = -EIO;
-	for (i = 0; i < groups_per_page; i++)
-		if (bh[i] && !buffer_uptodate(bh[i]))
-			goto out;
-
+	/* Wait for I/O completion and checksum verification */
 	err = 0;
+	for (i = 0; i < groups_per_page; i++) {
+		if (bh[i] == NULL)
+			continue;
+		wait_on_buffer(bh[i]);
+		if (!buffer_uptodate(bh[i]) ||
+		    !buffer_verified(bh[i]))
+			err = -EIO;
+	}
+
 	first_block = page->index * blocks_per_page;
 	for (i = 0; i < blocks_per_page; i++) {
 		int group;
@@ -972,6 +1019,7 @@ out:
 		if (bh != &bhs)
 			kfree(bh);
 	}
+	kfree(csd);
 	return err;
 }
 
@@ -2829,6 +2877,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	}
 	len = ext4_free_blks_count(sb, gdp) - ac->ac_b_ex.fe_len;
 	ext4_free_blks_set(sb, gdp, len);
+	ext4_block_bitmap_csum_set(sb, ac->ac_b_ex.fe_group, gdp, bitmap_bh,
+				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
@@ -4638,6 +4688,8 @@ do_more:
 
 	ret = ext4_free_blks_count(sb, gdp) + count;
 	ext4_free_blks_set(sb, gdp, ret);
+	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
+				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeblocks_counter, count);
@@ -4780,6 +4832,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	mb_free_blocks(NULL, &e4b, bit, count);
 	blk_free_count = blocks_freed + ext4_free_blks_count(sb, desc);
 	ext4_free_blks_set(sb, desc, blk_free_count);
+	ext4_block_bitmap_csum_set(sb, block_group, desc, bitmap_bh,
+				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
 	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeblocks_counter, blocks_freed);
