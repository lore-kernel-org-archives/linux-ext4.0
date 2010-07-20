From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 01/12] e2fsprogs: Next3 on-disk format changes
Date: Tue, 20 Jul 2010 18:16:02 +0300
Message-ID: <1279638973-14561-2-git-send-email-amir73il@users.sf.net>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu, andreas.dilger@oracle.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42770 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab0GTPRV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:17:21 -0400
Received: by wwj40 with SMTP id 40so968910wwj.1
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:17:20 -0700 (PDT)
In-Reply-To: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Next3 uses a few reserved fields and flags in the Ext2 super block,
and inode structs.
Next3 defines the compatible feature 'exclude_inode', meaning that
the special exclude inode was allocated.
Next3 defines the read-only compatible features 'has_snapshot', meaning
that the file system contains snapshots.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 lib/e2p/feature.c    |    4 ++++
 lib/e2p/ls.c         |   12 ++++++++++++
 lib/ext2fs/ext2_fs.h |    3 ++-
 lib/ext2fs/ext2fs.h  |    2 ++
 4 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index c7f8a35..b9dd7bd 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -40,6 +40,8 @@ static struct feature feature_list[] = {
 			"resize_inode" },
 	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_LAZY_BG,
 			"lazy_bg" },
+	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_EXCLUDE_INODE,
+			"exclude_inode" },
 
 	{	E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER,
 			"sparse_super" },
@@ -55,6 +57,8 @@ static struct feature feature_list[] = {
 			"dir_nlink" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE,
 			"extra_isize" },
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT,
+			"has_snapshot" },
 
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 6964519..fe12faa 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -160,6 +160,18 @@ static void print_super_flags(struct ext2_super_block * s, FILE *f)
 		fputs("test_filesystem ", f);
 		flags_found++;
 	}
+	if (s->s_flags & EXT2_FLAGS_IS_SNAPSHOT) {
+		fputs("is_snapshot ", f);
+		flags_found++;
+	}
+	if (s->s_flags & EXT2_FLAGS_FIX_SNAPSHOT) {
+		fputs("fix_snapshot ", f);
+		flags_found++;
+	}
+	if (s->s_flags & EXT2_FLAGS_FIX_EXCLUDE) {
+		fputs("fix_exclude ", f);
+		flags_found++;
+	}
 	if (flags_found)
 		fputs("\n", f);
 	else
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index fa256e5..3a65515 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -431,7 +431,7 @@ struct ext2_inode_large {
 #define i_dir_acl	i_size_high
 
 #if defined(__KERNEL__) || defined(__linux__)
-#define i_reserved1	osd1.linux1.l_i_reserved1
+#define i_next_snapshot	osd1.linux1.l_i_version
 #define i_frag		osd2.linux2.l_i_frag
 #define i_fsize		osd2.linux2.l_i_fsize
 #define i_uid_low	i_uid
@@ -692,6 +692,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT|\
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index e2c3b09..f0645c3 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -517,6 +517,7 @@ typedef struct ext2_icount *ext2_icount_t;
 #define EXT2_LIB_FEATURE_COMPAT_SUPP	(EXT2_FEATURE_COMPAT_DIR_PREALLOC|\
 					 EXT2_FEATURE_COMPAT_IMAGIC_INODES|\
 					 EXT3_FEATURE_COMPAT_HAS_JOURNAL|\
+					 EXT2_FEATURE_COMPAT_EXCLUDE_INODE|\
 					 EXT2_FEATURE_COMPAT_RESIZE_INODE|\
 					 EXT2_FEATURE_COMPAT_DIR_INDEX|\
 					 EXT2_FEATURE_COMPAT_EXT_ATTR)
@@ -549,6 +550,7 @@ typedef struct ext2_icount *ext2_icount_t;
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT|\
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
-- 
1.6.6

