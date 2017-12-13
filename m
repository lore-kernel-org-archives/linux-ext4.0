From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] libext2fs: add missing swab for superblock, add checks
Date: Wed, 13 Dec 2017 16:47:14 -0700
Message-ID: <1513208834-37777-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.138]:34585 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdLMXzY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2017 18:55:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Several recently-added fields in struct ext2_super_block were
not being swabbed in ext2fs_swap_super(), in particular:

   s_raid_stride, s_raid_stripe_width, s_{first,last}_error_*
   s_lpf_ino, s_prj_quota_inum

Add swabbing for these missing fields.  Reorder the swabbing
on other fields so that they are in struct order, and add
comments for fields that do not need swabbing, so it is easier
to see that all fields are being handled.

Since this seems to be a fairly common occurrence, add compile
time checks to ext2fs_swap_super(), ext2fs_swap_inode_large(),
and ext2fs_swap_group_desc2() via a new EXT2FS_BUILD_BUG_ON()
macro to cause a compile warning if fields are used from these
structs without a corresponding change to the swab functions.

Lustre-bug: https://jira.hpdd.intel.com/browse/LU-9309
Reported-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/ext2fsP.h |  2 ++
 lib/ext2fs/swapfs.c  | 68 ++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 9d001d5..fd5b4b1 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -187,3 +187,5 @@ extern int ext2fs_file_block_offset_too_big(ext2_filsys fs,
 typedef void (*ext2_exit_fn)(void *);
 errcode_t ext2fs_add_exit_fn(ext2_exit_fn fn, void *data);
 errcode_t ext2fs_remove_exit_fn(ext2_exit_fn fn, void *data);
+
+#define EXT2FS_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2*!!(cond)]))
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index d63fc55..6e5cff9 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -24,7 +24,8 @@
 #ifdef WORDS_BIGENDIAN
 void ext2fs_swap_super(struct ext2_super_block * sb)
 {
-  	int i;
+	int i;
+
 	sb->s_inodes_count = ext2fs_swab32(sb->s_inodes_count);
 	sb->s_blocks_count = ext2fs_swab32(sb->s_blocks_count);
 	sb->s_r_blocks_count = ext2fs_swab32(sb->s_r_blocks_count);
@@ -56,52 +57,80 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_feature_compat = ext2fs_swab32(sb->s_feature_compat);
 	sb->s_feature_incompat = ext2fs_swab32(sb->s_feature_incompat);
 	sb->s_feature_ro_compat = ext2fs_swab32(sb->s_feature_ro_compat);
+	/* sb->s_uuid is __u8 and does not need swabbing */
+	/* sb->s_volume_name is char and does not need swabbing */
+	/* sb->s_last_mounted is char and does not need swabbing */
 	sb->s_algorithm_usage_bitmap = ext2fs_swab32(sb->s_algorithm_usage_bitmap);
+	/* sb->s_prealloc_blocks is __u8 and does not need swabbing */
+	/* sb->s_prealloc_dir_blocks is __u8 and does not need swabbing */
 	sb->s_reserved_gdt_blocks = ext2fs_swab16(sb->s_reserved_gdt_blocks);
+	/* sb->s_journal_uuid is __u8 and does not need swabbing */
 	sb->s_journal_inum = ext2fs_swab32(sb->s_journal_inum);
 	sb->s_journal_dev = ext2fs_swab32(sb->s_journal_dev);
 	sb->s_last_orphan = ext2fs_swab32(sb->s_last_orphan);
+	for (i = 0; i < 4; i++)
+		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
+	/* sb->s_def_hash_version is __u8 and does not need swabbing */
+	/* sb->s_jnl_backup_type is __u8 and does not need swabbing */
 	sb->s_desc_size = ext2fs_swab16(sb->s_desc_size);
 	sb->s_default_mount_opts = ext2fs_swab32(sb->s_default_mount_opts);
 	sb->s_first_meta_bg = ext2fs_swab32(sb->s_first_meta_bg);
 	sb->s_mkfs_time = ext2fs_swab32(sb->s_mkfs_time);
+	/* if journal backup is for a valid extent-based journal... */
+	if (ext2fs_extent_header_verify(sb->s_jnl_blocks,
+					sizeof(sb->s_jnl_blocks)) == 0) {
+		/* ... swap only the journal i_size and i_size_high,
+		 * and the extent data is not swapped on read */
+		i = 15;
+	} else {
+		/* direct/indirect journal: swap it all */
+		i = 0;
+	}
+	for (; i < 17; i++)
+		sb->s_jnl_blocks[i] = ext2fs_swab32(sb->s_jnl_blocks[i]);
 	sb->s_blocks_count_hi = ext2fs_swab32(sb->s_blocks_count_hi);
 	sb->s_r_blocks_count_hi = ext2fs_swab32(sb->s_r_blocks_count_hi);
 	sb->s_free_blocks_hi = ext2fs_swab32(sb->s_free_blocks_hi);
 	sb->s_min_extra_isize = ext2fs_swab16(sb->s_min_extra_isize);
 	sb->s_want_extra_isize = ext2fs_swab16(sb->s_want_extra_isize);
 	sb->s_flags = ext2fs_swab32(sb->s_flags);
+	sb->s_raid_stride = ext2fs_swab16(sb->s_raid_stride);
 	sb->s_mmp_update_interval = ext2fs_swab16(sb->s_mmp_update_interval);
 	sb->s_mmp_block = ext2fs_swab64(sb->s_mmp_block);
+	sb->s_raid_stripe_width = ext2fs_swab32(sb->s_raid_stripe_width);
+	/* sb->s_log_groups_per_flex is __u8 and does not need swabbing */
+	/* sb->s_checksum_type is __u8 and does not need swabbing */
+	/* sb->s_encryption_level is __u8 and does not need swabbing */
+	/* sb->s_reserved_pad is __u8 and does not need swabbing */
 	sb->s_kbytes_written = ext2fs_swab64(sb->s_kbytes_written);
 	sb->s_snapshot_inum = ext2fs_swab32(sb->s_snapshot_inum);
 	sb->s_snapshot_id = ext2fs_swab32(sb->s_snapshot_id);
 	sb->s_snapshot_r_blocks_count =
 		ext2fs_swab64(sb->s_snapshot_r_blocks_count);
 	sb->s_snapshot_list = ext2fs_swab32(sb->s_snapshot_list);
+	sb->s_error_count = ext2fs_swab32(sb->s_error_count);
+	sb->s_first_error_time = ext2fs_swab32(sb->s_first_error_time);
+	sb->s_first_error_ino = ext2fs_swab32(sb->s_first_error_ino);
+	sb->s_first_error_block = ext2fs_swab64(sb->s_first_error_block);
+	/* sb->s_first_error_func is __u8 and does not need swabbing */
+	sb->s_last_error_time = ext2fs_swab32(sb->s_last_error_time);
+	sb->s_last_error_ino = ext2fs_swab32(sb->s_last_error_ino);
+	sb->s_last_error_block = ext2fs_swab64(sb->s_last_error_block);
+	/* sb->s_last_error_func is __u8 and does not need swabbing */
+	/* sb->s_mount_opts is __u8 and does not need swabbing */
 	sb->s_usr_quota_inum = ext2fs_swab32(sb->s_usr_quota_inum);
 	sb->s_grp_quota_inum = ext2fs_swab32(sb->s_grp_quota_inum);
 	sb->s_overhead_blocks = ext2fs_swab32(sb->s_overhead_blocks);
-	sb->s_checksum = ext2fs_swab32(sb->s_checksum);
-
-	for (i=0; i < 4; i++)
-		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
-
-	/* if journal backup is for a valid extent-based journal... */
-	if (ext2fs_extent_header_verify(sb->s_jnl_blocks,
-					sizeof(sb->s_jnl_blocks)) == 0) {
-		/* ... swap only the journal i_size and i_size_high,
-		 * and the extent data is not swapped on read */
-		i = 15;
-	} else {
-		/* direct/indirect journal: swap it all */
-		i = 0;
-	}
-	for (; i < 17; i++)
-		sb->s_jnl_blocks[i] = ext2fs_swab32(sb->s_jnl_blocks[i]);
 	sb->s_backup_bgs[0] = ext2fs_swab32(sb->s_backup_bgs[0]);
 	sb->s_backup_bgs[1] = ext2fs_swab32(sb->s_backup_bgs[1]);
+	/* sb->s_encrypt_algos is __u8 and does not need swabbing */
+	/* sb->s_encrypt_pw_salt is __u8 and does not need swabbing */
+	sb->s_lpf_ino = ext2fs_swab32(sb->s_lpf_ino);
+	sb->s_prj_quota_inum = ext2fs_swab32(sb->s_prj_quota_inum);
 	sb->s_checksum_seed = ext2fs_swab32(sb->s_checksum_seed);
+	/* catch when new fields are used from s_reserved */
+	EXT2FS_BUILD_BUG_ON(sizeof(sb->s_reserved) != 98 * sizeof(__le32));
+	sb->s_checksum = ext2fs_swab32(sb->s_checksum);
 }
 
 void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
@@ -143,6 +172,7 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
 		ext2fs_swab16(gdp4->bg_block_bitmap_csum_hi);
 	gdp4->bg_inode_bitmap_csum_hi =
 		ext2fs_swab16(gdp4->bg_inode_bitmap_csum_hi);
+	EXT2FS_BUILD_BUG_ON(sizeof(gdp4->bg_reserved) != sizeof(__u32));
 }
 
 void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
@@ -327,6 +357,8 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 		t->i_version_hi = ext2fs_swab32(f->i_version_hi);
 	if (inode_includes(inode_size, i_projid))
                 t->i_projid = ext2fs_swab16(f->i_projid);
+	/* catch new static fields added after i_projid */
+	EXT2FS_BUILD_BUG_ON(sizeof(ext2_inode_large) != 160);
 
 	i = sizeof(struct ext2_inode) + extra_isize + sizeof(__u32);
 	if (bufsize < (int) i)
-- 
1.8.0
