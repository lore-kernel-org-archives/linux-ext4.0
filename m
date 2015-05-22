From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] mke2fs: Add support for orphan_file feature
Date: Fri, 22 May 2015 13:28:55 +0200
Message-ID: <1432294137-26078-3-git-send-email-jack@suse.cz>
References: <1432294137-26078-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161009AbbEVL3C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2015 07:29:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CBA5EAD5C
	for <linux-ext4@vger.kernel.org>; Fri, 22 May 2015 11:29:00 +0000 (UTC)
In-Reply-To: <1432294137-26078-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 misc/mke2fs.8.in |  5 +++++
 misc/mke2fs.c    | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index aeb5caf6e869..173e19979bb2 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -359,6 +359,11 @@ filesystem to change based on the user running \fBmke2fs\fR.
 Set a flag in the filesystem superblock indicating that it may be
 mounted using experimental kernel code, such as the ext4dev filesystem.
 .TP
+.BI orphan_file_size= size
+Set size of the file for tracking unlinked but still open inodes and inodes
+with truncate in progress. Larger file allows for better scalability, reserving
+a few blocks per cpu is ideal.
+.TP
 .BI discard
 Attempt to discard blocks at mkfs time (discarding blocks initially is useful
 on solid state devices and sparse / thin-provisioned storage). When the device
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 6883103e33c6..380a719e5739 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -91,6 +91,7 @@ static uid_t	root_uid;
 static gid_t	root_gid;
 int	journal_size;
 int	journal_flags;
+static __u64	orphan_file_size;
 static int	lazy_itable_init;
 static int	packed_meta_blocks;
 static char	*bad_blocks_filename = NULL;
@@ -1022,6 +1023,28 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				r_usage++;
 				continue;
 			}
+		} else if (!strcmp(token, "orphan_file_size")) {
+			if (!arg) {
+				r_usage++;
+				badopt = token;
+				continue;
+			}
+			orphan_file_size = strtoul(arg, &p, 0);
+			if (*p) {
+				fprintf(stderr,
+					_("Invalid size of orphan file %s\n"),
+					arg);
+				r_usage++;
+				continue;
+			}
+			if (orphan_file_size < EXT4_MIN_ORPHAN_FILE_SIZE) {
+				fprintf(stderr,
+					_("Orphan file is too small. Minimum "
+					  "size is %u\n"),
+					EXT4_MIN_ORPHAN_FILE_SIZE);
+				r_usage++;
+				continue;
+			}
 		} else {
 			r_usage++;
 			badopt = token;
@@ -1067,7 +1090,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX |
 		EXT2_FEATURE_COMPAT_EXT_ATTR |
-		EXT4_FEATURE_COMPAT_SPARSE_SUPER2,
+		EXT4_FEATURE_COMPAT_SPARSE_SUPER2 |
+		EXT4_FEATURE_COMPAT_ORPHAN_FILE,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE|
 		EXT3_FEATURE_INCOMPAT_EXTENTS|
@@ -3109,6 +3133,36 @@ no_journal:
 	if (EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
 				       EXT4_FEATURE_RO_COMPAT_QUOTA))
 		create_quota_inodes(fs);
+	if (EXT2_HAS_COMPAT_FEATURE(&fs_param,
+				    EXT4_FEATURE_COMPAT_ORPHAN_FILE)) {
+		e2_blkcnt_t orphan_file_blocks;
+
+		if (fs->super->s_first_ino <= EXT4_ORPHAN_INO) {
+			com_err(program_name, 0, _("inode %d has to be "
+				"reserved for orphan file feature"),
+				EXT4_ORPHAN_INO);
+			exit(1);
+		}
+		if (!EXT2_HAS_COMPAT_FEATURE(&fs_param,
+					     EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
+			com_err(program_name, 0, _("cannot set orphan_file "
+				"flag without a journal."));
+			exit(1);
+		}
+		if (orphan_file_size) {
+			orphan_file_blocks = (orphan_file_size +
+					fs->blocksize - 1) / fs->blocksize;
+		} else {
+			orphan_file_blocks = ext2fs_default_orphan_file_blocks(
+						ext2fs_blocks_count(fs->super));
+		}
+		retval = ext2fs_create_orphan_file(fs, orphan_file_blocks);
+		if (retval) {
+			com_err(program_name, retval,
+				_("while creating orphan file"));
+			exit(1);
+		}
+	}
 
 	retval = mk_hugefiles(fs, device_name);
 	if (retval)
-- 
2.1.4

