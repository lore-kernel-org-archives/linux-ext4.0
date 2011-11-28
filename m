From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 14/22] ext4: Add new feature to make block group checksums use
	metadata_csum algorithm
Date: Mon, 28 Nov 2011 15:27:53 -0800
Message-ID: <20111128232753.19194.18109.stgit@elm3c44.beaverton.ibm.com>
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

Add a new feature flag to enable block group descriptors to use the (faster)
metadata_csum checksum algorithm.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/balloc.c  |    2 +-
 fs/ext4/ext4.h    |    8 ++++---
 fs/ext4/ialloc.c  |   11 ++++-----
 fs/ext4/mballoc.c |    6 ++---
 fs/ext4/resize.c  |    2 +-
 fs/ext4/super.c   |   65 ++++++++++++++++++++++++++++++++++++++---------------
 6 files changed, 62 insertions(+), 32 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index dcac4bd..300f751 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -212,7 +212,7 @@ void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 			     sb->s_blocksize * 8, bh->b_data);
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bh,
 				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
+	ext4_group_desc_csum_set(sbi, block_group, gdp);
 }
 
 /* Return the number of free blocks in a block group.  It is used when
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5efa492..a9a14b3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1437,6 +1437,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400 /* EA in inode */
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000 /* data in dirent */
+#define EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM	0x2000
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -1460,7 +1461,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
-					 EXT4_FEATURE_INCOMPAT_MMP)
+					 EXT4_FEATURE_INCOMPAT_MMP| \
+					 EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
@@ -2085,10 +2087,10 @@ extern void ext4_used_dirs_set(struct super_block *sb,
 				struct ext4_group_desc *bg, __u32 count);
 extern void ext4_itable_unused_set(struct super_block *sb,
 				   struct ext4_group_desc *bg, __u32 count);
-extern __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 group,
-				   struct ext4_group_desc *gdp);
 extern int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 group,
 				       struct ext4_group_desc *gdp);
+extern void ext4_group_desc_csum_set(struct ext4_sb_info *sbi, __u32 group,
+				     struct ext4_group_desc *gdp);
 
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 {
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 8c8b61e..f2479fd 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -92,7 +92,7 @@ static unsigned ext4_init_inode_bitmap(struct super_block *sb,
 			bh->b_data);
 	ext4_inode_bitmap_csum_set(sb, block_group, gdp, bh,
 				   EXT4_INODES_PER_GROUP(sb) / 8);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
+	ext4_group_desc_csum_set(sbi, block_group, gdp);
 
 	return EXT4_INODES_PER_GROUP(sb);
 }
@@ -287,7 +287,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	}
 	ext4_inode_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
 				   EXT4_INODES_PER_GROUP(sb) / 8);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
+	ext4_group_desc_csum_set(sbi, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 
 	percpu_counter_inc(&sbi->s_freeinodes_counter);
@@ -697,7 +697,7 @@ static int ext4_claim_inode(struct super_block *sb,
 	}
 	ext4_inode_bitmap_csum_set(sb, group, gdp, inode_bitmap_bh,
 				   EXT4_INODES_PER_GROUP(sb) / 8);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
+	ext4_group_desc_csum_set(sbi, group, gdp);
 err_ret:
 	ext4_unlock_group(sb, group);
 	up_read(&grp->alloc_sem);
@@ -858,8 +858,7 @@ got:
 						   block_bitmap_bh,
 						   EXT4_BLOCKS_PER_GROUP(sb) /
 						   8);
-			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
-								gdp);
+			ext4_group_desc_csum_set(sbi, group, gdp);
 		}
 		ext4_unlock_group(sb, group);
 
@@ -1223,7 +1222,7 @@ int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 skip_zeroout:
 	ext4_lock_group(sb, group);
 	gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_ZEROED);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
+	ext4_group_desc_csum_set(sbi, group, gdp);
 	ext4_unlock_group(sb, group);
 
 	BUFFER_TRACE(group_desc_bh,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index dbd1453..2bbd9ee 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2919,7 +2919,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	ext4_free_group_clusters_set(sb, gdp, len);
 	ext4_block_bitmap_csum_set(sb, ac->ac_b_ex.fe_group, gdp, bitmap_bh,
 				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
+	ext4_group_desc_csum_set(sbi, ac->ac_b_ex.fe_group, gdp);
 
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
 	percpu_counter_sub(&sbi->s_freeclusters_counter, ac->ac_b_ex.fe_len);
@@ -4787,7 +4787,7 @@ do_more:
 	ext4_free_group_clusters_set(sb, gdp, ret);
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
 				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
+	ext4_group_desc_csum_set(sbi, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
 
@@ -4933,7 +4933,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	ext4_free_group_clusters_set(sb, desc, blk_free_count);
 	ext4_block_bitmap_csum_set(sb, block_group, desc, bitmap_bh,
 				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
-	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
+	ext4_group_desc_csum_set(sbi, block_group, desc);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter,
 			   EXT4_B2C(sbi, blocks_freed));
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index c33b72a..083f429 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -880,7 +880,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	ext4_free_group_clusters_set(sb, gdp, input->free_blocks_count);
 	ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
 	gdp->bg_flags = cpu_to_le16(EXT4_BG_INODE_ZEROED);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
+	ext4_group_desc_csum_set(sbi, input->group, gdp);
 
 	/*
 	 * We can allocate memory for mb_alloc based on the new group
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4fb8d9a..8f6dd82 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2092,29 +2092,49 @@ failed:
 	return 0;
 }
 
-__le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
-			    struct ext4_group_desc *gdp)
+static __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
+				   struct ext4_group_desc *gdp)
 {
+	int offset;
 	__u16 crc = 0;
+	__le32 le_group = cpu_to_le32(block_group);
 
-	if (sbi->s_es->s_feature_ro_compat &
-	    cpu_to_le32(EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
-		int offset = offsetof(struct ext4_group_desc, bg_checksum);
-		__le32 le_group = cpu_to_le32(block_group);
-
-		crc = crc16(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
-		crc = crc16(crc, (__u8 *)&le_group, sizeof(le_group));
-		crc = crc16(crc, (__u8 *)gdp, offset);
-		offset += sizeof(gdp->bg_checksum); /* skip checksum */
-		/* for checksum of struct ext4_group_desc do the rest...*/
-		if ((sbi->s_es->s_feature_incompat &
-		     cpu_to_le32(EXT4_FEATURE_INCOMPAT_64BIT)) &&
-		    offset < le16_to_cpu(sbi->s_es->s_desc_size))
-			crc = crc16(crc, (__u8 *)gdp + offset,
-				    le16_to_cpu(sbi->s_es->s_desc_size) -
-					offset);
+	if ((sbi->s_es->s_feature_ro_compat &
+	     cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) &&
+	    (sbi->s_es->s_feature_incompat &
+	     cpu_to_le32(EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM))) {
+		/* Use new metadata_csum algorithm */
+		__u16 old_csum;
+		__u32 csum32;
+
+		old_csum = gdp->bg_checksum;
+		gdp->bg_checksum = 0;
+		csum32 = ext4_chksum(sbi, sbi->s_uuid_csum, (__u8 *)&le_group,
+				     sizeof(le_group));
+		csum32 = ext4_chksum(sbi, csum32, (__u8 *)gdp,
+				     sbi->s_desc_size);
+		gdp->bg_checksum = old_csum;
+
+		crc = csum32 & 0xFFFF;
+		goto out;
 	}
 
+	/* old crc16 code */
+	offset = offsetof(struct ext4_group_desc, bg_checksum);
+
+	crc = crc16(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
+	crc = crc16(crc, (__u8 *)&le_group, sizeof(le_group));
+	crc = crc16(crc, (__u8 *)gdp, offset);
+	offset += sizeof(gdp->bg_checksum); /* skip checksum */
+	/* for checksum of struct ext4_group_desc do the rest...*/
+	if ((sbi->s_es->s_feature_incompat &
+	     cpu_to_le32(EXT4_FEATURE_INCOMPAT_64BIT)) &&
+	    offset < le16_to_cpu(sbi->s_es->s_desc_size))
+		crc = crc16(crc, (__u8 *)gdp + offset,
+			    le16_to_cpu(sbi->s_es->s_desc_size) -
+				offset);
+
+out:
 	return cpu_to_le16(crc);
 }
 
@@ -2129,6 +2149,15 @@ int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 block_group,
 	return 1;
 }
 
+void ext4_group_desc_csum_set(struct ext4_sb_info *sbi, __u32 block_group,
+			      struct ext4_group_desc *gdp)
+{
+	if (!(sbi->s_es->s_feature_ro_compat &
+	     cpu_to_le32(EXT4_FEATURE_RO_COMPAT_GDT_CSUM)))
+		return;
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
+}
+
 /* Called at mount-time, super-block is locked */
 static int ext4_check_descriptors(struct super_block *sb,
 				  ext4_group_t *first_not_zeroed)
