From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/5] tune2fs: Add support for orphan_file feature
Date: Tue, 26 May 2015 09:51:08 +0200
Message-ID: <1432626669-6643-5-git-send-email-jack@suse.cz>
References: <1432626669-6643-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbbEZHvS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 May 2015 03:51:18 -0400
In-Reply-To: <1432626669-6643-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 misc/tune2fs.8.in |  5 ++++
 misc/tune2fs.c    | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 9d1df8242baa..c2355da5a7aa 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -232,6 +232,11 @@ program.
 This superblock setting is only honored in 2.6.35+ kernels;
 and not at all by the ext2 and ext3 file system drivers.
 .TP
+.BI orphan_file_size= size
+Set size of the file for tracking unlinked but still open inodes and inodes
+with truncate in progress. Larger file allows for better scalability, reserving
+a few blocks per cpu is ideal.
+.TP
 .B test_fs
 Set a flag in the filesystem superblock indicating that it may be
 mounted using experimental kernel code, such as the ext4dev filesystem.
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index f930df2f6683..9d15fa70e1a5 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -103,6 +103,7 @@ static int fsck_requested;
 int journal_size, journal_flags;
 char *journal_device;
 static blk64_t journal_location = ~0LL;
+static e2_blkcnt_t orphan_file_blocks;
 
 static struct list_head blk_move_list;
 
@@ -143,7 +144,8 @@ static void usage(void)
 static __u32 ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
-		EXT2_FEATURE_COMPAT_DIR_INDEX,
+		EXT2_FEATURE_COMPAT_DIR_INDEX |
+		EXT4_FEATURE_COMPAT_ORPHAN_FILE,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
@@ -169,7 +171,8 @@ static __u32 clear_ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
-		EXT2_FEATURE_COMPAT_DIR_INDEX,
+		EXT2_FEATURE_COMPAT_DIR_INDEX |
+		EXT4_FEATURE_COMPAT_ORPHAN_FILE,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
@@ -1025,6 +1028,50 @@ static int update_feature_set(ext2_filsys fs, char *features)
 		}
 	}
 
+	if (FEATURE_OFF(E2P_FEATURE_COMPAT, EXT4_FEATURE_COMPAT_ORPHAN_FILE)) {
+		if (mount_flags & EXT2_MF_MOUNTED) {
+			fputs(_("The orphan_file feature may only be cleared "
+				"when the filesystem is unmounted.\n"), stderr);
+			return 1;
+		}
+		if ((sb->s_feature_ro_compat &
+				EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT) &&
+		    f_flag < 2) {
+			fputs(_("The orphan_present flag is set. Please run "
+				"e2fsck before clearing orphan_file flag.\n"),
+			      stderr);
+			return 1;
+		}
+		err = ext2fs_read_bitmaps(fs);
+		if (err) {
+			com_err(program_name, err, "%s",
+				_("while loading bitmaps"));
+			return 1;
+		}
+		err = ext2fs_truncate_orphan_file(fs);
+		if (err) {
+			com_err(program_name, err,
+				_("\n\twhile trying to truncate orphan file\n"));
+			return 1;
+		}
+	}
+
+	if (FEATURE_ON(E2P_FEATURE_COMPAT, EXT4_FEATURE_COMPAT_ORPHAN_FILE)) {
+		if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
+			fputs(_("orphan_file flag can be set only for "
+				"filesystems with journal.\n"), stderr);
+			return 1;
+		}
+		/*
+		 * If adding an orphan file, let the create orphan file
+		 * code below handle setting the flag and creating it.
+		 * We supply a default size if necessary.
+		 */
+		orphan_file_blocks = ext2fs_default_orphan_file_blocks(
+						ext2fs_blocks_count(fs->super));
+		sb->s_feature_compat &= ~EXT4_FEATURE_COMPAT_ORPHAN_FILE;
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
 		if (sb->s_feature_incompat &
@@ -1970,6 +2017,21 @@ static int parse_extended_opts(ext2_filsys fs, const char *opts)
 				continue;
 			}
 			ext_mount_opts = strdup(arg);
+		} else if (!strcmp(token, "orphan_file_size")) {
+			if (!arg) {
+				r_usage++;
+				continue;
+			}
+			orphan_file_blocks = parse_num_blocks2(arg,
+						 fs->super->s_log_block_size);
+
+			if (orphan_file_blocks < 1) {
+				fprintf(stderr,
+					_("Invalid size of orphan file %s\n"),
+					arg);
+				r_usage++;
+				continue;
+			}
 		} else
 			r_usage++;
 	}
@@ -2921,6 +2983,24 @@ retry_open:
 		if (rc)
 			goto closefs;
 	}
+	if (orphan_file_blocks) {
+		errcode_t err;
+
+		err = ext2fs_read_bitmaps(fs);
+		if (err) {
+			com_err(program_name, err, "%s",
+				_("while loading bitmaps"));
+			rc = 1;
+			goto closefs;
+		}
+		err = ext2fs_create_orphan_file(fs, orphan_file_blocks);
+		if (err) {
+			com_err(program_name, err, "%s",
+				_("while creating orphan file"));
+			rc = 1;
+			goto closefs;
+		}
+	}
 
 	if (Q_flag) {
 		if (mount_flags & EXT2_MF_MOUNTED) {
-- 
2.1.4

