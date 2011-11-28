From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 09/22] ext4: Calculate and verify block bitmap checksum
Date: Mon, 28 Nov 2011 15:27:18 -0800
Message-ID: <20111128232718.19194.61327.stgit@elm3c44.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
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
In-Reply-To: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Compute and verify the checksum of the block bitmap; this checksum is stored in
the block group descriptor.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/balloc.c  |   38 ++++++++++++++++----
 fs/ext4/bitmap.c  |   40 +++++++++++++++++++++
 fs/ext4/ext4.h    |   10 +++++
 fs/ext4/ialloc.c  |    4 ++
 fs/ext4/mballoc.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++-------
 5 files changed, 169 insertions(+), 22 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 12ccacd..dcac4bd 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -172,6 +172,8 @@ void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		ext4_free_inodes_set(sb, gdp, 0);
 		ext4_itable_unused_set(sb, gdp, 0);
 		memset(bh->b_data, 0xff, sb->s_blocksize);
+		ext4_block_bitmap_csum_set(sb, block_group, gdp, bh,
+					   EXT4_BLOCKS_PER_GROUP(sb) / 8);
 		return;
 	}
 	memset(bh->b_data, 0, sb->s_blocksize);
@@ -208,6 +210,9 @@ void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 	 */
 	ext4_mark_bitmap_end(num_clusters_in_group(sb, block_group),
 			     sb->s_blocksize * 8, bh->b_data);
+	ext4_block_bitmap_csum_set(sb, block_group, gdp, bh,
+				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 }
 
 /* Return the number of free blocks in a block group.  It is used when
@@ -273,10 +278,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
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
@@ -353,12 +358,12 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
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
@@ -377,7 +382,7 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 		 */
 		set_bitmap_uptodate(bh);
 		unlock_buffer(bh);
-		return bh;
+		goto verify;
 	}
 	/*
 	 * submit the buffer_head for read. We can
@@ -394,11 +399,26 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
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
index efb918f..7fd5d1c 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -82,3 +82,43 @@ void ext4_inode_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
 	if (sbi->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION)
 		gdp->bg_inode_bitmap_csum_hi = cpu_to_le16(csum >> 16);
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
+	__u32 csum;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	csum = ext4_bitmap_csum(sb, group, bh, sz);
+	gdp->bg_block_bitmap_csum_lo = cpu_to_le16(csum & 0xFFFF);
+	if (sbi->s_desc_size >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION)
+		gdp->bg_block_bitmap_csum_hi = cpu_to_le16(csum >> 16);
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 97b617d..9b5871b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1813,8 +1813,18 @@ void ext4_inode_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
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
index 3bddfe3..8c8b61e 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -854,6 +854,10 @@ got:
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 			ext4_free_group_clusters_set(sb, gdp,
 				ext4_free_clusters_after_init(sb, group, gdp));
+			ext4_block_bitmap_csum_set(sb, group, gdp,
+						   block_bitmap_bh,
+						   EXT4_BLOCKS_PER_GROUP(sb) /
+						   8);
 			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
 								gdp);
 		}
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2d8be8..dbd1453 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -754,6 +754,53 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 	spin_unlock(&EXT4_SB(sb)->s_bal_lock);
 }
 
+static void ext4_mb_verify_block_bitmap(struct super_block *sb,
+					ext4_group_t group,
+					struct buffer_head *bh)
+{
+	struct ext4_group_desc *desc;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	if (buffer_verified(bh))
+		return;
+
+	desc = ext4_get_group_desc(sb, group, NULL);
+	if (!desc)
+		return;
+
+	ext4_lock_group(sb, group);
+	if (!ext4_valid_block_bitmap(sb, desc, group, bh) ||
+	    !ext4_block_bitmap_csum_verify(sb, group, desc, bh,
+					   EXT4_BLOCKS_PER_GROUP(sb) / 8)) {
+		ext4_unlock_group(sb, group);
+		ext4_error(sb, "Corrupt block bitmap, group = %u", group);
+		return;
+	}
+	set_buffer_verified(bh);
+	ext4_unlock_group(sb, group);
+}
+
+struct ext4_csum_data {
+	struct super_block	*cd_sb;
+	ext4_group_t		cd_group;
+};
+
+static void ext4_end_buffer_read_sync(struct buffer_head *bh, int uptodate)
+{
+	struct super_block *sb =
+		((struct ext4_csum_data *)bh->b_private)->cd_sb;
+	ext4_group_t group = ((struct ext4_csum_data *)bh->b_private)->cd_group;
+
+	if (uptodate)
+		ext4_mb_verify_block_bitmap(sb, group, bh);
+
+	bh->b_private = NULL;
+	end_buffer_read_sync(bh, uptodate);
+}
+
 /* The buddy information is attached the buddy cache inode
  * for convenience. The information regarding each group
  * is loaded via ext4_mb_load_buddy. The information involve
@@ -786,11 +833,12 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 	int first_block;
 	struct super_block *sb;
 	struct buffer_head *bhs;
-	struct buffer_head **bh;
+	struct buffer_head **bh = NULL;
 	struct inode *inode;
 	char *data;
 	char *bitmap;
 	struct ext4_group_info *grinfo;
+	struct ext4_csum_data *csd = NULL;
 
 	mb_debug(1, "init page %lu\n", page->index);
 
@@ -804,6 +852,14 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 	if (groups_per_page == 0)
 		groups_per_page = 1;
 
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		csd = kzalloc(sizeof(struct ext4_csum_data) * groups_per_page,
+			      GFP_NOFS);
+		if (csd == NULL)
+			goto out;
+	}
+
 	/* allocate buffer_heads to read bitmaps */
 	if (groups_per_page > 1) {
 		err = -ENOMEM;
@@ -845,11 +901,13 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		if (bh[i] == NULL)
 			goto out;
 
-		if (bitmap_uptodate(bh[i]))
+		if (bitmap_uptodate(bh[i]) &&
+		    (csd && buffer_verified(bh[i])))
 			continue;
 
 		lock_buffer(bh[i]);
 		if (bitmap_uptodate(bh[i])) {
+			ext4_mb_verify_block_bitmap(sb, first_group + i, bh[i]);
 			unlock_buffer(bh[i]);
 			continue;
 		}
@@ -860,6 +918,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			set_bitmap_uptodate(bh[i]);
 			set_buffer_uptodate(bh[i]);
 			ext4_unlock_group(sb, first_group + i);
+			ext4_mb_verify_block_bitmap(sb, first_group + i, bh[i]);
 			unlock_buffer(bh[i]);
 			continue;
 		}
@@ -870,6 +929,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			 * bitmap is also uptodate
 			 */
 			set_bitmap_uptodate(bh[i]);
+			ext4_mb_verify_block_bitmap(sb, first_group + i, bh[i]);
 			unlock_buffer(bh[i]);
 			continue;
 		}
@@ -881,22 +941,28 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		 * get set with buffer lock held.
 		 */
 		set_bitmap_uptodate(bh[i]);
-		bh[i]->b_end_io = end_buffer_read_sync;
+		if (csd) {
+			csd[i].cd_sb = sb;
+			csd[i].cd_group = first_group + i;
+			bh[i]->b_private = csd + i;
+			bh[i]->b_end_io = ext4_end_buffer_read_sync;
+		} else
+			bh[i]->b_end_io = end_buffer_read_sync;
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
+		    (csd && !buffer_verified(bh[i])))
+			err = -EIO;
+	}
+
 	first_block = page->index * blocks_per_page;
 	for (i = 0; i < blocks_per_page; i++) {
 		int group;
@@ -973,6 +1039,7 @@ out:
 		if (bh != &bhs)
 			kfree(bh);
 	}
+	kfree(csd);
 	return err;
 }
 
@@ -2850,6 +2917,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	}
 	len = ext4_free_group_clusters(sb, gdp) - ac->ac_b_ex.fe_len;
 	ext4_free_group_clusters_set(sb, gdp, len);
+	ext4_block_bitmap_csum_set(sb, ac->ac_b_ex.fe_group, gdp, bitmap_bh,
+				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
@@ -4716,6 +4785,8 @@ do_more:
 
 	ret = ext4_free_group_clusters(sb, gdp) + count_clusters;
 	ext4_free_group_clusters_set(sb, gdp, ret);
+	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
+				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
@@ -4860,6 +4931,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	mb_free_blocks(NULL, &e4b, bit, count);
 	blk_free_count = blocks_freed + ext4_free_group_clusters(sb, desc);
 	ext4_free_group_clusters_set(sb, desc, blk_free_count);
+	ext4_block_bitmap_csum_set(sb, block_group, desc, bitmap_bh,
+				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
 	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter,
