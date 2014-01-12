From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH RFC] Add support for new compat feature "one_backup_sb"
Date: Sat, 11 Jan 2014 22:23:49 -0500
Message-ID: <1389497029-10488-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47639 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaALDXy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jan 2014 22:23:54 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In practice, it is **extremely** rare for users to try to use more
than the first backup superblock located at the beginning of block
group #1.  (i.e., at block number 32768 for file systems with a 4k
block size).

Aside from reducing the overhead of the file system by a small number
of blocks, by eliminating the rest of the backup superblocks, it
allows us to have a much more flexible metadata layout.  For example,
we can force all of the allocation bitmaps and inode table blocks to
the beginning of the disk, which allows most of the disk to be
exclusively used for contiguous data blocks.

This simplifies taking advantage of certain HDD specific features,
such as Shingled Magnetic Recording (aka Shingled Drives), and the
TCG's OPAL Storage Specification where having a simple mapping between
LBA block ranges and data blocks used by the file system can make life
much simpler.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/e2p/feature.c    | 2 ++
 lib/ext2fs/closefs.c | 3 +++
 lib/ext2fs/ext2_fs.h | 1 +
 lib/ext2fs/ext2fs.h  | 3 ++-
 lib/ext2fs/res_gdt.c | 8 +++++++-
 misc/ext4.5.in       | 7 +++++++
 misc/mke2fs.c        | 3 ++-
 resize/online.c      | 8 ++++++++
 8 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 9691263..8f4d8e7 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -43,6 +43,8 @@ static struct feature feature_list[] = {
 			"lazy_bg" },
 	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP,
 			"snapshot_bitmap" },
+	{	E2P_FEATURE_COMPAT, EXT4_FEATURE_COMPAT_ONE_BACKUP_SB,
+			"one_backup_sb" },
 
 	{	E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER,
 			"sparse_super" },
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 3e4af7f..c806291 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -38,6 +38,9 @@ int ext2fs_bg_has_super(ext2_filsys fs, dgrp_t group)
 	if (!(fs->super->s_feature_ro_compat &
 	      EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER) || group <= 1)
 		return 1;
+	if (fs->super->s_feature_compat &
+	    EXT4_FEATURE_COMPAT_ONE_BACKUP_SB)
+		return 0;
 	if (!(group & 1))
 		return 0;
 	if (test_root(group, 3) || (test_root(group, 5)) ||
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 930c2a3..65c40c0 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -696,6 +696,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_COMPAT_LAZY_BG		0x0040
 /* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE	0x0080 not used, legacy */
 #define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP	0x0100
+#define EXT4_FEATURE_COMPAT_ONE_BACKUP_SB	0x0200
 
 
 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 367b8de..8ff5a7e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -550,7 +550,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_COMPAT_HAS_JOURNAL|\
 					 EXT2_FEATURE_COMPAT_RESIZE_INODE|\
 					 EXT2_FEATURE_COMPAT_DIR_INDEX|\
-					 EXT2_FEATURE_COMPAT_EXT_ATTR)
+					 EXT2_FEATURE_COMPAT_EXT_ATTR|\
+					 EXT4_FEATURE_COMPAT_ONE_BACKUP_SB)
 
 /* This #ifdef is temporary until compression is fully supported */
 #ifdef ENABLE_COMPRESSION
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index 6449228..5fb0195 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -37,7 +37,13 @@ static unsigned int list_backups(ext2_filsys fs, unsigned int *three,
 		*min += 1;
 		return ret;
 	}
-
+	if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_ONE_BACKUP_SB) {
+		if (*min == 1) {
+			*min += 1;
+			return 1;
+		}
+		return fs->group_desc_count;
+	}
 	if (*five < *min) {
 		min = five;
 		mult = 5;
diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index fab1139..9005b86 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -171,6 +171,13 @@ kernels from mounting file systems that they could not understand.
 .\" .br
 .\" .B Future feature, available in e2fsprogs 1.43-WIP
 .TP
+.B one_backup_sb
+.br
+This feature indicates that there will only be a single backup
+superblock and block group descriptor located at the beginning of the
+second block group (i.e., block group #1).  This is an more extreme
+version of sparse_super.
+.TP
 .B meta_bg
 .br
 This ext4 feature allows file systems to be resized on-line without explicitly
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index c45b42f..cec473e 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -924,7 +924,8 @@ static __u32 ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX |
-		EXT2_FEATURE_COMPAT_EXT_ATTR,
+		EXT2_FEATURE_COMPAT_EXT_ATTR |
+		EXT4_FEATURE_COMPAT_ONE_BACKUP_SB,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE|
 		EXT3_FEATURE_INCOMPAT_EXTENTS|
diff --git a/resize/online.c b/resize/online.c
index defcac1..ab126e7 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -76,6 +76,14 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 			no_resize_ioctl = 1;
 	}
 
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+				    EXT4_FEATURE_COMPAT_ONE_BACKUP_SB) &&
+	    (access("/sys/fs/ext4/features/one_backup_sb", R_OK) != 0)) {
+		com_err(program_name, 0, _("kernel does not support online "
+					   "resize with one_backup_sb"));
+		exit(1);
+	}
+
 	printf(_("Filesystem at %s is mounted on %s; "
 		 "on-line resizing required\n"), fs->device_name, mtpt);
 
-- 
1.8.5.rc3.362.gdf10213

