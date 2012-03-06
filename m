From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 13/23] ext4: Make block group checksums use metadata_csum
 algorithm
Date: Tue, 06 Mar 2012 12:49:23 -0800
Message-ID: <20120306204923.1663.66670.stgit@elm3b70.beaverton.ibm.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

metadata_csum supersedes uninit_bg.  Convert the ROCOMPAT uninit_bg flag check
to a helper function that covers both, and make the checksum calculation
algorithm use either crc16 or the metadata_csum chosen algorithm depending on
which flag is set.  Print a warning if we try to mount a filesystem with both
feature flags set.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/balloc.c  |    4 +--
 fs/ext4/ext4.h    |   13 +++++++--
 fs/ext4/ialloc.c  |   20 +++++--------
 fs/ext4/inode.c   |    3 +-
 fs/ext4/mballoc.c |    6 ++--
 fs/ext4/resize.c  |    9 ++----
 fs/ext4/super.c   |   81 +++++++++++++++++++++++++++++++++++++----------------
 7 files changed, 84 insertions(+), 52 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index d5484ca..b5a7951 100644
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
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
+	ext4_group_desc_csum_set(sb, block_group, gdp);
 }
 
 /* Return the number of free blocks in a block group.  It is used when
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fff5245..ee7bac7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2095,10 +2095,17 @@ extern void ext4_used_dirs_set(struct super_block *sb,
 				struct ext4_group_desc *bg, __u32 count);
 extern void ext4_itable_unused_set(struct super_block *sb,
 				   struct ext4_group_desc *bg, __u32 count);
-extern __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 group,
-				   struct ext4_group_desc *gdp);
-extern int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 group,
+extern int ext4_group_desc_csum_verify(struct super_block *sb, __u32 group,
 				       struct ext4_group_desc *gdp);
+extern void ext4_group_desc_csum_set(struct super_block *sb, __u32 group,
+				     struct ext4_group_desc *gdp);
+
+static inline int ext4_has_group_desc_csum(struct super_block *sb)
+{
+	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
+					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+					  EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+}
 
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 {
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 1e62cc2..1ade34d 100644
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
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
+	ext4_group_desc_csum_set(sb, block_group, gdp);
 
 	return EXT4_INODES_PER_GROUP(sb);
 }
@@ -287,7 +285,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	}
 	ext4_inode_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
 				   EXT4_INODES_PER_GROUP(sb) / 8);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
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
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
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
 
@@ -858,8 +855,7 @@ got:
 						   block_bitmap_bh,
 						   EXT4_BLOCKS_PER_GROUP(sb) /
 						   8);
-			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
-								gdp);
+			ext4_group_desc_csum_set(sb, group, gdp);
 		}
 		ext4_unlock_group(sb, group);
 
@@ -1227,7 +1223,7 @@ int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 skip_zeroout:
 	ext4_lock_group(sb, group);
 	gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_ZEROED);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
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
index 8328a48..d6062e7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2919,7 +2919,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	ext4_free_group_clusters_set(sb, gdp, len);
 	ext4_block_bitmap_csum_set(sb, ac->ac_b_ex.fe_group, gdp, bitmap_bh,
 				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
+	ext4_group_desc_csum_set(sb, ac->ac_b_ex.fe_group, gdp);
 
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
 	percpu_counter_sub(&sbi->s_freeclusters_counter, ac->ac_b_ex.fe_len);
@@ -4787,7 +4787,7 @@ do_more:
 	ext4_free_group_clusters_set(sb, gdp, ret);
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
 				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
+	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
 
@@ -4933,7 +4933,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	ext4_free_group_clusters_set(sb, desc, blk_free_count);
 	ext4_block_bitmap_csum_set(sb, block_group, desc, bitmap_bh,
 				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
-	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
+	ext4_group_desc_csum_set(sb, block_group, desc);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter,
 			   EXT4_B2C(sbi, blocks_freed));
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 0ae1002..0e8683a 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1160,7 +1160,7 @@ static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
 					     EXT4_B2C(sbi, group_data->free_blocks_count));
 		ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
 		gdp->bg_flags = cpu_to_le16(*bg_flags);
-		gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
+		ext4_group_desc_csum_set(sb, group, gdp);
 
 		err = ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
 		if (unlikely(err)) {
@@ -1400,17 +1400,14 @@ static int ext4_setup_next_flex_gd(struct super_block *sb,
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
index 9881e90..a8e379e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2089,43 +2089,69 @@ failed:
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
+	     cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))) {
+		/* Use new metadata_csum algorithm */
+		__u16 old_csum;
+		__u32 csum32;
+
+		old_csum = gdp->bg_checksum;
+		gdp->bg_checksum = 0;
+		csum32 = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&le_group,
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
 
+void ext4_group_desc_csum_set(struct super_block *sb, __u32 block_group,
+			      struct ext4_group_desc *gdp)
+{
+	if (!ext4_has_group_desc_csum(sb))
+		return;
+	gdp->bg_checksum = ext4_group_desc_csum(EXT4_SB(sb), block_group, gdp);
+}
+
 /* Called at mount-time, super-block is locked */
 static int ext4_check_descriptors(struct super_block *sb,
 				  ext4_group_t *first_not_zeroed)
@@ -2180,7 +2206,7 @@ static int ext4_check_descriptors(struct super_block *sb,
 			return 0;
 		}
 		ext4_lock_group(sb, i);
-		if (!ext4_group_desc_csum_verify(sbi, i, gdp)) {
+		if (!ext4_group_desc_csum_verify(sb, i, gdp)) {
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 				 "Checksum for group %u failed (%u!=%u)",
 				 i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
@@ -3222,6 +3248,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto cantfind_ext4;
 	sbi->s_kbytes_written = le64_to_cpu(es->s_kbytes_written);
 
+	/* Warn if metadata_csum and gdt_csum are both set. */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+		ext4_warning(sb, KERN_INFO "metadata_csum and uninit_bg are "
+			     "redundant flags; please run fsck.");
+
 	/* Check for a known checksum algorithm */
 	if (!ext4_verify_csum_type(sb, es)) {
 		ext4_msg(sb, KERN_ERR, "VFS: Found ext4 filesystem with "
@@ -4562,7 +4595,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 				struct ext4_group_desc *gdp =
 					ext4_get_group_desc(sb, g, NULL);
 
-				if (!ext4_group_desc_csum_verify(sbi, g, gdp)) {
+				if (!ext4_group_desc_csum_verify(sb, g, gdp)) {
 					ext4_msg(sb, KERN_ERR,
 	       "ext4_remount: Checksum for group %u failed (%u!=%u)",
 		g, le16_to_cpu(ext4_group_desc_csum(sbi, g, gdp)),
