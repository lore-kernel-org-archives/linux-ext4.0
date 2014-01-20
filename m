From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 12/12] mke2fs: allow metadata blocks to be at the beginning of the file system
Date: Mon, 20 Jan 2014 00:54:14 -0500
Message-ID: <1390197254-14583-13-git-send-email-tytso@mit.edu>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49956 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaATFyZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 00:54:25 -0500
In-Reply-To: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add the extended options packed_meta_blocks and journal_location_front
which causes mke2fs to place the metadata blocks at the beginning of
the file system.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/ext2fs.h    |  1 +
 lib/ext2fs/mkjournal.c |  5 +++-
 misc/mke2fs.8.in       | 14 +++++++++++
 misc/mke2fs.c          | 65 +++++++++++++++++++++++++++++++++++++++++++++++++-
 misc/mke2fs.conf.5.in  |  4 ++++
 5 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index efe0964..fed6410 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -204,6 +204,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_MKJOURNAL_V1_SUPER	0x0000001 /* create V1 superblock (deprecated) */
 #define EXT2_MKJOURNAL_LAZYINIT	0x0000002 /* don't zero journal inode before use*/
 #define EXT2_MKJOURNAL_NO_MNT_CHECK 0x0000004 /* don't check mount status */
+#define EXT2_MKJOURNAL_LOCATION_FRONT 0x0000004 /* journal at the beginning */
 
 struct opaque_ext2_group_desc;
 
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index d09c458..aa6d9af 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -360,7 +360,10 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 		    ext2fs_bg_free_blocks_count(fs, group))
 			group = i;
 
-	es.goal = ext2fs_group_first_block2(fs, group);
+	if (flags & EXT2_MKJOURNAL_LOCATION_FRONT)
+		es.goal = 0;
+	else
+		es.goal = ext2fs_group_first_block2(fs, group);
 	retval = ext2fs_block_iterate3(fs, journal_ino, BLOCK_FLAG_APPEND,
 				       0, mkjournal_proc, &es);
 	if (es.err) {
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 483fb1c..9f8c9f6 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -280,6 +280,20 @@ If the
 file system feature is enabled this option controls whether there will
 be 0, 1, or 2 backup superblocks created in the file system.
 .TP
+.B packed_meta_blocks\fR[\fB= \fI<0 to disable, 1 to enable>\fR]
+Place the allocation bitmaps and the inode table at the beginning of the
+disk.  This option requires that the flex_bg file system feature to be
+enabled in order for it to have effect, and also implies the
+extended option
+.IR journal_location_front .
+This option is useful for flash devices that use SLC flash at the beginning of
+the disk.   It also maximizes the range of contiguous data blocks, which
+can be useful for certain specialized use cases, such as supported
+Shingled Drives.
+.TP
+.B journal_location_front\fR[\fB= \fI<0 to disable, 1 to enable>\fR]
+Place the journal at the beginning of the file system.
+.TP
 .BI root_owner [=uid:gid]
 Specify the numeric user and group ID of the root directory.  If no UID:GID
 is specified, use the user and group ID of the user running \fBmke2fs\fR.
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index efb068a..363e96b 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -94,6 +94,7 @@ static gid_t	root_gid;
 int	journal_size;
 int	journal_flags;
 static int	lazy_itable_init;
+static int	packed_meta_blocks;
 static char	*bad_blocks_filename = NULL;
 static __u32	fs_stride;
 static int	quotatype = -1;  /* Initialize both user and group quotas by default */
@@ -310,6 +311,40 @@ _("Warning: the backup superblock/group descriptors at block %u contain\n"
 	ext2fs_badblocks_list_iterate_end(bb_iter);
 }
 
+static errcode_t packed_allocate_tables(ext2_filsys fs)
+{
+	errcode_t	retval;
+	dgrp_t		i;
+	blk64_t		goal = 0;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		retval = ext2fs_new_block2(fs, goal, NULL, &goal);
+		if (retval)
+			return retval;
+		ext2fs_block_alloc_stats2(fs, goal, +1);
+		ext2fs_block_bitmap_loc_set(fs, i, goal);
+	}
+	for (i = 0; i < fs->group_desc_count; i++) {
+		retval = ext2fs_new_block2(fs, goal, NULL, &goal);
+		if (retval)
+			return retval;
+		ext2fs_block_alloc_stats2(fs, goal, +1);
+		ext2fs_inode_bitmap_loc_set(fs, i, goal);
+	}
+	for (i = 0; i < fs->group_desc_count; i++) {
+		blk64_t end = ext2fs_blocks_count(fs->super) - 1;
+		retval = ext2fs_get_free_blocks2(fs, goal, end,
+						 fs->inode_blocks_per_group,
+						 fs->block_map, &goal);
+		if (retval)
+			return retval;
+		ext2fs_block_alloc_stats_range(fs, goal,
+					       fs->inode_blocks_per_group, +1);
+		ext2fs_inode_table_loc_set(fs, i, goal);
+	}
+	return 0;
+}
+
 static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 {
 	errcode_t	retval;
@@ -712,6 +747,14 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				continue;
 			}
 			param->s_desc_size = desc_size;
+		} else if (strcmp(token, "journal_location_front") == 0) {
+			unsigned long front = 1;
+			if (arg)
+				front = strtoul(arg, &p, 0);
+			if (front)
+				journal_flags |= EXT2_MKJOURNAL_LOCATION_FRONT;
+			else
+				journal_flags &= ~EXT2_MKJOURNAL_LOCATION_FRONT;
 		} else if (strcmp(token, "offset") == 0) {
 			if (!arg) {
 				r_usage++;
@@ -754,6 +797,15 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				r_usage++;
 				continue;
 			}
+		} else if (strcmp(token, "packed_meta_blocks") == 0) {
+			if (arg)
+				packed_meta_blocks = strtoul(arg, &p, 0);
+			else
+				packed_meta_blocks = 1;
+			if (packed_meta_blocks)
+				journal_flags |= EXT2_MKJOURNAL_LOCATION_FRONT;
+			else
+				journal_flags &= ~EXT2_MKJOURNAL_LOCATION_FRONT;
 		} else if (strcmp(token, "stride") == 0) {
 			if (!arg) {
 				r_usage++;
@@ -915,8 +967,10 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\tstripe-width=<RAID stride * data disks in blocks>\n"
 			"\toffset=<offset to create the file system>\n"
 			"\tresize=<resize maximum size in blocks>\n"
+			"\tpacked_meta_blocks=<0 to disable, 1 to enable>\n"
 			"\tlazy_itable_init=<0 to disable, 1 to enable>\n"
 			"\tlazy_journal_init=<0 to disable, 1 to enable>\n"
+			"\tjournal_location_front=<0 to disable, 1 to enable>\n"
 			"\troot_uid=<uid of root directory>\n"
 			"\troot_gid=<gid of root directory>\n"
 			"\ttest_fs\n"
@@ -2030,6 +2084,11 @@ profile_error:
 					       EXT2_MKJOURNAL_LAZYINIT : 0;
 	journal_flags |= EXT2_MKJOURNAL_NO_MNT_CHECK;
 
+	packed_meta_blocks = get_bool_from_profile(fs_types,
+						   "packed_meta_blocks", 0);
+	if (packed_meta_blocks)
+		journal_flags |= EXT2_MKJOURNAL_LOCATION_FRONT;
+
 	/* Get options from profile */
 	for (cpp = fs_types; *cpp; cpp++) {
 		tmp = NULL;
@@ -2624,7 +2683,11 @@ int main (int argc, char *argv[])
 	fs->stride = fs_stride = fs->super->s_raid_stride;
 	if (!quiet)
 		printf("%s", _("Allocating group tables: "));
-	retval = ext2fs_allocate_tables(fs);
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	    packed_meta_blocks)
+		retval = packed_allocate_tables(fs);
+	else
+		retval = ext2fs_allocate_tables(fs);
 	if (retval) {
 		com_err(program_name, retval, "%s",
 			_("while trying to allocate filesystem tables"));
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index 43bb91e..1aba87b 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -362,6 +362,10 @@ This relation indicates whether file systems with the
 .B sparse_super2
 feature enabled should be created with 0, 1, or 2 backup superblocks.
 .TP
+.I packed_meta_blocks
+This boolean relation specifes whether the allocation bitmaps, inode
+table, and journal should be located at the beginning of the file system.
+.TP
 .I inode_ratio
 This relation specifies the default inode ratio if the user does not
 specify one on the command line.
-- 
1.8.5.rc3.362.gdf10213

