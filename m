From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 22/30] tune2fs: add inline_data feature in tune2fs
Date: Fri,  6 Dec 2013 17:58:09 +0800
Message-ID: <1386323897-2354-23-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60593 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab3LFJ4R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:56:17 -0500
Received: by mail-pd0-f182.google.com with SMTP id v10so751966pde.27
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:56:16 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit make us switch on/off inline_data feature in tune2fs.  Now
inline_data can be enabled without ext_attr.  Hence we don't check it.
As doing in mke2fs we need to check inode size when we want to enable
it.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/tune2fs.8.in |    3 ++
 misc/tune2fs.c    |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 55c6dd9..8d56cdd 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -531,6 +531,9 @@ Setting the filesystem feature is equivalent to using the
 .B \-j
 option.
 .TP
+.B inline_data
+Allow data to be stored in the inode and extended attribute area.
+.TP
 .B large_file
 Filesystem can contain files that are greater than 2GB.  (Modern kernels
 set this feature automatically when a file > 2GB is created.)
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 95c1886..d205df5 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -92,6 +92,7 @@ static unsigned long new_inode_size;
 static char *ext_mount_opts;
 static int usrquota, grpquota;
 static int rewrite_checksums;
+static int disable_inline_data;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -140,7 +141,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_INLINE_DATA,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -162,7 +164,8 @@ static __u32 clear_ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_INLINE_DATA,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -745,6 +748,68 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 	ext2fs_mark_super_dirty(fs);
 }
 
+/*
+ * Allocate a block for all inodes with inline data.
+ */
+static void expand_inodes(ext2_filsys fs)
+{
+	int inode_size = EXT2_INODE_SIZE(fs->super);
+	struct ext2_inode *inode;
+	ext2_inode_scan scan;
+	errcode_t retval;
+	ext2_ino_t ino;
+
+	retval = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (retval) {
+		com_err("expand_inline_data", retval,
+			"while opening inode scan");
+		exit(1);
+	}
+
+	retval = ext2fs_get_mem(inode_size, &inode);
+	if (retval) {
+		com_err("expand_inline_data", retval,
+			"while allocating memory");
+		exit(1);
+	}
+
+	do {
+		retval = ext2fs_get_next_inode_full(scan, &ino, inode,
+						    inode_size);
+		if (retval) {
+			com_err("expand_inline_data", retval,
+				"while getting next inode");
+			exit(1);
+		}
+		if (!ino)
+			break;
+		if (!ext2fs_test_inode_bitmap2(fs->inode_map, ino))
+			continue;
+		if (!(inode->i_flags & EXT4_INLINE_DATA_FL))
+			continue;
+		retval = ext2fs_inline_data_expand(fs, ino);
+		if (retval) {
+			com_err("expand_inline_data", retval,
+				"while expanding inode %lu", ino);
+			exit(1);
+		}
+	} while (ino);
+
+	ext2fs_free_mem(&inode);
+	ext2fs_close_inode_scan(scan);
+}
+
+static void expand_inline_data(ext2_filsys fs)
+{
+	ext2fs_read_bitmaps(fs);
+	expand_inodes(fs);
+	ext2fs_mark_ib_dirty(fs);
+	ext2fs_mark_bb_dirty(fs);
+	ext2fs_mmp_update2(fs, 1);
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+	ext2fs_mark_super_dirty(fs);
+}
+
 static void enable_uninit_bg(ext2_filsys fs)
 {
 	struct ext2_group_desc *gd;
@@ -1083,6 +1148,31 @@ mmp_error:
 		disable_uninit_bg(fs,
 				EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 
+	if (FEATURE_ON(E2P_FEATURE_INCOMPAT,
+		       EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+		/*
+		 * Check inode size.  If inode size is 128, tell user that
+		 * inline data is useless.
+		 */
+		if (EXT2_INODE_SIZE(fs->super) == EXT2_GOOD_OLD_INODE_SIZE) {
+			fputs(_("The inode size is too small to "
+				"store inline data.\n"), stderr);
+			return 1;
+		}
+	}
+
+	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT,
+			EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+		if (mount_flags & EXT2_MF_MOUNTED) {
+			fputs(_("The inline data feature can't be clear if "
+				"the filesystem is mounted\n"), stderr);
+			return 1;
+		}
+		if (check_fsck_needed(fs))
+			return 1;
+		disable_inline_data = 1;
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
 		/*
@@ -2708,6 +2798,8 @@ retry_open:
 	}
 	if (rewrite_checksums)
 		rewrite_metadata_checksums(fs);
+	if (disable_inline_data)
+		expand_inline_data(fs);
 	if (I_flag) {
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The inode size may only be "
-- 
1.7.9.7

