From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 11/12] Add support for new compat feature "sparse_super2"
Date: Mon, 20 Jan 2014 00:54:13 -0500
Message-ID: <1390197254-14583-12-git-send-email-tytso@mit.edu>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49954 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbaATFyY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 00:54:24 -0500
In-Reply-To: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In practice, it is **extremely** rare for users to try to use more
than the first backup superblock located at the beginning of block
group #1.  (i.e., at block number 32768 for file systems with a 4k
block size).  This new compat feature restricts the backup superblock
to block group #1 and the last block group in the file system.

Aside from reducing the overhead of the file system by a small number
of blocks, by eliminating the rest of the backup superblocks, it
allows us to have a much more flexible metadata layout.  For example,
we can force all of the allocation bitmaps and inode table blocks to
the beginning of the disk, which allows most of the disk to be
exclusively used for contiguous data blocks.

This simplifies taking advantage of certain HDD specific features,
such as Shingled Magnetic Recording (aka Shingled Drives), and the
TCG's OPAL Storage Specification where having a simple mapping between
LBA block ranges and the data blocks used by the file system can make
life much simpler.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/set_fields.c        |   2 +
 lib/e2p/feature.c           |   2 +
 lib/e2p/ls.c                |   8 ++
 lib/ext2fs/closefs.c        |  12 ++-
 lib/ext2fs/ext2_fs.h        |   4 +-
 lib/ext2fs/ext2fs.h         |   3 +-
 lib/ext2fs/initialize.c     |   2 +
 lib/ext2fs/res_gdt.c        |  13 ++++
 lib/ext2fs/swapfs.c         |   2 +
 lib/ext2fs/tst_super_size.c |   3 +-
 misc/ext4.5.in              |  11 +++
 misc/mke2fs.8.in            |   6 ++
 misc/mke2fs.c               |  30 +++++++-
 misc/mke2fs.conf.5.in       |   5 ++
 resize/online.c             |   8 ++
 resize/resize2fs.c          | 182 +++++++++++++++++++++++++++++++++++++++++++-
 16 files changed, 284 insertions(+), 9 deletions(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 9c3b000..ffbda74 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -150,6 +150,8 @@ static struct field_set_info super_fields[] = {
 	{ "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, parse_uint },
 	{ "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, parse_uint },
 	{ "overhead_blocks", &set_sb.s_overhead_blocks, NULL, 4, parse_uint },
+	{ "backup_bgs", &set_sb.s_backup_bgs[0], NULL, 4, parse_uint,
+	  FLAG_ARRAY, 2 },
 	{ "checksum", &set_sb.s_checksum, NULL, 4, parse_uint },
 	{ 0, 0, 0, 0 }
 };
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 9691263..1d3e689 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -43,6 +43,8 @@ static struct feature feature_list[] = {
 			"lazy_bg" },
 	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP,
 			"snapshot_bitmap" },
+	{	E2P_FEATURE_COMPAT, EXT4_FEATURE_COMPAT_SPARSE_SUPER2,
+			"sparse_super2" },
 
 	{	E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER,
 			"sparse_super" },
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 5b3d3c8..6f741c0 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -368,6 +368,14 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 			fprintf(f, "type %u\n", sb->s_jnl_backup_type);
 		}
 	}
+	if (sb->s_backup_bgs[0] || sb->s_backup_bgs[1]) {
+		fprintf(f, "Backup block groups:      ");
+		if (sb->s_backup_bgs[0])
+			fprintf(f, "%u ", sb->s_backup_bgs[0]);
+		if (sb->s_backup_bgs[1])
+			fprintf(f, "%u ", sb->s_backup_bgs[1]);
+		fputc('\n', f);
+	}
 	if (sb->s_snapshot_inum) {
 		fprintf(f, "Snapshot inode:           %u\n",
 			sb->s_snapshot_inum);
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 3e4af7f..4e91778 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -35,8 +35,16 @@ static int test_root(unsigned int a, unsigned int b)
 
 int ext2fs_bg_has_super(ext2_filsys fs, dgrp_t group)
 {
-	if (!(fs->super->s_feature_ro_compat &
-	      EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER) || group <= 1)
+	if (group == 0)
+		return 1;
+	if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2) {
+		if (group == fs->super->s_backup_bgs[0] ||
+		    group == fs->super->s_backup_bgs[1])
+			return 1;
+		return 0;
+	}
+	if ((group <= 1) || !(fs->super->s_feature_ro_compat &
+			      EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER))
 		return 1;
 	if (!(group & 1))
 		return 0;
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 930c2a3..d9e14d7 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -645,7 +645,8 @@ struct ext2_super_block {
 	__u32	s_usr_quota_inum;	/* inode number of user quota file */
 	__u32	s_grp_quota_inum;	/* inode number of group quota file */
 	__u32	s_overhead_blocks;	/* overhead blocks/clusters in fs */
-	__u32   s_reserved[108];        /* Padding to the end of the block */
+	__u32	s_backup_bgs[2];	/* If sparse_super2 enabled */
+	__u32   s_reserved[106];        /* Padding to the end of the block */
 	__u32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -696,6 +697,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_COMPAT_LAZY_BG		0x0040
 /* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE	0x0080 not used, legacy */
 #define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP	0x0100
+#define EXT4_FEATURE_COMPAT_SPARSE_SUPER2	0x0200
 
 
 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 47340dd..efe0964 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -550,7 +550,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_COMPAT_HAS_JOURNAL|\
 					 EXT2_FEATURE_COMPAT_RESIZE_INODE|\
 					 EXT2_FEATURE_COMPAT_DIR_INDEX|\
-					 EXT2_FEATURE_COMPAT_EXT_ATTR)
+					 EXT2_FEATURE_COMPAT_EXT_ATTR|\
+					 EXT4_FEATURE_COMPAT_SPARSE_SUPER2)
 
 /* This #ifdef is temporary until compression is fully supported */
 #ifdef ENABLE_COMPRESSION
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 2db8b3c..dc6c419 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -173,6 +173,8 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	set_field(s_raid_stripe_width, 0);	/* default stripe width: 0 */
 	set_field(s_log_groups_per_flex, 0);
 	set_field(s_flags, 0);
+	assign_field(s_backup_bgs[0]);
+	assign_field(s_backup_bgs[1]);
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
 		goto cleanup;
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index 6449228..e61c330 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -31,6 +31,19 @@ static unsigned int list_backups(ext2_filsys fs, unsigned int *three,
 	int mult = 3;
 	unsigned int ret;
 
+	if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2) {
+		if (*min == 1) {
+			*min += 1;
+			if (fs->super->s_backup_bgs[0])
+				return fs->super->s_backup_bgs[0];
+		}
+		if (*min == 2) {
+			*min += 1;
+			if (fs->super->s_backup_bgs[1])
+				return fs->super->s_backup_bgs[1];
+		}
+		return fs->group_desc_count;
+	}
 	if (!(fs->super->s_feature_ro_compat &
 	      EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
 		ret = *min;
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 56c66cc..2a7b768 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -99,6 +99,8 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	}
 	for (; i < 17; i++)
 		sb->s_jnl_blocks[i] = ext2fs_swab32(sb->s_jnl_blocks[i]);
+	sb->s_backup_bgs[0] = ext2fs_swab32(sb->s_backup_bgs[0]);
+	sb->s_backup_bgs[1] = ext2fs_swab32(sb->s_backup_bgs[1]);
 }
 
 void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
index 85d87e1..f9cec8a 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -135,7 +135,8 @@ int main(int argc, char **argv)
 	check_field(s_usr_quota_inum, 4);
 	check_field(s_grp_quota_inum, 4);
 	check_field(s_overhead_blocks, 4);
-	check_field(s_reserved, 108 * 4);
+	check_field(s_backup_bgs, 8);
+	check_field(s_reserved, 106 * 4);
 	check_field(s_checksum, 4);
 	do_field("Superblock end", 0, 0, cur_offset, 1024);
 #endif
diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index fab1139..5ec39f5 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -171,6 +171,17 @@ kernels from mounting file systems that they could not understand.
 .\" .br
 .\" .B Future feature, available in e2fsprogs 1.43-WIP
 .TP
+.B sparse_super2
+.br
+This feature indicates that there will only at most two backup
+superblock and block group descriptors.  The block groups used to store
+the backup superblock and blockgroup descriptors are stored in the
+superblock, but typically, one will be located at the beginning of block
+group #1, and one in the last block group in the file system.  This is
+feature is essentially a more extreme version of sparse_super and is
+designed to allow the a much larger percentage of the disk to have
+contiguous blocks available for data files.
+.TP
 .B meta_bg
 .br
 This ext4 feature allows file systems to be resized on-line without explicitly
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 67ddbf8..483fb1c 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -274,6 +274,12 @@ small risk if the system crashes before the journal has been overwritten
 entirely one time.  If the option value is omitted, it defaults to 1 to
 enable lazy journal inode zeroing.
 .TP
+.BI num_backup_sb= <0|1|2>
+If the
+.B sparse_super2
+file system feature is enabled this option controls whether there will
+be 0, 1, or 2 backup superblocks created in the file system.
+.TP
 .BI root_owner [=uid:gid]
 Specify the numeric user and group ID of the root directory.  If no UID:GID
 is specified, use the user and group ID of the user running \fBmke2fs\fR.
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7daa87e..efb068a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -88,6 +88,7 @@ static int	discard = 1;	/* attempt to discard device before fs creation */
 static int	direct_io;
 static int	force;
 static int	noaction;
+static int	num_backups = 2; /* number of backup bg's for sparse_super2 */
 static uid_t	root_uid;
 static gid_t	root_gid;
 int	journal_size;
@@ -738,6 +739,21 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				r_usage++;
 				continue;
 			}
+		} else if (strcmp(token, "num_backup_sb") == 0) {
+			if (!arg) {
+				r_usage++;
+				badopt = token;
+				continue;
+			}
+			num_backups = strtoul(arg, &p, 0);
+			if (*p || num_backups > 2) {
+				fprintf(stderr,
+					_("Invalid # of backup "
+					  "superbocks: %s\n"),
+					arg);
+				r_usage++;
+				continue;
+			}
 		} else if (strcmp(token, "stride") == 0) {
 			if (!arg) {
 				r_usage++;
@@ -894,6 +910,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\tis set off by an equals ('=') sign.\n\n"
 			"Valid extended options are:\n"
 			"\tmmp_update_interval=<interval>\n"
+			"\tnum_backup_sb=<0|1|2>\n"
 			"\tstride=<RAID per-disk data chunk in blocks>\n"
 			"\tstripe-width=<RAID stride * data disks in blocks>\n"
 			"\toffset=<offset to create the file system>\n"
@@ -924,7 +941,8 @@ static __u32 ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX |
-		EXT2_FEATURE_COMPAT_EXT_ATTR,
+		EXT2_FEATURE_COMPAT_EXT_ATTR |
+		EXT4_FEATURE_COMPAT_SPARSE_SUPER2,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE|
 		EXT3_FEATURE_INCOMPAT_EXTENTS|
@@ -1974,6 +1992,8 @@ profile_error:
 	}
 #endif
 
+	num_backups = get_int_from_profile(fs_types, "num_backup_sb", 2);
+
 	blocksize = EXT2_BLOCK_SIZE(&fs_param);
 
 	/*
@@ -2593,8 +2613,14 @@ int main (int argc, char *argv[])
 		read_bb_file(fs, &bb_list, bad_blocks_filename);
 	if (cflag)
 		test_disk(fs, &bb_list);
-
 	handle_bad_blocks(fs, bb_list);
+
+	if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2) {
+		if (fs->group_desc_count > 1 && num_backups >= 1)
+			fs->super->s_backup_bgs[0] = 1;
+		if (fs->group_desc_count > 2 && num_backups >= 2)
+			fs->super->s_backup_bgs[1] = fs->group_desc_count - 1;
+	}
 	fs->stride = fs_stride = fs->super->s_raid_stride;
 	if (!quiet)
 		printf("%s", _("Allocating group tables: "));
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index 0625d0e..43bb91e 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -357,6 +357,11 @@ initialization noticeably, but it requires the kernel to finish
 initializing the filesystem in the background when the filesystem is
 first mounted.
 .TP
+.I num_backup_sb
+This relation indicates whether file systems with the
+.B sparse_super2
+feature enabled should be created with 0, 1, or 2 backup superblocks.
+.TP
 .I inode_ratio
 This relation specifies the default inode ratio if the user does not
 specify one on the command line.
diff --git a/resize/online.c b/resize/online.c
index defcac1..46d86b0 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -76,6 +76,14 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 			no_resize_ioctl = 1;
 	}
 
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+				    EXT4_FEATURE_COMPAT_SPARSE_SUPER2) &&
+	    (access("/sys/fs/ext4/features/sparse_super2", R_OK) != 0)) {
+		com_err(program_name, 0, _("kernel does not support online "
+					   "resize with sparse_super2"));
+		exit(1);
+	}
+
 	printf(_("Filesystem at %s is mounted on %s; "
 		 "on-line resizing required\n"), fs->device_name, mtpt);
 
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index c4c2517..b0c4b5e 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -53,6 +53,9 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
 static errcode_t fix_sb_journal_backup(ext2_filsys fs);
 static errcode_t mark_table_blocks(ext2_filsys fs,
 				   ext2fs_block_bitmap bmap);
+static errcode_t clear_sparse_super2_last_group(ext2_resize_t rfs);
+static errcode_t reserve_sparse_super2_last_group(ext2_resize_t rfs,
+						 ext2fs_block_bitmap meta_bmap);
 
 /*
  * Some helper CPP macros
@@ -191,6 +194,10 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 		goto errout;
 	print_resource_track(rfs, &rtrack, fs->io);
 
+	retval = clear_sparse_super2_last_group(rfs);
+	if (retval)
+		goto errout;
+
 	rfs->new_fs->super->s_state &= ~EXT2_ERROR_FS;
 	rfs->new_fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 
@@ -460,6 +467,33 @@ retry:
 	}
 
 	/*
+	 * Update the location of the backup superblocks if the
+	 * sparse_super2 feature is enabled.
+	 */
+	if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2) {
+		dgrp_t last_bg = fs->group_desc_count - 1;
+		dgrp_t old_last_bg = old_fs->group_desc_count - 1;
+
+		if (last_bg > old_last_bg) {
+			if (old_fs->group_desc_count == 1)
+				fs->super->s_backup_bgs[0] = 1;
+			if (old_fs->group_desc_count == 1 &&
+			    fs->super->s_backup_bgs[0])
+				fs->super->s_backup_bgs[0] = last_bg;
+			else if (fs->super->s_backup_bgs[1])
+				fs->super->s_backup_bgs[1] = last_bg;
+		} else if (last_bg < old_last_bg) {
+			if (fs->super->s_backup_bgs[0] > last_bg)
+				fs->super->s_backup_bgs[0] = 0;
+			if (fs->super->s_backup_bgs[1] > last_bg)
+				fs->super->s_backup_bgs[1] = 0;
+			if (last_bg > 1 &&
+			    old_fs->super->s_backup_bgs[1] == old_last_bg)
+				fs->super->s_backup_bgs[1] = last_bg;
+		}
+	}
+
+	/*
 	 * If we are shrinking the number of block groups, we're done
 	 * and can exit now.
 	 */
@@ -615,14 +649,13 @@ errout:
  */
 static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
 {
-	ext2_filsys fs;
+	ext2_filsys	fs = rfs->new_fs;
 	int		adj = 0;
 	errcode_t	retval;
 	blk64_t		group_block;
 	unsigned long	i;
 	unsigned long	max_group;
 
-	fs = rfs->new_fs;
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
 	ext2fs_mark_ib_dirty(fs);
@@ -952,6 +985,10 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		new_blocks = fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
 	}
 
+	retval = reserve_sparse_super2_last_group(rfs, meta_bmap);
+	if (retval)
+		goto errout;
+
 	if (old_blocks == new_blocks) {
 		retval = 0;
 		goto errout;
@@ -1840,6 +1877,147 @@ errout:
 }
 
 /*
+ * This function is used when expanding a file system.  It frees the
+ * superblock and block group descriptor blocks from the block group
+ * which is no longer the last block group.
+ */
+static errcode_t clear_sparse_super2_last_group(ext2_resize_t rfs)
+{
+	ext2_filsys	fs = rfs->new_fs;
+	ext2_filsys	old_fs = rfs->old_fs;
+	errcode_t	retval;
+	dgrp_t		old_last_bg = rfs->old_fs->group_desc_count - 1;
+	dgrp_t		last_bg = fs->group_desc_count - 1;
+	blk64_t		sb, old_desc;
+	blk_t		num;
+
+	if (!(fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2))
+		return 0;
+
+	if (last_bg <= old_last_bg)
+		return 0;
+
+	if (fs->super->s_backup_bgs[0] == old_fs->super->s_backup_bgs[0] &&
+	    fs->super->s_backup_bgs[1] == old_fs->super->s_backup_bgs[1])
+		return 0;
+
+	if (old_fs->super->s_backup_bgs[0] != old_last_bg &&
+	    old_fs->super->s_backup_bgs[1] != old_last_bg)
+		return 0;
+
+	if (fs->super->s_backup_bgs[0] == old_last_bg ||
+	    fs->super->s_backup_bgs[1] == old_last_bg)
+		return 0;
+
+	retval = ext2fs_super_and_bgd_loc2(rfs->old_fs, old_last_bg,
+					   &sb, &old_desc, NULL, &num);
+	if (retval)
+		return retval;
+
+	if (sb)
+		ext2fs_unmark_block_bitmap2(fs->block_map, sb);
+	if (old_desc)
+		ext2fs_unmark_block_bitmap_range2(fs->block_map, old_desc, num);
+	return 0;
+}
+
+/*
+ * This function is used when shrinking a file system.  We need to
+ * utilize blocks from what will be the new last block group for the
+ * backup superblock and block group descriptor blocks.
+ * Unfortunately, those blocks may be used by other files or fs
+ * metadata blocks.  We need to mark them as being in use.
+ */
+static errcode_t reserve_sparse_super2_last_group(ext2_resize_t rfs,
+						 ext2fs_block_bitmap meta_bmap)
+{
+	ext2_filsys	fs = rfs->new_fs;
+	ext2_filsys	old_fs = rfs->old_fs;
+	errcode_t	retval;
+	dgrp_t		old_last_bg = rfs->old_fs->group_desc_count - 1;
+	dgrp_t		last_bg = fs->group_desc_count - 1;
+	dgrp_t		g;
+	blk64_t		blk, sb, old_desc;
+	blk_t		i, num;
+	int		realloc = 0;
+
+	if (!(fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2))
+		return 0;
+
+	if (last_bg >= old_last_bg)
+		return 0;
+
+	if (fs->super->s_backup_bgs[0] == old_fs->super->s_backup_bgs[0] &&
+	    fs->super->s_backup_bgs[1] == old_fs->super->s_backup_bgs[1])
+		return 0;
+
+	if (fs->super->s_backup_bgs[0] != last_bg &&
+	    fs->super->s_backup_bgs[1] != last_bg)
+		return 0;
+
+	if (old_fs->super->s_backup_bgs[0] == last_bg ||
+	    old_fs->super->s_backup_bgs[1] == last_bg)
+		return 0;
+
+	retval = ext2fs_super_and_bgd_loc2(rfs->new_fs, last_bg,
+					   &sb, &old_desc, NULL, &num);
+	if (retval)
+		return retval;
+
+	if (!sb) {
+		fputs(_("Should never happen!  No sb in last super_sparse bg?\n"),
+		      stderr);
+		exit(1);
+	}
+	if (old_desc != sb+1) {
+		fputs(_("Should never happen!  Unexpected old_desc in "
+			"super_sparse bg?\n"),
+		      stderr);
+		exit(1);
+	}
+	num = (old_desc) ? num : 1;
+
+	/* Reserve the backup blocks */
+	ext2fs_mark_block_bitmap_range2(fs->block_map, sb, num);
+
+	for (g = 0; g < fs->group_desc_count; g++) {
+		blk64_t mb;
+
+		mb = ext2fs_block_bitmap_loc(fs, g);
+		if ((mb >= sb) && (mb < sb + num)) {
+			ext2fs_block_bitmap_loc_set(fs, g, 0);
+			realloc = 1;
+		}
+		mb = ext2fs_inode_bitmap_loc(fs, g);
+		if ((mb >= sb) && (mb < sb + num)) {
+			ext2fs_inode_bitmap_loc_set(fs, g, 0);
+			realloc = 1;
+		}
+		mb = ext2fs_inode_table_loc(fs, g);
+		if ((mb < sb + num) &&
+		    (sb < mb + fs->inode_blocks_per_group)) {
+			ext2fs_inode_table_loc_set(fs, g, 0);
+			realloc = 1;
+		}
+		if (realloc) {
+			retval = ext2fs_allocate_group_table(fs, g, 0);
+			if (retval)
+				return retval;
+		}
+	}
+
+	for (blk = sb, i = 0; i < num; blk++, i++) {
+		if (ext2fs_test_block_bitmap2(old_fs->block_map, blk) &&
+		    !ext2fs_test_block_bitmap2(meta_bmap, blk)) {
+			ext2fs_mark_block_bitmap2(rfs->move_blocks, blk);
+			rfs->needed_blocks++;
+		}
+		ext2fs_mark_block_bitmap2(rfs->reserve_blocks, blk);
+	}
+	return 0;
+}
+
+/*
  * Fix the resize inode
  */
 static errcode_t fix_resize_inode(ext2_filsys fs)
-- 
1.8.5.rc3.362.gdf10213

