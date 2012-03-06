From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 07/23] ext4: Calculate and verify checksums for inode bitmaps
Date: Tue, 06 Mar 2012 12:48:41 -0800
Message-ID: <20120306204841.1663.55483.stgit@elm3b70.beaverton.ibm.com>
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35409 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031059Ab2CFUs5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 15:48:57 -0500
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 15:48:56 -0500
In-Reply-To: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Compute and verify the checksum of the inode bitmap; the checkum is stored in
the block group descriptor.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/bitmap.c |   39 +++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   |   13 +++++++++++++
 fs/ext4/ialloc.c |   30 +++++++++++++++++++++++++++---
 fs/ext4/resize.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 126 insertions(+), 3 deletions(-)


diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index fa3af81..0ae4a01 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -29,3 +29,42 @@ unsigned int ext4_count_free(struct buffer_head *map, unsigned int numchars)
 
 #endif  /*  EXT4FS_DEBUG  */
 
+int ext4_inode_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
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
+	provided = le16_to_cpu(gdp->bg_inode_bitmap_csum_lo);
+	calculated = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
+	if (sbi->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_END) {
+		hi = le16_to_cpu(gdp->bg_inode_bitmap_csum_hi);
+		provided |= (hi << 16);
+	} else
+		calculated &= 0xFFFF;
+
+	return provided == calculated;
+}
+
+void ext4_inode_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
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
+	csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
+	gdp->bg_inode_bitmap_csum_lo = cpu_to_le16(csum & 0xFFFF);
+	if (sbi->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_END)
+		gdp->bg_inode_bitmap_csum_hi = cpu_to_le16(csum >> 16);
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e2bd9b9..16b6bb1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -308,6 +308,13 @@ struct ext4_group_desc
 	__u32   bg_reserved;
 };
 
+#define EXT4_BG_INODE_BITMAP_CSUM_HI_END	\
+	(offsetof(struct ext4_group_desc, bg_inode_bitmap_csum_hi) + \
+	 sizeof(__le16))
+#define EXT4_BG_BLOCK_BITMAP_CSUM_HI_END	\
+	(offsetof(struct ext4_group_desc, bg_block_bitmap_csum_hi) + \
+	 sizeof(__le16))
+
 /*
  * Structure of a flex block group info
  */
@@ -1832,6 +1839,12 @@ struct mmpd_data {
 
 /* bitmap.c */
 extern unsigned int ext4_count_free(struct buffer_head *, unsigned);
+void ext4_inode_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
+				struct ext4_group_desc *gdp,
+				struct buffer_head *bh, int sz);
+int ext4_inode_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
+				  struct ext4_group_desc *gdp,
+				  struct buffer_head *bh, int sz);
 
 /* balloc.c */
 extern unsigned int ext4_block_group(struct super_block *sb,
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 0ee26c4..e87a49a 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -82,12 +82,17 @@ static unsigned ext4_init_inode_bitmap(struct super_block *sb,
 		ext4_free_inodes_set(sb, gdp, 0);
 		ext4_itable_unused_set(sb, gdp, 0);
 		memset(bh->b_data, 0xff, sb->s_blocksize);
+		ext4_inode_bitmap_csum_set(sb, block_group, gdp, bh,
+					   EXT4_INODES_PER_GROUP(sb) / 8);
 		return 0;
 	}
 
 	memset(bh->b_data, 0, (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
 	ext4_mark_bitmap_end(EXT4_INODES_PER_GROUP(sb), sb->s_blocksize * 8,
 			bh->b_data);
+	ext4_inode_bitmap_csum_set(sb, block_group, gdp, bh,
+				   EXT4_INODES_PER_GROUP(sb) / 8);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 
 	return EXT4_INODES_PER_GROUP(sb);
 }
@@ -118,12 +123,12 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		return NULL;
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
@@ -131,6 +136,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
 		set_bitmap_uptodate(bh);
 		set_buffer_uptodate(bh);
+		set_buffer_verified(bh);
 		ext4_unlock_group(sb, block_group);
 		unlock_buffer(bh);
 		return bh;
@@ -144,7 +150,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		 */
 		set_bitmap_uptodate(bh);
 		unlock_buffer(bh);
-		return bh;
+		goto verify;
 	}
 	/*
 	 * submit the buffer_head for read. We can
@@ -161,6 +167,20 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
+
+verify:
+	ext4_lock_group(sb, block_group);
+	if (!buffer_verified(bh) &&
+	    !ext4_inode_bitmap_csum_verify(sb, block_group, desc, bh,
+					   EXT4_INODES_PER_GROUP(sb) / 8)) {
+		ext4_unlock_group(sb, block_group);
+		put_bh(bh);
+		ext4_error(sb, "Corrupt inode bitmap - block_group = %u, "
+			   "inode_bitmap = %llu", block_group, bitmap_blk);
+		return NULL;
+	}
+	ext4_unlock_group(sb, block_group);
+	set_buffer_verified(bh);
 	return bh;
 }
 
@@ -265,6 +285,8 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 		ext4_used_dirs_set(sb, gdp, count);
 		percpu_counter_dec(&sbi->s_dirs_counter);
 	}
+	ext4_inode_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
+				   EXT4_INODES_PER_GROUP(sb) / 8);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 
@@ -673,6 +695,8 @@ static int ext4_claim_inode(struct super_block *sb,
 			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
 		}
 	}
+	ext4_inode_bitmap_csum_set(sb, group, gdp, inode_bitmap_bh,
+				   EXT4_INODES_PER_GROUP(sb) / 8);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
 err_ret:
 	ext4_unlock_group(sb, group);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 20c0a54..0953f07 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1069,6 +1069,47 @@ static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
 	return err;
 }
 
+static struct buffer_head *ext4_get_bitmap(struct super_block *sb, __u64 block)
+{
+	struct buffer_head *bh = sb_getblk(sb, block);
+	if (!bh)
+		return NULL;
+
+	if (bitmap_uptodate(bh))
+		return bh;
+
+	lock_buffer(bh);
+	if (bh_submit_read(bh) < 0) {
+		unlock_buffer(bh);
+		brelse(bh);
+		return NULL;
+	}
+	unlock_buffer(bh);
+
+	return bh;
+}
+
+static int ext4_set_bitmap_checksums(struct super_block *sb,
+				     ext4_group_t group,
+				     struct ext4_group_desc *gdp,
+				     struct ext4_new_group_data *group_data)
+{
+	struct buffer_head *bh;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	bh = ext4_get_bitmap(sb, group_data->inode_bitmap);
+	if (!bh)
+		return -EIO;
+	ext4_inode_bitmap_csum_set(sb, group, gdp, bh,
+				   EXT4_INODES_PER_GROUP(sb) / 8);
+	brelse(bh);
+
+	return 0;
+}
+
 /*
  * ext4_setup_new_descs() will set up the group descriptor descriptors of a flex bg
  */
@@ -1101,6 +1142,12 @@ static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
 		memset(gdp, 0, EXT4_DESC_SIZE(sb));
 		ext4_block_bitmap_set(sb, gdp, group_data->block_bitmap);
 		ext4_inode_bitmap_set(sb, gdp, group_data->inode_bitmap);
+		err = ext4_set_bitmap_checksums(sb, group, gdp, group_data);
+		if (err) {
+			ext4_std_error(sb, err);
+			break;
+		}
+
 		ext4_inode_table_set(sb, gdp, group_data->inode_table);
 		ext4_free_group_clusters_set(sb, gdp,
 					     EXT4_B2C(sbi, group_data->free_blocks_count));

