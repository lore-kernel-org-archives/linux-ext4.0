From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC] ext4: Rework metadata_csum/gdt_csum flag handling in kernel
Date: Tue, 28 Feb 2012 17:32:42 -0800
Message-ID: <20120229013242.GE15164@tux1.beaverton.ibm.com>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com> <20120107082919.21970.99182.stgit@elm3c44.beaverton.ibm.com> <8ED6E1F9-DB56-4D31-BCA8-2A3A8D514BD5@dilger.ca> <20120213222828.GF21641@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120213222828.GF21641@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ok, I've reworked the block group descriptor checksum handling code per this
email thread.  INCOMPAT_BG_USE_META_CSUM is gone.  METADATA_CSUM implies (and
in fact overrides) GDT_CSUM, though the group descriptor checksum uses the same
function as all other metadata blocks' checksums (by default crc32c).  I
created a helper function to determine if group descriptor checksums are
enabled, and the actual gdt checksum verify/set functions are smart enough to
use the correct function.

Below are the changes that I intend to make to the kernel.  I'll integrate these
changes into the (huge) kernel patchset, but wanted to aggregate the changes
here first to avoid overwhelming reviewers.

Question: What will happen to old kernels when METADATA_CSUM and GDT_CSUM are
set?  Should the kernel reject the combination and ask for fsck?  I think it
will be ok, but older kernels might not be...?

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/balloc.c  |    4 ++--
 fs/ext4/ext4.h    |   20 +++++++++++++++-----
 fs/ext4/ialloc.c  |   19 ++++++++-----------
 fs/ext4/inode.c   |    3 +--
 fs/ext4/mballoc.c |    6 +++---
 fs/ext4/resize.c  |    9 +++------
 fs/ext4/super.c   |   23 ++++++++++-------------
 7 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 6eee0e6..b5a7951 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -168,7 +168,7 @@ void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 
 	/* If checksum is bad mark all blocks used to prevent allocation
 	 * essentially implementing a per-group read-only flag. */
-	if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
+	if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
 		ext4_error(sb, "Checksum bad for group %u", block_group);
 		ext4_free_group_clusters_set(sb, gdp, 0);
 		ext4_free_inodes_set(sb, gdp, 0);
@@ -214,7 +214,7 @@ void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 			     sb->s_blocksize * 8, bh->b_data);
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bh,
 				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
-	ext4_group_desc_csum_set(sbi, block_group, gdp);
+	ext4_group_desc_csum_set(sb, block_group, gdp);
 }
 
 /* Return the number of free blocks in a block group.  It is used when
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 70bd236..a518930 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1434,6 +1434,11 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
 #define EXT4_FEATURE_RO_COMPAT_BIGALLOC		0x0200
+/*
+ * METADATA_CSUM implies GDT_CSUM.  When METADATA_CSUM is set, group
+ * descriptor checksums use the same algorithm as all other data
+ * structures' checksums.
+ */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
@@ -1449,7 +1454,6 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000 /* data in dirent */
 #define EXT4_FEATURE_INCOMPAT_INLINEDATA	0x2000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
-#define EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM	0x8000
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -1473,8 +1477,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
-					 EXT4_FEATURE_INCOMPAT_MMP| \
-					 EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)
+					 EXT4_FEATURE_INCOMPAT_MMP)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
@@ -2092,11 +2095,18 @@ extern void ext4_used_dirs_set(struct super_block *sb,
 				struct ext4_group_desc *bg, __u32 count);
 extern void ext4_itable_unused_set(struct super_block *sb,
 				   struct ext4_group_desc *bg, __u32 count);
-extern int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 group,
+extern int ext4_group_desc_csum_verify(struct super_block *sb, __u32 group,
 				       struct ext4_group_desc *gdp);
-extern void ext4_group_desc_csum_set(struct ext4_sb_info *sbi, __u32 group,
+extern void ext4_group_desc_csum_set(struct super_block *sb, __u32 group,
 				     struct ext4_group_desc *gdp);
 
+static inline int ext4_has_group_desc_csum(struct super_block *sb)
+{
+	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
+					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+					  EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+}
+
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 {
 	return ((ext4_fsblk_t)le32_to_cpu(es->s_blocks_count_hi) << 32) |
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index b9b6b27..1ade34d 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -70,13 +70,11 @@ static unsigned ext4_init_inode_bitmap(struct super_block *sb,
 				       ext4_group_t block_group,
 				       struct ext4_group_desc *gdp)
 {
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-
 	J_ASSERT_BH(bh, buffer_locked(bh));
 
 	/* If checksum is bad mark all blocks and inodes use to prevent
 	 * allocation, essentially implementing a per-group read-only flag. */
-	if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
+	if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
 		ext4_error(sb, "Checksum bad for group %u", block_group);
 		ext4_free_group_clusters_set(sb, gdp, 0);
 		ext4_free_inodes_set(sb, gdp, 0);
@@ -92,7 +90,7 @@ static unsigned ext4_init_inode_bitmap(struct super_block *sb,
 			bh->b_data);
 	ext4_inode_bitmap_csum_set(sb, block_group, gdp, bh,
 				   EXT4_INODES_PER_GROUP(sb) / 8);
-	ext4_group_desc_csum_set(sbi, block_group, gdp);
+	ext4_group_desc_csum_set(sb, block_group, gdp);
 
 	return EXT4_INODES_PER_GROUP(sb);
 }
@@ -287,7 +285,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	}
 	ext4_inode_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
 				   EXT4_INODES_PER_GROUP(sb) / 8);
-	ext4_group_desc_csum_set(sbi, block_group, gdp);
+	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 
 	percpu_counter_inc(&sbi->s_freeinodes_counter);
@@ -657,8 +655,7 @@ static int ext4_claim_inode(struct super_block *sb,
 	}
 	/* If we didn't allocate from within the initialized part of the inode
 	 * table then we need to initialize up to this inode. */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
-
+	if (ext4_has_group_desc_csum(sb)) {
 		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
 			/* When marking the block group with
@@ -697,7 +694,7 @@ static int ext4_claim_inode(struct super_block *sb,
 	}
 	ext4_inode_bitmap_csum_set(sb, group, gdp, inode_bitmap_bh,
 				   EXT4_INODES_PER_GROUP(sb) / 8);
-	ext4_group_desc_csum_set(sbi, group, gdp);
+	ext4_group_desc_csum_set(sb, group, gdp);
 err_ret:
 	ext4_unlock_group(sb, group);
 	up_read(&grp->alloc_sem);
@@ -832,7 +829,7 @@ repeat_in_this_group:
 
 got:
 	/* We may have to initialize the block bitmap if it isn't already */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+	if (ext4_has_group_desc_csum(sb) &&
 	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		struct buffer_head *block_bitmap_bh;
 
@@ -858,7 +855,7 @@ got:
 						   block_bitmap_bh,
 						   EXT4_BLOCKS_PER_GROUP(sb) /
 						   8);
-			ext4_group_desc_csum_set(sbi, group, gdp);
+			ext4_group_desc_csum_set(sb, group, gdp);
 		}
 		ext4_unlock_group(sb, group);
 
@@ -1226,7 +1223,7 @@ int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 skip_zeroout:
 	ext4_lock_group(sb, group);
 	gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_ZEROED);
-	ext4_group_desc_csum_set(sbi, group, gdp);
+	ext4_group_desc_csum_set(sb, group, gdp);
 	ext4_unlock_group(sb, group);
 
 	BUFFER_TRACE(group_desc_bh,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c0200cf..e94ac91 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3573,8 +3573,7 @@ make_io:
 				b = table;
 			end = b + EXT4_SB(sb)->s_inode_readahead_blks;
 			num = EXT4_INODES_PER_GROUP(sb);
-			if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+			if (ext4_has_group_desc_csum(sb))
 				num -= ext4_itable_unused_count(sb, gdp);
 			table += num / inodes_per_block;
 			if (end > table)
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5f2e2ed..d6062e7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2919,7 +2919,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	ext4_free_group_clusters_set(sb, gdp, len);
 	ext4_block_bitmap_csum_set(sb, ac->ac_b_ex.fe_group, gdp, bitmap_bh,
 				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
-	ext4_group_desc_csum_set(sbi, ac->ac_b_ex.fe_group, gdp);
+	ext4_group_desc_csum_set(sb, ac->ac_b_ex.fe_group, gdp);
 
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
 	percpu_counter_sub(&sbi->s_freeclusters_counter, ac->ac_b_ex.fe_len);
@@ -4787,7 +4787,7 @@ do_more:
 	ext4_free_group_clusters_set(sb, gdp, ret);
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
 				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
-	ext4_group_desc_csum_set(sbi, block_group, gdp);
+	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
 
@@ -4933,7 +4933,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	ext4_free_group_clusters_set(sb, desc, blk_free_count);
 	ext4_block_bitmap_csum_set(sb, block_group, desc, bitmap_bh,
 				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
-	ext4_group_desc_csum_set(sbi, block_group, desc);
+	ext4_group_desc_csum_set(sb, block_group, desc);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter,
 			   EXT4_B2C(sbi, blocks_freed));
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 2363532..21ace95 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1106,7 +1106,7 @@ static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
 					     EXT4_B2C(sbi, group_data->free_blocks_count));
 		ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
 		gdp->bg_flags = cpu_to_le16(*bg_flags);
-		ext4_group_desc_csum_set(sbi, group, gdp);
+		ext4_group_desc_csum_set(sb, group, gdp);
 
 		err = ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
 		if (unlikely(err)) {
@@ -1342,17 +1342,14 @@ static int ext4_setup_next_flex_gd(struct super_block *sb,
 			   (1 + ext4_bg_num_gdb(sb, group + i) +
 			    le16_to_cpu(es->s_reserved_gdt_blocks)) : 0;
 		group_data[i].free_blocks_count = blocks_per_group - overhead;
-		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+		if (ext4_has_group_desc_csum(sb))
 			flex_gd->bg_flags[i] = EXT4_BG_BLOCK_UNINIT |
 					       EXT4_BG_INODE_UNINIT;
 		else
 			flex_gd->bg_flags[i] = EXT4_BG_INODE_ZEROED;
 	}
 
-	if (last_group == n_group &&
-	    EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+	if (last_group == n_group && ext4_has_group_desc_csum(sb))
 		/* We need to initialize block bitmap of last group. */
 		flex_gd->bg_flags[i - 1] &= ~EXT4_BG_BLOCK_UNINIT;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2190044..6196bfa 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2097,9 +2097,7 @@ static __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
 	__le32 le_group = cpu_to_le32(block_group);
 
 	if ((sbi->s_es->s_feature_ro_compat &
-	     cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) &&
-	    (sbi->s_es->s_feature_incompat &
-	     cpu_to_le32(EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM))) {
+	     cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))) {
 		/* Use new metadata_csum algorithm */
 		__u16 old_csum;
 		__u32 csum32;
@@ -2135,24 +2133,23 @@ out:
 	return cpu_to_le16(crc);
 }
 
-int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 block_group,
+int ext4_group_desc_csum_verify(struct super_block *sb, __u32 block_group,
 				struct ext4_group_desc *gdp)
 {
-	if ((sbi->s_es->s_feature_ro_compat &
-	     cpu_to_le32(EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) &&
-	    (gdp->bg_checksum != ext4_group_desc_csum(sbi, block_group, gdp)))
+	if (ext4_has_group_desc_csum(sb) &&
+	    (gdp->bg_checksum != ext4_group_desc_csum(EXT4_SB(sb),
+						      block_group, gdp)))
 		return 0;
 
 	return 1;
 }
 
-void ext4_group_desc_csum_set(struct ext4_sb_info *sbi, __u32 block_group,
+void ext4_group_desc_csum_set(struct super_block *sb, __u32 block_group,
 			      struct ext4_group_desc *gdp)
 {
-	if (!(sbi->s_es->s_feature_ro_compat &
-	     cpu_to_le32(EXT4_FEATURE_RO_COMPAT_GDT_CSUM)))
+	if (!ext4_has_group_desc_csum(sb))
 		return;
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
+	gdp->bg_checksum = ext4_group_desc_csum(EXT4_SB(sb), block_group, gdp);
 }
 
 /* Called at mount-time, super-block is locked */
@@ -2209,7 +2206,7 @@ static int ext4_check_descriptors(struct super_block *sb,
 			return 0;
 		}
 		ext4_lock_group(sb, i);
-		if (!ext4_group_desc_csum_verify(sbi, i, gdp)) {
+		if (!ext4_group_desc_csum_verify(sb, i, gdp)) {
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 				 "Checksum for group %u failed (%u!=%u)",
 				 i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
@@ -4620,7 +4617,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 				struct ext4_group_desc *gdp =
 					ext4_get_group_desc(sb, g, NULL);
 
-				if (!ext4_group_desc_csum_verify(sbi, g, gdp)) {
+				if (!ext4_group_desc_csum_verify(sb, g, gdp)) {
 					ext4_msg(sb, KERN_ERR,
 	       "ext4_remount: Checksum for group %u failed (%u!=%u)",
 		g, le16_to_cpu(ext4_group_desc_csum(sbi, g, gdp)),
