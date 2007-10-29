From: Coly Li <coyli@suse.de>
Subject: [PATCH] ext4: dir inodes reservation V1
Date: Tue, 30 Oct 2007 00:51:56 +0800
Message-ID: <47260FAC.2040209@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33569 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbXJ2QvD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2007 12:51:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is the first ask-for-review patch for dir inode reservation. Basic function testing is done,
the benchmark result is still on the way (really time consuming).

The previous patch (v0.1) introduced 2 special indoes which were named magic inodes. The magic inode
scheme modified ext4 on-disk format, which was concerned by several people.

This time the patch (V1) removes magic inodes, there is no on-disk format modification in this
patch. Also dir inode reservation feature is only mount option, if you do not want to test it, just
ignore the mount option dir_ireserve=low/normal/high.

I will post detail text later. Any comments for this patch is great welcome :-)

Signed-off-by: Coly Li <coyli@suse.de>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/ialloc.c           |  203 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/super.c            |   18 ++++-
 include/linux/ext4_fs.h    |    8 ++
 include/linux/ext4_fs_sb.h |    2 +
 4 files changed, 221 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index d775170..cbb9db9 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -130,6 +130,41 @@ error_out:
 }

 /*
+ * When calling this function, spin_lock of gdp is hold already.
+ */
+static void ext4_update_itable_unused(handle_t * handle, struct inode * inode,
+                        struct ext4_group_desc * gdp, struct buffer_head * bitmap_bh)
+{
+	struct super_block * sb;
+	int bit, offset;
+	int free, group, ires;
+
+ 	sb = inode->i_sb;
+	ires =  EXT4_SB(sb)->s_dir_ireserve_nr;
+	bit = (inode->i_ino - 1) % EXT4_INODES_PER_GROUP(sb);
+	if (bit & (ires - 1))
+		return;
+	free = EXT4_INODES_PER_GROUP(sb) - le16_to_cpu(gdp->bg_itable_unused);
+	if (free < ires)
+		return;
+	group = (inode->i_ino - 1) / EXT4_INODES_PER_GROUP(sb);
+	do {
+		offset = ext4_find_next_bit(
+			bitmap_bh->b_data, free, free - ires);
+		if (offset >= free)
+			free -= ires;
+		else
+			break;
+	} while(free > 0);
+	if (free < 0)
+		free = 0;
+	if (group == 0 && (free < EXT4_DIR_IRESERVE_NORMAL))
+		free = EXT4_DIR_IRESERVE_NORMAL;
+	gdp->bg_itable_unused = cpu_to_le16(
+		EXT4_INODES_PER_GROUP(sb) - free);
+}
+
+/*
  * NOTE! When we get the inode, we're the only people
  * that have access to it, and as such there are no
  * race conditions we have to worry about. The inode
@@ -225,9 +260,13 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 			spin_lock(sb_bgl_lock(sbi, block_group));
 			gdp->bg_free_inodes_count = cpu_to_le16(
 				le16_to_cpu(gdp->bg_free_inodes_count) + 1);
-			if (is_directory)
+			if (is_directory) {
 				gdp->bg_used_dirs_count = cpu_to_le16(
 				  le16_to_cpu(gdp->bg_used_dirs_count) - 1);
+				if (tes_opt(sb, DIR_IRESERVE))
+					ext4_update_itable_unused(
+						handle, inode, gdp, bitmap_bh);
+			}
 			gdp->bg_checksum = ext4_group_desc_csum(sbi,
 							block_group, gdp);
 			spin_unlock(sb_bgl_lock(sbi, block_group));
@@ -264,9 +303,10 @@ static int find_group_dir(struct super_block *sb, struct inode *parent,
 			  ext4_grpnum_t *best_group)
 {
 	ext4_grpnum_t ngroups = EXT4_SB(sb)->s_groups_count;
+	int ires = EXT4_SB(sb)->s_dir_ireserve_nr;
 	unsigned int freei, avefreei;
-	struct ext4_group_desc *desc, *best_desc = NULL;
-	ext4_grpnum_t group;
+	struct ext4_group_desc *desc, *best_desc = NULL, *best_ires_desc = NULL;
+	ext4_grpnum_t group, best_ires_group = -1;
 	int ret = -1;

 	freei = percpu_counter_read_positive(&EXT4_SB(sb)->s_freeinodes_counter);
@@ -285,7 +325,21 @@ static int find_group_dir(struct super_block *sb, struct inode *parent,
 			best_desc = desc;
 			ret = 0;
 		}
+		if(test_opt(sb, DIR_IRESERVE)) {
+			if((best_ires_desc &&
+			   (le16_to_cpu(desc->bg_itable_unused) >
+			   le16_to_cpu(best_ires_desc->bg_itable_unused))) ||
+			   ((!best_ires_desc) &&
+			   (le16_to_cpu(desc->bg_itable_unused) >= ires))) {
+				best_ires_group = group;
+				best_ires_desc = desc;
+				ret = 0;
+			}
+		}
 	}
+	if (test_opt(sb, DIR_IRESERVE) && best_ires_desc)
+		*best_group = best_ires_group;
+	
 	return ret;
 }

@@ -354,6 +408,10 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 			desc = ext4_get_group_desc(sb, grp, NULL);
 			if (!desc || !desc->bg_free_inodes_count)
 				continue;
+			if (test_opt(sb, DIR_IRESERVE) &&
+			    (le16_to_cpu(desc->bg_itable_unused)
+						< EXT4_SB(sb)->s_dir_ireserve_nr))
+				continue;
 			if (le16_to_cpu(desc->bg_used_dirs_count) >= best_ndir)
 				continue;
 			if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
@@ -390,6 +448,10 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 		desc = ext4_get_group_desc(sb, *group, NULL);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
+		if (test_opt(sb, DIR_IRESERVE) &&
+		    (le16_to_cpu(desc->bg_itable_unused)
+					< EXT4_SB(sb)->s_dir_ireserve_nr))
+			continue;
 		if (le16_to_cpu(desc->bg_used_dirs_count) >= max_dirs)
 			continue;
 		if (le16_to_cpu(desc->bg_free_inodes_count) < min_inodes)
@@ -479,6 +541,108 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
 }

 /*
+ *
+ */
+static int ext4_ino_from_ireserve(handle_t *handle, struct inode * dir,
+				  int mode, int * group, unsigned long * ino)
+{
+	struct ext4_group_desc * gdp = NULL;
+	struct super_block * sb;
+	struct ext4_sb_info * sbi;
+	struct buffer_head *gdp_bh =NULL, *bitmap_bh = NULL;
+	int free;
+	int i;
+	int retries;
+	unsigned long ires_ino;
+	int ires_group = *group;
+
+	sb = dir->i_sb;
+	sbi = EXT4_SB(sb);
+
+	/* if the inode number is not for directory,
+	 * only try to allocate after directory's inode
+	 */
+	if (!S_ISDIR(mode)) {
+		ires_ino = dir->i_ino % EXT4_INODES_PER_GROUP(sb);
+		goto find;
+	}
+
+	/* reserve inodes for new directory */
+	for(i = 0; i < sbi->s_groups_count; i++) {
+		gdp = ext4_get_group_desc(sb, ires_group, &gdp_bh);
+		if (!gdp)
+			goto fail;
+		retries = 2;
+still_reserve_in_this_group:
+		if (le16_to_cpu(gdp->bg_itable_unused) >=
+		    sbi->s_dir_ireserve_nr) {
+
+			brelse(bitmap_bh);
+			bitmap_bh = read_inode_bitmap(sb, ires_group);
+			if (!bitmap_bh) {
+				goto fail;
+			}
+
+			BUFFER_TRACE(bitmap_bh, "get_write_access");
+			if (ext4_journal_get_write_access(handle, bitmap_bh) != 0)
+				goto fail;
+			free = EXT4_INODES_PER_GROUP(sb) -
+				le16_to_cpu(gdp->bg_itable_unused);
+			if (!ext4_set_bit_atomic(sb_bgl_lock(sbi, ires_group),
+					free, bitmap_bh->b_data)) {
+				/* we won it */
+				BUFFER_TRACE(bitmap_bh,
+					"call ext4_journal_dirty_metadata");
+				if (ext4_journal_dirty_metadata(handle,
+							bitmap_bh) != 0)
+					goto fail;
+				ires_ino = free;
+				goto find;
+			}
+			/* we lost it */
+			jbd2_journal_release_buffer(handle, bitmap_bh);
+			if (-- retries > 0)
+				goto still_reserve_in_this_group;
+		}
+		if (++ires_group == sbi->s_groups_count)
+			ires_group = 0;
+	}
+	goto fail;
+find:
+	if(S_ISDIR(mode)) {
+		free = ires_ino + sbi->s_dir_ireserve_nr;
+		if (free > EXT4_INODES_PER_GROUP(sb))
+			free = EXT4_INODES_PER_GROUP(sb);
+	
+		spin_lock(sb_bgl_lock(sbi, ires_group));
+		if ((EXT4_INODES_PER_GROUP(sb) - free) <
+		     le16_to_cpu(gdp->bg_itable_unused)) {
+			BUFFER_TRACE (gdp_bh,
+				      "call ext4_journal_get_write_access");
+			if (ext4_journal_get_write_access(handle, gdp_bh)) {
+				spin_unlock(sb_bgl_lock(sbi, ires_group));
+				goto fail;
+			}
+			gdp->bg_itable_unused =
+				EXT4_INODES_PER_GROUP(sb) - free;
+			spin_unlock(sb_bgl_lock(sbi, ires_group));
+			BUFFER_TRACE (bh, "call ext4_journal_dirty_metadata");
+			if (ext4_journal_dirty_metadata(handle, gdp_bh) != 0)
+				goto fail;
+		} else {
+			spin_unlock(sb_bgl_lock(sbi, ires_group));
+		}
+		brelse(bitmap_bh);
+		*group = ires_group;
+	}
+	*ino = ires_ino;
+	return 0;
+fail:
+	brelse(bitmap_bh);
+	return -ENOSPC;
+}
+
+/*
  * There are two policies for allocating an inode.  If the new inode is
  * a directory, then a forward search is made for a block group with both
  * free space and a low directory-to-inode ratio; if that fails, then of
@@ -541,7 +705,12 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 			goto fail;

 		ino = 0;
-
+		if (test_opt(sb, DIR_IRESERVE)) {
+			err = ext4_ino_from_ireserve(handle, dir,
+						     mode, &group, &ino);
+			if ((!err) && S_ISDIR(mode))
+				goto got;
+		}
 repeat_in_this_group:
 		ino = ext4_find_next_zero_bit((unsigned long *)
 				bitmap_bh->b_data, EXT4_INODES_PER_GROUP(sb), ino);
@@ -633,6 +802,20 @@ got:
 	}

 	spin_lock(sb_bgl_lock(sbi, group));
+
+	if (test_opt(sb, DIR_IRESERVE)) {
+		free = EXT4_INODES_PER_GROUP(sb) -
+			le16_to_cpu(gdp->bg_itable_unused);
+		if (ino > free) {
+			free += sbi->s_dir_ireserve_nr;
+			free = (free + sbi->s_dir_ireserve_nr - 1) &
+				~(sbi->s_dir_ireserve_nr - 1);
+			if (free > EXT4_INODES_PER_GROUP(sb))
+				free = EXT4_INODES_PER_GROUP(sb);
+			gdp->bg_itable_unused = cpu_to_le16(
+				EXT4_INODES_PER_GROUP(sb) - free);
+		}
+	}
 	/* If we didn't allocate from within the initialized part of the inode
 	 * table then we need to initialize up to this inode. */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
@@ -655,12 +838,14 @@ got:
 		/*
 		 * Check the relative inode number against the last used
 		 * relative inode number in this group. if it is greater
-		 * we need to  update the bg_itable_unused count
-		 *
+		 * we need to  update the bg_itable_unused count. If
+		 * directory inode reservation is enabled, try to make it
+		 * align on a s_dir_ireserve_nr boundary.
 		 */
-		if (ino > free)
-			gdp->bg_itable_unused =
-				cpu_to_le16(EXT4_INODES_PER_GROUP(sb) - ino);
+		if (ino > free) {
+			gdp->bg_itable_unused = cpu_to_le16(
+				EXT4_INODES_PER_GROUP(sb) - ino);
+		}
 	}

 	gdp->bg_free_inodes_count =
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 37afc41..159021b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -874,11 +874,12 @@ enum {
 	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
 	Opt_journal_checksum, Opt_journal_async_commit,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
+	Opt_dir_ireserve_low, Opt_dir_ireserve_normal, Opt_dir_ireserve_high,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
 	Opt_grpquota, Opt_extents, Opt_noextents, Opt_delalloc,
-	Opt_mballoc, Opt_nomballoc, Opt_stripe,
+	Opt_mballoc, Opt_nomballoc, Opt_stripe,
 };

 static match_table_t tokens = {
@@ -919,6 +920,9 @@ static match_table_t tokens = {
 	{Opt_data_journal, "data=journal"},
 	{Opt_data_ordered, "data=ordered"},
 	{Opt_data_writeback, "data=writeback"},
+	{Opt_dir_ireserve_low, "dir_ireserve=low"},
+	{Opt_dir_ireserve_normal, "dir_ireserve=normal"},
+	{Opt_dir_ireserve_high, "dir_ireserve=high"},
 	{Opt_offusrjquota, "usrjquota="},
 	{Opt_usrjquota, "usrjquota=%s"},
 	{Opt_offgrpjquota, "grpjquota="},
@@ -1297,6 +1301,18 @@ clear_qf_name:
 				return 0;
 			sbi->s_stripe = option;
 			break;
+		case Opt_dir_ireserve_low:
+			set_opt(sbi->s_mount_opt, DIR_IRESERVE);
+			sbi->s_dir_ireserve_nr = EXT4_DIR_IRESERVE_LOW;
+			break;
+		case Opt_dir_ireserve_normal:
+			set_opt(sbi->s_mount_opt, DIR_IRESERVE);
+			sbi->s_dir_ireserve_nr = EXT4_DIR_IRESERVE_NORMAL;
+			break;
+		case Opt_dir_ireserve_high:
+			set_opt(sbi->s_mount_opt, DIR_IRESERVE);
+			sbi->s_dir_ireserve_nr = EXT4_DIR_IRESERVE_HIGH;
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT4-fs: Unrecognized mount option \"%s\" "
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 8d56b86..a8332bd 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -92,6 +92,13 @@ struct ext4_allocation_request {
 #define EXT4_GOOD_OLD_FIRST_INO	11

 /*
+ * Macro-instructions used to reserve inodes for directories
+ */
+#define EXT4_DIR_IRESERVE_LOW		16
+#define EXT4_DIR_IRESERVE_NORMAL	64
+#define EXT4_DIR_IRESERVE_HIGH		128
+
+/*
  * Maximal count of links to a file
  */
 #define EXT4_LINK_MAX		65000
@@ -502,6 +509,7 @@ do {									       \
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
 #define EXT4_MOUNT_DELALLOC		0x2000000 /* Delalloc support */
 #define EXT4_MOUNT_MBALLOC		0x4000000 /* Buddy allocation support */
+#define EXT4_MOUNT_DIR_IRESERVE		0x10000000/* directory inodes reservation support */
 /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index 4098d4f..fa5e866 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -147,6 +147,8 @@ struct ext4_sb_info {

 	/* locality groups */
 	struct ext4_locality_group *s_locality_groups;
+	/* directory inodes reservation number */
+	int s_dir_ireserve_nr;
 };
 #define EXT4_GROUP_INFO(sb, group)					   \
 	EXT4_SB(sb)->s_group_info[(group) >> EXT4_DESC_PER_BLOCK_BITS(sb)] \



-- 
Coly Li
SuSE PRC Labs
