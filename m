From: Peng Tao <bergwolf@gmail.com>
Subject: [e2fsprogs][PATCH-v2] Allow tune2fs -I if only one group per flex
Date: Tue,  3 Mar 2009 11:04:13 +0800
Message-ID: <1236049453-8851-1-git-send-email-bergwolf@gmail.com>
Cc: linux-ext4@vger.kernel.org, Peng Tao <bergwolf@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:44837 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZCCDE0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Mar 2009 22:04:26 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2980047tib.23
        for <linux-ext4@vger.kernel.org>; Mon, 02 Mar 2009 19:04:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This can be caused by tune2fs -O flex_bg.
And tune2fs -I should work okay if bitmaps and inode tables are still within
the group.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 lib/ext2fs/check_desc.c |   12 +++++++++---
 lib/ext2fs/ext2fs.h     |    1 +
 misc/tune2fs.c          |    3 ++-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index 299cb01..496c634 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -26,10 +26,17 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
+errcode_t ext2fs_check_desc(ext2_filsys fs)
+{
+	return ext2fs_check_desc_sanity(fs,
+			!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_INCOMPAT_FLEX_BG));
+}
+
 /*
  * This routine sanity checks the group descriptors
  */
-errcode_t ext2fs_check_desc(ext2_filsys fs)
+errcode_t ext2fs_check_desc_sanity(ext2_filsys fs, int within_group)
 {
 	ext2fs_block_bitmap bmap;
 	errcode_t retval;
@@ -49,8 +56,7 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 		ext2fs_reserve_super_and_bgd(fs, i, bmap);
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		if (within_group) {
 			first_block = ext2fs_group_first_block(fs, i);
 			last_block = ext2fs_group_last_block(fs, i);
 			if (i == (fs->group_desc_count - 1))
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d5026bc..29fb129 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -724,6 +724,7 @@ extern errcode_t ext2fs_move_blocks(ext2_filsys fs,
 
 /* check_desc.c */
 extern errcode_t ext2fs_check_desc(ext2_filsys fs);
+extern errcode_t ext2fs_check_desc_sanity(ext2_filsys fs, int within_group);
 
 /* closefs.c */
 extern errcode_t ext2fs_close(ext2_filsys fs);
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 887a702..f6b4fb2 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1715,7 +1715,8 @@ retry_open:
 			exit(1);
 		}
 		if (fs->super->s_feature_incompat &
-		    EXT4_FEATURE_INCOMPAT_FLEX_BG) {
+		    EXT4_FEATURE_INCOMPAT_FLEX_BG &&
+		    ext2fs_check_desc_sanity(fs, 1)) {
 			fputs(_("Changing the inode size not supported for "
 				"filesystems with the flex_bg\n"
 				"feature enabled.\n"),
-- 
1.6.1.3

