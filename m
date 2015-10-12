From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/8] ext2: only permit ro mounts with compat features we
 know we don't support
Date: Mon, 12 Oct 2015 14:54:37 -0700
Message-ID: <20151012215437.28872.14707.stgit@birch.djwong.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39116 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbbJLVyp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:54:45 -0400
In-Reply-To: <20151012215416.28872.8160.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext2 mount code never checks the compat features against the ones
it knows about.  This is correct behavior since compat features are
supposed to be rw-compatible with old drivers; however, for certain
configurations (journalled rootfs) the admin is unlikely to want
no-journal mode.  Since we changed the default probe order to put ext4
first, we can make ext2.ko only allow readonly mounts if has_journal is
found.

(Remember, this only affects mounting ext3 filesystems on ext2.ko.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext2/ext2.h  |    6 +++++-
 fs/ext2/super.c |   19 +++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)


diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 8d15feb..ce508b1 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -547,7 +547,11 @@ struct ext2_super_block {
 #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
 #define EXT2_FEATURE_INCOMPAT_ANY		0xffffffff
 
-#define EXT2_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
+#define EXT2_FEATURE_COMPAT_SUPP	(EXT2_FEATURE_COMPAT_DIR_PREALLOC| \
+					 EXT2_FEATURE_COMPAT_IMAGIC_INODES| \
+					 EXT2_FEATURE_COMPAT_EXT_ATTR| \
+					 EXT2_FEATURE_COMPAT_RESIZE_INO| \
+					 EXT2_FEATURE_COMPAT_DIR_INDEX)
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT2_FEATURE_INCOMPAT_META_BG)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 900e19c..40c312f 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -896,6 +896,14 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	 * previously didn't change the revision level when setting the flags,
 	 * so there is a chance incompat flags are set on a rev 0 filesystem.
 	 */
+#ifdef CONFIG_EXT4_FS
+	/* Journalled FS should mount with ext4 if it's available */
+	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
+		ext2_msg(sb, KERN_ERR,	"warning: journal detected; cowardly "
+			"refusing to mount read-write.  Try ext4.");
+		sb->s_flags |= MS_RDONLY;
+	}
+#endif
 	features = EXT2_HAS_INCOMPAT_FEATURE(sb, ~EXT2_FEATURE_INCOMPAT_SUPP);
 	if (features) {
 		ext2_msg(sb, KERN_ERR,	"error: couldn't mount because of "
@@ -1336,6 +1344,17 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 			err = -EROFS;
 			goto restore_opts;
 		}
+#ifdef CONFIG_EXT4_FS
+		/* Journalled FS should mount with ext4 if it's available */
+		if (EXT2_HAS_COMPAT_FEATURE(sb,
+					    EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
+			ext2_msg(sb, KERN_ERR,	"warning: journal detected; "
+				"cowardly refusing to remount read-write.  "
+				"Try ext4.");
+			err = -EROFS;
+			goto restore_opts;
+		}
+#endif
 		/*
 		 * Mounting a RDONLY partition read-write, so reread and
 		 * store the current valid flag.  (It may have been changed

