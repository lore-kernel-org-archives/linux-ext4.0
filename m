From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2] e2fsprogs: add 64bit-online-resize support
Date: Tue, 30 Aug 2011 16:13:23 +0800
Message-ID: <1314692003-12395-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53440 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1H3I4f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 04:56:35 -0400
Received: by pzk37 with SMTP id 37so9956602pzk.1
        for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 01:56:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds 64bit-resize support to e2fsprogs.
---
 v1->v2:
   remove useless warning message.
 lib/ext2fs/ext2_fs.h |    1 +
 resize/online.c      |   19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 54cb3d4..4fec5db 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -327,6 +327,7 @@ struct ext4_new_group_input {
 #define EXT2_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
 #define EXT2_IOC_GROUP_ADD		_IOW('f', 8,struct ext2_new_group_input)
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
+#define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
 
 /*
  * Structure of an inode on the disk
diff --git a/resize/online.c b/resize/online.c
index 1d8d4ec..1b3589b 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -51,7 +51,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 				  fs->super->s_first_data_block,
 				  EXT2_BLOCKS_PER_GROUP(fs->super)),
 		EXT2_DESC_PER_BLOCK(fs->super));
-	printf("old desc_blocks = %lu, new_desc_blocks = %lu\n",
+	printf("old_desc_blocks = %lu, new_desc_blocks = %lu\n",
 	       fs->desc_blocks, new_desc_blocks);
 	if (!(fs->super->s_feature_compat &
 	      EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
@@ -69,6 +69,23 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 	}
 
 	size=ext2fs_blocks_count(sb);
+
+	if (ioctl(fd, EXT4_IOC_RESIZE_FS, new_size)) {
+		if (errno != ENOTTY) {
+			if (errno == EPERM)
+				com_err(program_name, 0,
+				_("Permission denied to resize filesystem"));
+			else
+				com_err(program_name, errno,
+				_("While checking for on-line resizing "
+				  "support"));
+			exit(1);
+		}
+	} else {
+		close(fd);
+		return 0;
+	}
+
 	if (ioctl(fd, EXT2_IOC_GROUP_EXTEND, &size)) {
 		if (errno == EPERM)
 			com_err(program_name, 0,
-- 
1.7.5.1

