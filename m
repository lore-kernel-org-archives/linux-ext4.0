From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 08/22] ext4: Calculate and verify checksums for inode bitmaps
Date: Mon, 28 Nov 2011 15:27:10 -0800
Message-ID: <20111128232710.19194.97716.stgit@elm3c44.beaverton.ibm.com>
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

Compute and verify the checksum of the inode bitmap; the checkum is stored in
the block group descriptor.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/bitmap.c |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   |   22 ++++++++++++++++++++--
 fs/ext4/ialloc.c |   30 +++++++++++++++++++++++++++---
 3 files changed, 87 insertions(+), 5 deletions(-)


diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index 285d23a..efb918f 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -42,3 +42,43 @@ static __u32 ext4_bitmap_csum(struct super_block *sb, ext4_group_t group,
 
 	return csum;
 }
+
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
+	calculated = ext4_bitmap_csum(sb, group, bh, sz);
+	if (sbi->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION) {
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
+	csum = ext4_bitmap_csum(sb, group, bh, sz);
+	gdp->bg_inode_bitmap_csum_lo = cpu_to_le16(csum & 0xFFFF);
+	if (sbi->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION)
+		gdp->bg_inode_bitmap_csum_hi = cpu_to_le16(csum >> 16);
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6953d9f..97b617d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -290,7 +290,9 @@ struct ext4_group_desc
 	__le16	bg_free_inodes_count_lo;/* Free inodes count */
 	__le16	bg_used_dirs_count_lo;	/* Directories count */
 	__le16	bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
-	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
+	__le32  bg_exclude_bitmap_lo;   /* Exclude bitmap for snapshots */
+	__le16  bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bbitmap) LE */
+	__le16  bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+ibitmap) LE */
 	__le16  bg_itable_unused_lo;	/* Unused inodes count */
 	__le16  bg_checksum;		/* crc16(sb_uuid+group+desc) */
 	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
@@ -300,9 +302,19 @@ struct ext4_group_desc
 	__le16	bg_free_inodes_count_hi;/* Free inodes count MSB */
 	__le16	bg_used_dirs_count_hi;	/* Directories count MSB */
 	__le16  bg_itable_unused_hi;    /* Unused inodes count MSB */
-	__u32	bg_reserved2[3];
+	__le32  bg_exclude_bitmap_hi;   /* Exclude bitmap block MSB */
+	__le16  bg_block_bitmap_csum_hi;/* crc32c(s_uuid+grp_num+bbitmap) BE */
+	__le16  bg_inode_bitmap_csum_hi;/* crc32c(s_uuid+grp_num+ibitmap) BE */
+	__u32   bg_reserved;
 };
 
+#define EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION	\
+	(offsetof(struct ext4_group_desc, bg_inode_bitmap_csum_hi) + \
+	 sizeof(__le16))
+#define EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION	\
+	(offsetof(struct ext4_group_desc, bg_block_bitmap_csum_hi) + \
+	 sizeof(__le16))
+
 /*
  * Structure of a flex block group info
  */
@@ -1795,6 +1807,12 @@ struct mmpd_data {
 
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
index 6151a68..3bddfe3 100644
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
