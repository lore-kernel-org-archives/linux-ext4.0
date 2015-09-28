From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext2: don't mount filesystems with compat features we know
 only ext4 supports
Date: Mon, 28 Sep 2015 15:36:26 -0700
Message-ID: <20150928223626.GI10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48690 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbI1Wgd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Sep 2015 18:36:33 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext2 mount code never checks the compat features against the ones
it knows about.  This is correct behavior since compat features are
supposed to be rw-compatible with old drivers; however, for certain
configurations (journalled rootfs) we probably want the ext4 driver
to load, not ext2.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext2/ext2.h  |    6 +++++-
 fs/ext2/super.c |   13 ++++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

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
index 900e19c..4efb018 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -896,6 +896,16 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	 * previously didn't change the revision level when setting the flags,
 	 * so there is a chance incompat flags are set on a rev 0 filesystem.
 	 */
+#ifdef CONFIG_EXT4_FS
+	/* Journalled FS should mount with ext4 if it's available */
+	features = EXT2_HAS_COMPAT_FEATURE(sb, ~EXT2_FEATURE_COMPAT_SUPP);
+	if (features) {
+		ext2_msg(sb, KERN_ERR,	"error: won't mount because of "
+		       "unsupported optional features (%x); try ext4",
+			le32_to_cpu(features));
+		goto failed_mount;
+	}
+#endif
 	features = EXT2_HAS_INCOMPAT_FEATURE(sb, ~EXT2_FEATURE_INCOMPAT_SUPP);
 	if (features) {
 		ext2_msg(sb, KERN_ERR,	"error: couldn't mount because of "
