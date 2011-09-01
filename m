From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 09/16] ext4: Calculate and verify block bitmap checksum
Date: Wed, 31 Aug 2011 17:31:34 -0700
Message-ID: <20110901003134.31048.23806.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
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
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Compute and verify the checksum of the block bitmap; this checksum is stored in
the block group descriptor.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/balloc.c  |   43 ++++++++++++++++++++++++++++++++++---------
 fs/ext4/ext4.h    |    7 ++++++-
 fs/ext4/ialloc.c  |    5 +++++
 fs/ext4/mballoc.c |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+), 10 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index f8224ad..36d3020 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -105,6 +105,10 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 			ext4_free_inodes_set(sb, gdp, 0);
 			ext4_itable_unused_set(sb, gdp, 0);
 			memset(bh->b_data, 0xff, sb->s_blocksize);
+			ext4_bitmap_csum_set(sb, block_group,
+					     &gdp->bg_block_bitmap_csum, bh,
+					     (EXT4_BLOCKS_PER_GROUP(sb) + 7) /
+					     8);
 			return 0;
 		}
 		memset(bh->b_data, 0, sb->s_blocksize);
@@ -175,6 +179,11 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		 */
 		ext4_mark_bitmap_end(group_blocks, sb->s_blocksize * 8,
 				     bh->b_data);
+		ext4_bitmap_csum_set(sb, block_group,
+				     &gdp->bg_block_bitmap_csum, bh,
+				     (EXT4_BLOCKS_PER_GROUP(sb) + 7) / 8);
+		gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group,
+							gdp);
 	}
 	return free_blocks - ext4_group_used_meta_blocks(sb, block_group, gdp);
 }
@@ -232,10 +241,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
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
@@ -312,12 +321,12 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
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
@@ -336,7 +345,7 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 		 */
 		set_bitmap_uptodate(bh);
 		unlock_buffer(bh);
-		return bh;
+		goto verify;
 	}
 	/*
 	 * submit the buffer_head for read. We can
@@ -353,11 +362,27 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
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
+	    !ext4_bitmap_csum_verify(sb, block_group,
+				     desc->bg_block_bitmap_csum, bh,
+				     (EXT4_BLOCKS_PER_GROUP(sb) + 7) / 8)) {
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
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 248cbd2..df149b3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -269,7 +269,8 @@ struct ext4_group_desc
 	__le16	bg_free_inodes_count_lo;/* Free inodes count */
 	__le16	bg_used_dirs_count_lo;	/* Directories count */
 	__le16	bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
-	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
+	__u32	bg_reserved[1];		/* unclaimed */
+	__le32	bg_block_bitmap_csum;	/* crc32c(uuid+group+bbitmap) */
 	__le16  bg_itable_unused_lo;	/* Unused inodes count */
 	__le16  bg_checksum;		/* crc16(sb_uuid+group+desc) */
 	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
@@ -1731,6 +1732,10 @@ void ext4_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
 			  __le32 *csum, struct buffer_head *bh, int sz);
 
 /* balloc.c */
+extern int ext4_valid_block_bitmap(struct super_block *sb,
+				   struct ext4_group_desc *desc,
+				   unsigned int block_group,
+				   struct buffer_head *bh);
 extern unsigned int ext4_block_group(struct super_block *sb,
 			ext4_fsblk_t blocknr);
 extern ext4_grpblk_t ext4_block_group_offset(struct super_block *sb,
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 53faffc..a335d19 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -984,6 +984,11 @@ got:
 			free = ext4_free_blocks_after_init(sb, group, gdp);
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 			ext4_free_blks_set(sb, gdp, free);
+			ext4_bitmap_csum_set(sb, group,
+					     &gdp->bg_block_bitmap_csum,
+					     block_bitmap_bh,
+					     (EXT4_BLOCKS_PER_GROUP(sb) + 7) /
+					     8);
 			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
 								gdp);
 		}
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..8dc3055 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -895,6 +895,33 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		if (bh[i] && !buffer_uptodate(bh[i]))
 			goto out;
 
+	for (i = 0; i < groups_per_page; i++) {
+		struct ext4_group_desc *desc;
+
+		if (!bh[i] || !bh[i]->b_end_io)
+			continue;
+		desc = ext4_get_group_desc(sb, first_group + i, NULL);
+		if (!desc)
+			goto out;
+
+		if (buffer_verified(bh[i]))
+			continue;
+		ext4_lock_group(sb, first_group + i);
+		if (!ext4_valid_block_bitmap(sb, desc, first_group + i,
+					     bh[i]) ||
+		    !ext4_bitmap_csum_verify(sb, first_group + i,
+					     desc->bg_block_bitmap_csum, bh[i],
+					     (EXT4_BLOCKS_PER_GROUP(sb) + 7) /
+					      8)) {
+			ext4_unlock_group(sb, first_group + i);
+			ext4_error(sb, "Corrupt block bitmap, group = %u",
+				   first_group + i);
+			goto out;
+		}
+		ext4_unlock_group(sb, first_group + i);
+		set_buffer_verified(bh[i]);
+	}
+
 	err = 0;
 	first_block = page->index * blocks_per_page;
 	for (i = 0; i < blocks_per_page; i++) {
@@ -2829,6 +2856,9 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	}
 	len = ext4_free_blks_count(sb, gdp) - ac->ac_b_ex.fe_len;
 	ext4_free_blks_set(sb, gdp, len);
+	ext4_bitmap_csum_set(sb, ac->ac_b_ex.fe_group,
+			     &gdp->bg_block_bitmap_csum, bitmap_bh,
+			     (EXT4_BLOCKS_PER_GROUP(sb) + 7) / 8);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
@@ -4638,6 +4668,8 @@ do_more:
 
 	ret = ext4_free_blks_count(sb, gdp) + count;
 	ext4_free_blks_set(sb, gdp, ret);
+	ext4_bitmap_csum_set(sb, block_group, &gdp->bg_block_bitmap_csum,
+			     bitmap_bh, (EXT4_BLOCKS_PER_GROUP(sb) + 7) / 8);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeblocks_counter, count);
@@ -4780,6 +4812,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	mb_free_blocks(NULL, &e4b, bit, count);
 	blk_free_count = blocks_freed + ext4_free_blks_count(sb, desc);
 	ext4_free_blks_set(sb, desc, blk_free_count);
+	ext4_bitmap_csum_set(sb, block_group, &desc->bg_block_bitmap_csum,
+			     bitmap_bh, (EXT4_BLOCKS_PER_GROUP(sb) + 7) / 8);
 	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeblocks_counter, blocks_freed);
