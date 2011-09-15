From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] debugfs: add 64-bit support to the set_field commands
Date: Thu, 15 Sep 2011 18:50:52 -0400
Message-ID: <1316127052-1890-3-git-send-email-tytso@mit.edu>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57952 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935230Ab1IOWuz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 18:50:55 -0400
In-Reply-To: <1316127052-1890-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The set_fields commands (set_super_value, set_inode_field,
set_block_group) now handle fields which store in split fields on
ext4's on-disk format.  For example, the superblock fields
s_blocks_count and s_blocks_count_hi.

The user can either set the low or high part of the field via
"blocks_count_lo" or "blocks_count_hi", or both parts can be set via
"blocks_count".

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/debugfs.h    |    2 +
 debugfs/set_fields.c |  453 ++++++++++++++++++++++++++++++++------------------
 debugfs/util.c       |   16 ++
 3 files changed, 310 insertions(+), 161 deletions(-)

diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index 0ea2474..24c4dce 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -50,6 +50,8 @@ extern int debugfs_read_inode_full(ext2_ino_t ino, struct ext2_inode * inode,
 				   const char *cmd, int bufsize);
 extern int debugfs_write_inode(ext2_ino_t ino, struct ext2_inode * inode,
 			       const char *cmd);
+extern int debugfs_write_inode_full(ext2_ino_t ino, struct ext2_inode * inode,
+				    const char *cmd, int bufsize);
 extern int debugfs_write_new_inode(ext2_ino_t ino, struct ext2_inode * inode,
 				   const char *cmd);
 
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 1a5ec7f..06d0ad8 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -40,8 +40,9 @@
 #include "e2p/e2p.h"
 
 static struct ext2_super_block set_sb;
-static struct ext2_inode set_inode;
+static struct ext2_inode_large set_inode;
 static struct ext2_group_desc set_gd;
+static struct ext4_group_desc set_gd4;
 static dgrp_t set_bg;
 static ext2_ino_t set_ino;
 static int array_idx;
@@ -51,154 +52,208 @@ static int array_idx;
 struct field_set_info {
 	const char	*name;
 	void	*ptr;
+	void	*ptr2;
 	unsigned int	size;
-	errcode_t (*func)(struct field_set_info *info, char *arg);
+	errcode_t (*func)(struct field_set_info *info, char *field, char *arg);
 	int flags;
 	int max_idx;
 };
 
-static errcode_t parse_uint(struct field_set_info *info, char *arg);
-static errcode_t parse_int(struct field_set_info *info, char *arg);
-static errcode_t parse_string(struct field_set_info *info, char *arg);
-static errcode_t parse_uuid(struct field_set_info *info, char *arg);
-static errcode_t parse_hashalg(struct field_set_info *info, char *arg);
-static errcode_t parse_time(struct field_set_info *info, char *arg);
-static errcode_t parse_bmap(struct field_set_info *info, char *arg);
-static errcode_t parse_gd_csum(struct field_set_info *info, char *arg);
+static errcode_t parse_uint(struct field_set_info *info, char *field, char *arg);
+static errcode_t parse_int(struct field_set_info *info, char *field, char *arg);
+static errcode_t parse_string(struct field_set_info *info, char *field, char *arg);
+static errcode_t parse_uuid(struct field_set_info *info, char *field, char *arg);
+static errcode_t parse_hashalg(struct field_set_info *info, char *field, char *arg);
+static errcode_t parse_time(struct field_set_info *info, char *field, char *arg);
+static errcode_t parse_bmap(struct field_set_info *info, char *field, char *arg);
+static errcode_t parse_gd_csum(struct field_set_info *info, char *field, char *arg);
 
 static struct field_set_info super_fields[] = {
-	{ "inodes_count", &set_sb.s_inodes_count, 4, parse_uint },
-	{ "blocks_count", &set_sb.s_blocks_count, 4, parse_uint },
-	{ "r_blocks_count", &set_sb.s_r_blocks_count, 4, parse_uint },
-	{ "free_blocks_count", &set_sb.s_free_blocks_count, 4, parse_uint },
-	{ "free_inodes_count", &set_sb.s_free_inodes_count, 4, parse_uint },
-	{ "first_data_block", &set_sb.s_first_data_block, 4, parse_uint },
-	{ "log_block_size", &set_sb.s_log_block_size, 4, parse_uint },
-	{ "log_cluster_size", &set_sb.s_log_cluster_size, 4, parse_int },
-	{ "blocks_per_group", &set_sb.s_blocks_per_group, 4, parse_uint },
-	{ "clusters_per_group", &set_sb.s_clusters_per_group, 4, parse_uint },
-	{ "inodes_per_group", &set_sb.s_inodes_per_group, 4, parse_uint },
-	{ "mtime", &set_sb.s_mtime, 4, parse_time },
-	{ "wtime", &set_sb.s_wtime, 4, parse_time },
-	{ "mnt_count", &set_sb.s_mnt_count, 2, parse_uint },
-	{ "max_mnt_count", &set_sb.s_max_mnt_count, 2, parse_int },
+	{ "inodes_count", &set_sb.s_inodes_count, NULL, 4, parse_uint },
+	{ "blocks_count", &set_sb.s_blocks_count, &set_sb.s_blocks_count_hi,
+		4, parse_uint },
+	{ "r_blocks_count", &set_sb.s_r_blocks_count,
+		&set_sb.s_r_blocks_count_hi, 4, parse_uint },
+	{ "free_blocks_count", &set_sb.s_free_blocks_count,
+		&set_sb.s_free_blocks_hi, 4, parse_uint },
+	{ "free_inodes_count", &set_sb.s_free_inodes_count, NULL, 4, parse_uint },
+	{ "first_data_block", &set_sb.s_first_data_block, NULL, 4, parse_uint },
+	{ "log_block_size", &set_sb.s_log_block_size, NULL, 4, parse_uint },
+	{ "log_cluster_size", &set_sb.s_log_cluster_size, NULL, 4, parse_int },
+	{ "blocks_per_group", &set_sb.s_blocks_per_group, NULL, 4, parse_uint },
+	{ "clusters_per_group", &set_sb.s_clusters_per_group, NULL, 4, parse_uint },
+	{ "inodes_per_group", &set_sb.s_inodes_per_group, NULL, 4, parse_uint },
+	{ "mtime", &set_sb.s_mtime, NULL, 4, parse_time },
+	{ "wtime", &set_sb.s_wtime, NULL, 4, parse_time },
+	{ "mnt_count", &set_sb.s_mnt_count, NULL, 2, parse_uint },
+	{ "max_mnt_count", &set_sb.s_max_mnt_count, NULL, 2, parse_int },
 	/* s_magic */
-	{ "state", &set_sb.s_state, 2, parse_uint },
-	{ "errors", &set_sb.s_errors, 2, parse_uint },
-	{ "minor_rev_level", &set_sb.s_minor_rev_level, 2, parse_uint },
-	{ "lastcheck", &set_sb.s_lastcheck, 4, parse_time },
-	{ "checkinterval", &set_sb.s_checkinterval, 4, parse_uint },
-	{ "creator_os", &set_sb.s_creator_os, 4, parse_uint },
-	{ "rev_level", &set_sb.s_rev_level, 4, parse_uint },
-	{ "def_resuid", &set_sb.s_def_resuid, 2, parse_uint },
-	{ "def_resgid", &set_sb.s_def_resgid, 2, parse_uint },
-	{ "first_ino", &set_sb.s_first_ino, 4, parse_uint },
-	{ "inode_size", &set_sb.s_inode_size, 2, parse_uint },
-	{ "block_group_nr", &set_sb.s_block_group_nr, 2, parse_uint },
-	{ "feature_compat", &set_sb.s_feature_compat, 4, parse_uint },
-	{ "feature_incompat", &set_sb.s_feature_incompat, 4, parse_uint },
-	{ "feature_ro_compat", &set_sb.s_feature_ro_compat, 4, parse_uint },
-	{ "uuid", &set_sb.s_uuid, 16, parse_uuid },
-	{ "volume_name",  &set_sb.s_volume_name, 16, parse_string },
-	{ "last_mounted",  &set_sb.s_last_mounted, 64, parse_string },
-	{ "lastcheck",  &set_sb.s_lastcheck, 4, parse_uint },
-	{ "algorithm_usage_bitmap", &set_sb.s_algorithm_usage_bitmap,
+	{ "state", &set_sb.s_state, NULL, 2, parse_uint },
+	{ "errors", &set_sb.s_errors, NULL, 2, parse_uint },
+	{ "minor_rev_level", &set_sb.s_minor_rev_level, NULL, 2, parse_uint },
+	{ "lastcheck", &set_sb.s_lastcheck, NULL, 4, parse_time },
+	{ "checkinterval", &set_sb.s_checkinterval, NULL, 4, parse_uint },
+	{ "creator_os", &set_sb.s_creator_os, NULL, 4, parse_uint },
+	{ "rev_level", &set_sb.s_rev_level, NULL, 4, parse_uint },
+	{ "def_resuid", &set_sb.s_def_resuid, NULL, 2, parse_uint },
+	{ "def_resgid", &set_sb.s_def_resgid, NULL, 2, parse_uint },
+	{ "first_ino", &set_sb.s_first_ino, NULL, 4, parse_uint },
+	{ "inode_size", &set_sb.s_inode_size, NULL, 2, parse_uint },
+	{ "block_group_nr", &set_sb.s_block_group_nr, NULL, 2, parse_uint },
+	{ "feature_compat", &set_sb.s_feature_compat, NULL, 4, parse_uint },
+	{ "feature_incompat", &set_sb.s_feature_incompat, NULL, 4, parse_uint },
+	{ "feature_ro_compat", &set_sb.s_feature_ro_compat, NULL, 4, parse_uint },
+	{ "uuid", &set_sb.s_uuid, NULL, 16, parse_uuid },
+	{ "volume_name",  &set_sb.s_volume_name, NULL, 16, parse_string },
+	{ "last_mounted",  &set_sb.s_last_mounted, NULL, 64, parse_string },
+	{ "lastcheck",  &set_sb.s_lastcheck, NULL, 4, parse_uint },
+	{ "algorithm_usage_bitmap", &set_sb.s_algorithm_usage_bitmap, NULL,
 		  4, parse_uint },
-	{ "prealloc_blocks", &set_sb.s_prealloc_blocks, 1, parse_uint },
-	{ "prealloc_dir_blocks", &set_sb.s_prealloc_dir_blocks, 1,
+	{ "prealloc_blocks", &set_sb.s_prealloc_blocks, NULL, 1, parse_uint },
+	{ "prealloc_dir_blocks", &set_sb.s_prealloc_dir_blocks, NULL, 1,
 		  parse_uint },
-	{ "reserved_gdt_blocks", &set_sb.s_reserved_gdt_blocks, 2,
+	{ "reserved_gdt_blocks", &set_sb.s_reserved_gdt_blocks, NULL, 2,
 		  parse_uint },
-	{ "journal_uuid", &set_sb.s_journal_uuid, 16, parse_uuid },
-	{ "journal_inum", &set_sb.s_journal_inum, 4, parse_uint },
-	{ "journal_dev", &set_sb.s_journal_dev, 4, parse_uint },
-	{ "last_orphan", &set_sb.s_last_orphan, 4, parse_uint },
-	{ "hash_seed", &set_sb.s_hash_seed, 16, parse_uuid },
-	{ "def_hash_version", &set_sb.s_def_hash_version, 1, parse_hashalg },
-	{ "jnl_backup_type", &set_sb.s_jnl_backup_type, 1, parse_uint },
-	{ "desc_size", &set_sb.s_desc_size, 2, parse_uint },
-	{ "default_mount_opts", &set_sb.s_default_mount_opts, 4, parse_uint },
-	{ "first_meta_bg", &set_sb.s_first_meta_bg, 4, parse_uint },
-	{ "mkfs_time", &set_sb.s_mkfs_time, 4, parse_time },
-	{ "jnl_blocks", &set_sb.s_jnl_blocks[0], 4, parse_uint, FLAG_ARRAY,
+	{ "journal_uuid", &set_sb.s_journal_uuid, NULL, 16, parse_uuid },
+	{ "journal_inum", &set_sb.s_journal_inum, NULL, 4, parse_uint },
+	{ "journal_dev", &set_sb.s_journal_dev, NULL, 4, parse_uint },
+	{ "last_orphan", &set_sb.s_last_orphan, NULL, 4, parse_uint },
+	{ "hash_seed", &set_sb.s_hash_seed, NULL, 16, parse_uuid },
+	{ "def_hash_version", &set_sb.s_def_hash_version, NULL, 1, parse_hashalg },
+	{ "jnl_backup_type", &set_sb.s_jnl_backup_type, NULL, 1, parse_uint },
+	{ "desc_size", &set_sb.s_desc_size, NULL, 2, parse_uint },
+	{ "default_mount_opts", &set_sb.s_default_mount_opts, NULL, 4, parse_uint },
+	{ "first_meta_bg", &set_sb.s_first_meta_bg, NULL, 4, parse_uint },
+	{ "mkfs_time", &set_sb.s_mkfs_time, NULL, 4, parse_time },
+	{ "jnl_blocks", &set_sb.s_jnl_blocks[0], NULL, 4, parse_uint, FLAG_ARRAY,
 	  17 },
-	{ "blocks_count_hi", &set_sb.s_blocks_count_hi, 4, parse_uint },
-	{ "r_blocks_count_hi", &set_sb.s_r_blocks_count_hi, 4, parse_uint },
-	{ "free_blocks_hi", &set_sb.s_free_blocks_hi, 4, parse_uint },
-	{ "min_extra_isize", &set_sb.s_min_extra_isize, 2, parse_uint },
-	{ "want_extra_isize", &set_sb.s_want_extra_isize, 2, parse_uint },
-	{ "flags", &set_sb.s_flags, 4, parse_uint },
-	{ "raid_stride", &set_sb.s_raid_stride, 2, parse_uint },
-	{ "min_extra_isize", &set_sb.s_min_extra_isize, 4, parse_uint },
-	{ "mmp_interval", &set_sb.s_mmp_interval, 2, parse_uint },
-	{ "mmp_block", &set_sb.s_mmp_block, 8, parse_uint },
-	{ "raid_stripe_width", &set_sb.s_raid_stripe_width, 4, parse_uint },
-	{ "log_groups_per_flex", &set_sb.s_log_groups_per_flex, 1, parse_uint },
-	{ "kbytes_written", &set_sb.s_kbytes_written, 8, parse_uint },
-	{ "snapshot_inum", &set_sb.s_snapshot_inum, 4, parse_uint },
-	{ "snapshot_id", &set_sb.s_snapshot_id, 4, parse_uint },
-	{ "snapshot_r_blocks_count", &set_sb.s_snapshot_r_blocks_count, 8, 
-	  parse_uint },
-	{ "snapshot_list", &set_sb.s_snapshot_list, 4, parse_uint },
-	{ "mount_opts",  &set_sb.s_mount_opts, 64, parse_string },
-	{ "usr_quota_inum", &set_sb.s_usr_quota_inum, 4, parse_uint },
-	{ "grp_quota_inum", &set_sb.s_grp_quota_inum, 4, parse_uint },
-	{ "overhead_blocks", &set_sb.s_overhead_blocks, 4, parse_uint },
-	{ "checksum", &set_sb.s_checksum, 4, parse_uint },
+	{ "min_extra_isize", &set_sb.s_min_extra_isize, NULL, 2, parse_uint },
+	{ "want_extra_isize", &set_sb.s_want_extra_isize, NULL, 2, parse_uint },
+	{ "flags", &set_sb.s_flags, NULL, 4, parse_uint },
+	{ "raid_stride", &set_sb.s_raid_stride, NULL, 2, parse_uint },
+	{ "min_extra_isize", &set_sb.s_min_extra_isize, NULL, 4, parse_uint },
+	{ "mmp_interval", &set_sb.s_mmp_interval, NULL, 2, parse_uint },
+	{ "mmp_block", &set_sb.s_mmp_block, NULL, 8, parse_uint },
+	{ "raid_stripe_width", &set_sb.s_raid_stripe_width, NULL, 4, parse_uint },
+	{ "log_groups_per_flex", &set_sb.s_log_groups_per_flex, NULL, 1, parse_uint },
+	{ "kbytes_written", &set_sb.s_kbytes_written, NULL, 8, parse_uint },
+	{ "snapshot_inum", &set_sb.s_snapshot_inum, NULL, 4, parse_uint },
+	{ "snapshot_id", &set_sb.s_snapshot_id, NULL, 4, parse_uint },
+	{ "snapshot_r_blocks_count", &set_sb.s_snapshot_r_blocks_count,
+	  NULL, 8, parse_uint },
+	{ "snapshot_list", &set_sb.s_snapshot_list, NULL, 4, parse_uint },
+	{ "mount_opts",  &set_sb.s_mount_opts, NULL, 64, parse_string },
+	{ "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, parse_uint },
+	{ "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, parse_uint },
+	{ "overhead_blocks", &set_sb.s_overhead_blocks, NULL, 4, parse_uint },
+	{ "checksum", &set_sb.s_checksum, NULL, 4, parse_uint },
 	{ 0, 0, 0, 0 }
 };
 
 static struct field_set_info inode_fields[] = {
-	{ "inodes_count", &set_sb.s_inodes_count, 4, parse_uint },
-	{ "mode", &set_inode.i_mode, 2, parse_uint },
-	{ "uid", &set_inode.i_uid, 2, parse_uint },
-	{ "size", &set_inode.i_size, 4, parse_uint },
-	{ "atime", &set_inode.i_atime, 4, parse_time },
-	{ "ctime", &set_inode.i_ctime, 4, parse_time },
-	{ "mtime", &set_inode.i_mtime, 4, parse_time },
-	{ "dtime", &set_inode.i_dtime, 4, parse_time },
-	{ "gid", &set_inode.i_gid, 2, parse_uint },
-	{ "links_count", &set_inode.i_links_count, 2, parse_uint },
-	{ "blocks", &set_inode.i_blocks, 4, parse_uint },
-	{ "flags", &set_inode.i_flags, 4, parse_uint },
-	{ "version", &set_inode.osd1.linux1.l_i_version, 4, parse_uint },
-	{ "translator", &set_inode.osd1.hurd1.h_i_translator, 4, parse_uint },
-	{ "block", &set_inode.i_block[0], 4, parse_uint, FLAG_ARRAY,
+	{ "inodes_count", &set_sb.s_inodes_count, NULL, 4, parse_uint },
+	{ "mode", &set_inode.i_mode, NULL, 2, parse_uint },
+	{ "uid", &set_inode.i_uid, &set_inode.osd2.linux2.l_i_uid_high,
+		2, parse_uint },
+	{ "size", &set_inode.i_size, &set_inode.i_size_high, 4, parse_uint },
+	{ "atime", &set_inode.i_atime, NULL, 4, parse_time },
+	{ "ctime", &set_inode.i_ctime, NULL, 4, parse_time },
+	{ "mtime", &set_inode.i_mtime, NULL, 4, parse_time },
+	{ "dtime", &set_inode.i_dtime, NULL, 4, parse_time },
+	{ "gid", &set_inode.i_gid, &set_inode.osd2.linux2.l_i_gid_high,
+		2, parse_uint },
+	{ "links_count", &set_inode.i_links_count, NULL, 2, parse_uint },
+	/* Special case: i_blocks is 4 bytes, i_blocks_high is 2 bytes */
+	{ "blocks", &set_inode.i_blocks, &set_inode.osd2.linux2.l_i_blocks_hi,
+		6, parse_uint },
+	{ "flags", &set_inode.i_flags, NULL, 4, parse_uint },
+	{ "version", &set_inode.osd1.linux1.l_i_version,
+		&set_inode.i_version_hi, 4, parse_uint },
+	{ "translator", &set_inode.osd1.hurd1.h_i_translator, NULL, 4, parse_uint },
+	{ "block", &set_inode.i_block[0], NULL, 4, parse_uint, FLAG_ARRAY,
 	  EXT2_NDIR_BLOCKS },
-	{ "block[IND]", &set_inode.i_block[EXT2_IND_BLOCK], 4, parse_uint },
-	{ "block[DIND]", &set_inode.i_block[EXT2_DIND_BLOCK], 4, parse_uint },
-	{ "block[TIND]", &set_inode.i_block[EXT2_TIND_BLOCK], 4, parse_uint },
-	{ "generation", &set_inode.i_generation, 4, parse_uint },
-	{ "file_acl", &set_inode.i_file_acl, 4, parse_uint },
-	{ "file_acl_high", &set_inode.osd2.linux2.l_i_file_acl_high, 2,
-	  parse_uint },
-	{ "dir_acl", &set_inode.i_dir_acl, 4, parse_uint },
-	{ "size_high", &set_inode.i_size_high, 4, parse_uint },
-	{ "faddr", &set_inode.i_faddr, 4, parse_uint },
-	{ "blocks_hi", &set_inode.osd2.linux2.l_i_blocks_hi, 2, parse_uint },
-	{ "frag", &set_inode.osd2.hurd2.h_i_frag, 1, parse_uint },
-	{ "fsize", &set_inode.osd2.hurd2.h_i_fsize, 1, parse_uint },
-	{ "uid_high", &set_inode.osd2.linux2.l_i_uid_high, 2, parse_uint },
-	{ "gid_high", &set_inode.osd2.linux2.l_i_gid_high, 2, parse_uint },
-	{ "checksum", &set_inode.osd2.linux2.l_i_checksum_lo, 2, parse_uint },
-	{ "author", &set_inode.osd2.hurd2.h_i_author, 4, parse_uint },
-	{ "bmap", NULL, 4, parse_bmap, FLAG_ARRAY },
+	{ "block[IND]", &set_inode.i_block[EXT2_IND_BLOCK], NULL, 4, parse_uint },
+	{ "block[DIND]", &set_inode.i_block[EXT2_DIND_BLOCK], NULL, 4, parse_uint },
+	{ "block[TIND]", &set_inode.i_block[EXT2_TIND_BLOCK], NULL, 4, parse_uint },
+	{ "generation", &set_inode.i_generation, NULL, 4, parse_uint },
+	/* Special case: i_file_acl_high is 2 bytes */
+	{ "file_acl", &set_inode.i_file_acl, 
+		&set_inode.osd2.linux2.l_i_file_acl_high, 6, parse_uint },
+	{ "dir_acl", &set_inode.i_dir_acl, NULL, 4, parse_uint },
+	{ "faddr", &set_inode.i_faddr, NULL, 4, parse_uint },
+	{ "frag", &set_inode.osd2.hurd2.h_i_frag, NULL, 1, parse_uint },
+	{ "fsize", &set_inode.osd2.hurd2.h_i_fsize, NULL, 1, parse_uint },
+	{ "checksum", &set_inode.osd2.linux2.l_i_checksum_lo, 
+		&set_inode.i_checksum_hi, 2, parse_uint },
+	{ "author", &set_inode.osd2.hurd2.h_i_author, NULL,
+		4, parse_uint },
+	{ "extra_isize", &set_inode.i_extra_isize, NULL,
+		2, parse_uint },
+	{ "ctime_extra", &set_inode.i_ctime_extra, NULL,
+		4, parse_uint },
+	{ "mtime_extra", &set_inode.i_mtime_extra, NULL,
+		4, parse_uint },
+	{ "atime_extra", &set_inode.i_atime_extra, NULL,
+		4, parse_uint },
+	{ "crtime", &set_inode.i_crtime, NULL, 4, parse_uint },
+	{ "crtime_extra", &set_inode.i_crtime_extra, NULL,
+		4, parse_uint },
+	{ "bmap", NULL, NULL, 4, parse_bmap, FLAG_ARRAY },
 	{ 0, 0, 0, 0 }
 };
 
 static struct field_set_info ext2_bg_fields[] = {
-	{ "block_bitmap", &set_gd.bg_block_bitmap, 4, parse_uint },
-	{ "inode_bitmap", &set_gd.bg_inode_bitmap, 4, parse_uint },
-	{ "inode_table", &set_gd.bg_inode_table, 4, parse_uint },
-	{ "free_blocks_count", &set_gd.bg_free_blocks_count, 2, parse_uint },
-	{ "free_inodes_count", &set_gd.bg_free_inodes_count, 2, parse_uint },
-	{ "used_dirs_count", &set_gd.bg_used_dirs_count, 2, parse_uint },
-	{ "flags", &set_gd.bg_flags, 2, parse_uint },
-	{ "itable_unused", &set_gd.bg_itable_unused, 2, parse_uint },
-	{ "checksum", &set_gd.bg_checksum, 2, parse_gd_csum },
+	{ "block_bitmap", &set_gd.bg_block_bitmap, NULL, 4, parse_uint },
+	{ "inode_bitmap", &set_gd.bg_inode_bitmap, NULL, 4, parse_uint },
+	{ "inode_table", &set_gd.bg_inode_table, NULL, 4, parse_uint },
+	{ "free_blocks_count", &set_gd.bg_free_blocks_count, NULL, 2, parse_uint },
+	{ "free_inodes_count", &set_gd.bg_free_inodes_count, NULL, 2, parse_uint },
+	{ "used_dirs_count", &set_gd.bg_used_dirs_count, NULL, 2, parse_uint },
+	{ "flags", &set_gd.bg_flags, NULL, 2, parse_uint },
+	{ "itable_unused", &set_gd.bg_itable_unused, NULL, 2, parse_uint },
+	{ "checksum", &set_gd.bg_checksum, NULL, 2, parse_gd_csum },
 	{ 0, 0, 0, 0 }
 };
 
+static struct field_set_info ext4_bg_fields[] = {
+	{ "block_bitmap", &set_gd4.bg_block_bitmap,
+		&set_gd4.bg_block_bitmap_hi, 4, parse_uint },
+	{ "inode_bitmap", &set_gd4.bg_inode_bitmap,
+		&set_gd4.bg_inode_bitmap_hi, 4, parse_uint },
+	{ "inode_table", &set_gd4.bg_inode_table,
+		&set_gd4.bg_inode_table_hi, 4, parse_uint },
+	{ "free_blocks_count", &set_gd4.bg_free_blocks_count,
+		&set_gd4.bg_free_blocks_count_hi, 2, parse_uint },
+	{ "free_inodes_count", &set_gd4.bg_free_inodes_count,
+		&set_gd4.bg_free_inodes_count_hi, 2, parse_uint },
+	{ "used_dirs_count", &set_gd4.bg_used_dirs_count,
+		&set_gd4.bg_used_dirs_count_hi, 2, parse_uint },
+	{ "flags", &set_gd4.bg_flags, NULL, 2, parse_uint },
+	{ "exclude_bitmap", &set_gd4.bg_exclude_bitmap_lo,
+		&set_gd4.bg_exclude_bitmap_hi, 4, parse_uint },
+	{ "block_bitmap_csum", &set_gd4.bg_block_bitmap_csum_lo,
+		&set_gd4.bg_block_bitmap_csum_hi, 2, parse_uint },
+	{ "inode_bitmap_csum", &set_gd4.bg_inode_bitmap_csum_lo,
+		&set_gd4.bg_inode_bitmap_csum_hi, 2, parse_uint },
+	{ "itable_unused", &set_gd4.bg_itable_unused,
+		&set_gd4.bg_itable_unused_hi, 2, parse_uint },
+	{ "checksum", &set_gd4.bg_checksum, NULL, 2, parse_gd_csum },
+	{ 0, 0, 0, 0 }
+};
+
+static int check_suffix(const char *field)
+{
+	int len = strlen(field);
+
+	if (len <= 3)
+		return 0;
+	field += len-3;
+	if (!strcmp(field, "_lo"))
+		return 1;
+	if (!strcmp(field, "_hi"))
+		return 2;
+	return 0;
+}
 
 static struct field_set_info *find_field(struct field_set_info *fields,
 					 char *field)
@@ -206,7 +261,7 @@ static struct field_set_info *find_field(struct field_set_info *fields,
 	struct field_set_info *ss;
 	const char	*prefix;
 	char		*arg, *delim, *idx, *tmp;
-	int		prefix_len;
+	int		suffix, prefix_len;
 
 	if (fields == super_fields)
 		prefix = "s_";
@@ -241,14 +296,23 @@ static struct field_set_info *find_field(struct field_set_info *fields,
 			idx = 0;
 	}
 
+	/*
+	 * If there is a valid _hi or a _lo suffix, strip it off
+	 */
+	suffix = check_suffix(arg);
+	if (suffix > 0)
+		arg[strlen(arg)-3] = 0;
+
 	for (ss = fields ; ss->name ; ss++) {
+		if (suffix && ss->ptr2 == 0)
+			continue;
 		if (ss->flags & FLAG_ARRAY) {
 			if (!idx || (strcmp(ss->name, arg) != 0))
 				continue;
 			if (ss->max_idx > 0 && array_idx >= ss->max_idx)
 				continue;
 		} else {
-			if (strcmp(ss->name, field) != 0)
+			if (strcmp(ss->name, arg) != 0)
 				continue;
 		}
 		free(arg);
@@ -258,10 +322,19 @@ static struct field_set_info *find_field(struct field_set_info *fields,
 	return NULL;
 }
 
-static errcode_t parse_uint(struct field_set_info *info, char *arg)
+/*
+ * Note: info->size == 6 is special; this means a base size 4 bytes,
+ * and secondiory (high) size of 2 bytes.  This is needed for the
+ * special case of i_blocks_high and i_file_acl_high.
+ */
+static errcode_t parse_uint(struct field_set_info *info, char *field,
+			    char *arg)
 {
-	unsigned long long num, limit;
+	unsigned long long n, num, mask, limit;
+	int suffix = check_suffix(field);
 	char *tmp;
+	void *field1 = info->ptr, *field2 = info->ptr2;
+	int size = (info->size == 6) ? 4 : info->size;
 	union {
 		__u64	*ptr64;
 		__u32	*ptr32;
@@ -269,7 +342,14 @@ static errcode_t parse_uint(struct field_set_info *info, char *arg)
 		__u8	*ptr8;
 	} u;
 
-	u.ptr8 = (__u8 *) info->ptr;
+	if (suffix == 1)
+		field2 = 0;
+	if (suffix == 2) {
+		field1 = field2;
+		field2 = 0;
+	}
+
+	u.ptr8 = (__u8 *) field1;
 	if (info->flags & FLAG_ARRAY)
 		u.ptr8 += array_idx * info->size;
 
@@ -280,30 +360,55 @@ static errcode_t parse_uint(struct field_set_info *info, char *arg)
 			arg, info->name);
 		return EINVAL;
 	}
+	mask = ~0ULL >> ((8 - size) * 8);
 	limit = ~0ULL >> ((8 - info->size) * 8);
+	if (field2 && info->size != 6)
+		limit = ~0ULL >> ((8 - info->size*2) * 8);
+
 	if (num > limit) {
 		fprintf(stderr, "Value '%s' exceeds field %s maximum %llu.\n",
 			arg, info->name, limit);
 		return EINVAL;
 	}
-	switch (info->size) {
+	n = num & mask;
+	switch (size) {
 	case 8:
-		*u.ptr64 = num;
+		*u.ptr64 = n;
 		break;
 	case 4:
-		*u.ptr32 = num;
+		*u.ptr32 = n;
 		break;
 	case 2:
-		*u.ptr16 = num;
+		*u.ptr16 = n;
 		break;
 	case 1:
-		*u.ptr8 = num;
+		*u.ptr8 = n;
+		break;
+	}
+	if (!field2)
+		return 0;
+	n = num >> (size*8);
+	u.ptr8 = (__u8 *) field2;
+	if (info->size == 6)
+		size = 2;
+	switch (size) {
+	case 8:
+		*u.ptr64 = n;
+		break;
+	case 4:
+		*u.ptr32 = n;
+		break;
+	case 2:
+		*u.ptr16 = n;
+		break;
+	case 1:
+		*u.ptr8 = n;
 		break;
 	}
 	return 0;
 }
 
-static errcode_t parse_int(struct field_set_info *info, char *arg)
+static errcode_t parse_int(struct field_set_info *info, char *field, char *arg)
 {
 	long	num;
 	char *tmp;
@@ -334,7 +439,8 @@ static errcode_t parse_int(struct field_set_info *info, char *arg)
 	return 0;
 }
 
-static errcode_t parse_string(struct field_set_info *info, char *arg)
+static errcode_t parse_string(struct field_set_info *info, char *field,
+			      char *arg)
 {
 	char	*cp = (char *) info->ptr;
 
@@ -347,7 +453,7 @@ static errcode_t parse_string(struct field_set_info *info, char *arg)
 	return 0;
 }
 
-static errcode_t parse_time(struct field_set_info *info, char *arg)
+static errcode_t parse_time(struct field_set_info *info, char *field, char *arg)
 {
 	time_t		t;
 	__u32		*ptr32;
@@ -365,7 +471,7 @@ static errcode_t parse_time(struct field_set_info *info, char *arg)
 	return 0;
 }
 
-static errcode_t parse_uuid(struct field_set_info *info, char *arg)
+static errcode_t parse_uuid(struct field_set_info *info, char *field, char *arg)
 {
 	unsigned char *	p = (unsigned char *) info->ptr;
 
@@ -383,7 +489,8 @@ static errcode_t parse_uuid(struct field_set_info *info, char *arg)
 	return 0;
 }
 
-static errcode_t parse_hashalg(struct field_set_info *info, char *arg)
+static errcode_t parse_hashalg(struct field_set_info *info, char *field,
+			       char *arg)
 {
 	int	hashv;
 	unsigned char	*p = (unsigned char *) info->ptr;
@@ -397,7 +504,8 @@ static errcode_t parse_hashalg(struct field_set_info *info, char *arg)
 	return 0;
 }
 
-static errcode_t parse_bmap(struct field_set_info *info, char *arg)
+static errcode_t parse_bmap(struct field_set_info *info, char *field,
+			    char *arg)
 {
 	unsigned long	num;
 	blk_t		blk;
@@ -412,15 +520,17 @@ static errcode_t parse_bmap(struct field_set_info *info, char *arg)
 	}
 	blk = num;
 
-	retval = ext2fs_bmap(current_fs, set_ino, &set_inode, 0, BMAP_SET,
-			     array_idx, &blk);
+	retval = ext2fs_bmap(current_fs, set_ino,
+			     (struct ext2_inode *) &set_inode,
+			     0, BMAP_SET, array_idx, &blk);
 	if (retval) {
 		com_err("set_inode", retval, "while setting block map");
 	}
 	return retval;
 }
 
-static errcode_t parse_gd_csum(struct field_set_info *info, char *arg)
+static errcode_t parse_gd_csum(struct field_set_info *info, char *field,
+			       char *arg)
 {
 
 	if (strcmp(arg, "calc") == 0) {
@@ -434,7 +544,7 @@ static errcode_t parse_gd_csum(struct field_set_info *info, char *arg)
 		return 0;
 	}
 
-	return parse_uint(info, arg);
+	return parse_uint(info, field, arg);
 }
 
 static void print_possible_fields(struct field_set_info *fields)
@@ -474,6 +584,8 @@ static void print_possible_fields(struct field_set_info *fields)
 			type = "date/time";
 		else if (ss->func == parse_bmap)
 			type = "set physical->logical block map";
+		else if (ss->func == parse_gd_csum)
+			type = "unsigned integer OR \"calc\"";
 		strcpy(name, ss->name);
 		if (ss->flags & FLAG_ARRAY) {
 			if (ss->max_idx > 0)
@@ -482,7 +594,9 @@ static void print_possible_fields(struct field_set_info *fields)
 				strcpy(idx, "[]");
 			strcat(name, idx);
 		}
-		fprintf(f, "\t%-20s\t%s\n", name, type);
+		if (ss->ptr2)
+			strcat(name, "[_hi|_lo]");
+		fprintf(f, "\t%-25s\t%s\n", name, type);
 	}
 	close_pager(f);
 }
@@ -509,7 +623,7 @@ void do_set_super(int argc, char *argv[])
 		return;
 	}
 	set_sb = *current_fs->super;
-	if (ss->func(ss, argv[2]) == 0) {
+	if (ss->func(ss, argv[1], argv[2]) == 0) {
 		*current_fs->super = set_sb;
 		ext2fs_mark_super_dirty(current_fs);
 	}
@@ -540,11 +654,15 @@ void do_set_inode(int argc, char *argv[])
 	if (!set_ino)
 		return;
 
-	if (debugfs_read_inode(set_ino, &set_inode, argv[1]))
+	if (debugfs_read_inode_full(set_ino,
+			(struct ext2_inode *) &set_inode, argv[1],
+				    sizeof(set_inode)))
 		return;
 
-	if (ss->func(ss, argv[3]) == 0) {
-		if (debugfs_write_inode(set_ino, &set_inode, argv[1]))
+	if (ss->func(ss, argv[2], argv[3]) == 0) {
+		if (debugfs_write_inode_full(set_ino, 
+			     (struct ext2_inode *) &set_inode,
+			     argv[1], sizeof(set_inode)))
 			return;
 	}
 }
@@ -554,11 +672,29 @@ void do_set_block_group_descriptor(int argc, char *argv[])
 	const char *usage = "<bg number> <field> <value>\n"
 		"\t\"set_block_group_descriptor -l\" will list the names of "
 		"the fields in a block group descriptor\n\twhich can be set.";
+	struct field_set_info	*table;
 	struct field_set_info	*ss;
 	char			*end;
+	void			*edit, *target;
+	int			size;
+
+	/*
+	 *Determine whether we are editing an ext2 or ext4 block
+	 * group descriptor
+	 */
+	if (current_fs && current_fs->super->s_feature_incompat &
+	    EXT4_FEATURE_INCOMPAT_64BIT) {
+		table = ext4_bg_fields;
+		edit = &set_gd4;
+		size = sizeof(set_gd4);
+	} else {
+		table = ext2_bg_fields;
+		edit = &set_gd;
+		size = sizeof(set_gd);
+	}
 
 	if ((argc == 2) && !strcmp(argv[1], "-l")) {
-		print_possible_fields(ext2_bg_fields);
+		print_possible_fields(table);
 		return;
 	}
 
@@ -577,20 +713,15 @@ void do_set_block_group_descriptor(int argc, char *argv[])
 		return;
 	}
 
-
-	if ((ss = find_field(ext2_bg_fields, argv[2])) == 0) {
+	if ((ss = find_field(table, argv[2])) == 0) {
 		com_err(argv[0], 0, "invalid field specifier: %s", argv[2]);
 		return;
 	}
 
-	memcpy(&set_gd, ext2fs_group_desc(current_fs,
-				current_fs->group_desc, set_bg),
-		sizeof(set_gd));
-
-	if (ss->func(ss, argv[3]) == 0) {
-		memcpy(ext2fs_group_desc(current_fs,
-				current_fs->group_desc, set_bg),
-		       &set_gd, sizeof(set_gd));
+	target = ext2fs_group_desc(current_fs, current_fs->group_desc, set_bg);
+	memcpy(edit, target, size);
+	if (ss->func(ss, argv[2], argv[3]) == 0) {
+		memcpy(target, edit, size);
 		ext2fs_mark_super_dirty(current_fs);
 	}
 }
diff --git a/debugfs/util.c b/debugfs/util.c
index c3ac6f8..34fc179 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -401,6 +401,22 @@ int debugfs_read_inode(ext2_ino_t ino, struct ext2_inode * inode,
 	return 0;
 }
 
+int debugfs_write_inode_full(ext2_ino_t ino,
+			     struct ext2_inode *inode,
+			     const char *cmd,
+			     int bufsize)
+{
+	int retval;
+
+	retval = ext2fs_write_inode_full(current_fs, ino,
+					 inode, bufsize);
+	if (retval) {
+		com_err(cmd, retval, "while writing inode %u", ino);
+		return 1;
+	}
+	return 0;
+}
+
 int debugfs_write_inode(ext2_ino_t ino, struct ext2_inode * inode,
 			const char *cmd)
 {
-- 
1.7.4.1.22.gec8e1.dirty

