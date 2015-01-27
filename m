From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: support read-only images
Date: Mon, 26 Jan 2015 23:45:51 -0800
Message-ID: <20150127074551.GD9976@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38462 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbbA0Hp4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:45:56 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a rocompat feature, "readonly" to mark a FS image as read-only.
The feature prevents the kernel and e2fsprogs from changing the image;
the flag can be toggled by tune2fs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3950a2f..5cf937d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1557,6 +1557,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
  * GDT_CSUM bits are mutually exclusive.
  */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
+#define EXT4_FEATURE_RO_COMPAT_READONLY		0x1000
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 74c5f53..c65dede 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2776,6 +2776,12 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 	if (readonly)
 		return 1;
 
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_READONLY)) {
+		ext4_msg(sb, KERN_INFO, "filesystem is read-only");
+		sb->s_flags |= MS_RDONLY;
+		return 1;
+	}
+
 	/* Check that feature set is OK for a read-write mount */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT4_FEATURE_RO_COMPAT_SUPP)) {
 		ext4_msg(sb, KERN_ERR, "couldn't mount RDWR because of "
@@ -4930,7 +4936,9 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 				ext4_mark_recovery_complete(sb, es);
 		} else {
 			/* Make sure we can mount this feature set readwrite */
-			if (!ext4_feature_set_ok(sb, 0)) {
+			if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_RO_COMPAT_READONLY) ||
+			    !ext4_feature_set_ok(sb, 0)) {
 				err = -EROFS;
 				goto restore_opts;
 			}
