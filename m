From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] resize2fs: support online-resizing for meta_bg and 64bits features
Date: Sun,  2 Sep 2012 17:52:29 +0800
Message-ID: <1346579549-25122-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41850 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab2IBK1u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Sep 2012 06:27:50 -0400
Received: by dady13 with SMTP id y13so3015660dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 02 Sep 2012 03:27:50 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch supports online-resizing for meata_bg and 64bits features.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 resize/main.c   |    5 +++--
 resize/online.c |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index ffefe01..b3a7840 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -324,9 +324,10 @@ int main (int argc, char ** argv)
 	 * This is something we should fix eventually, though.
 	 */
 	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
-	    !(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE)) {
+	    !(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
+	    !(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)) {
 		com_err(program_name, 0, _("%s: The combination of flex_bg "
-					   "and\n\t!resize_inode features "
+					   "and\n\t!resize_inode and !meta_bg features "
 					   "is not supported by resize2fs.\n"),
 			device_name);
 		exit(1);
diff --git a/resize/online.c b/resize/online.c
index 966ea1e..e7891bd 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -56,9 +56,9 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		EXT2_DESC_PER_BLOCK(fs->super));
 	printf("old_desc_blocks = %lu, new_desc_blocks = %lu\n",
 	       fs->desc_blocks, new_desc_blocks);
-	if (!(fs->super->s_feature_compat &
-	      EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
-	    new_desc_blocks != fs->desc_blocks) {
+	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
+	    new_desc_blocks != fs->desc_blocks &&
+	    !(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)) {
 		com_err(program_name, 0,
 			_("Filesystem does not support online resizing"));
 		exit(1);
-- 
1.7.5.1

