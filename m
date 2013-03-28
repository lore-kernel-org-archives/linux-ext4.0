From: Tao Ma <tm@tao.ma>
Subject: [PATCH 1/2] ext4: Return proper offset for '..' if inline_data enabled.
Date: Thu, 28 Mar 2013 18:34:58 +0800
Message-ID: <1364466899-5599-1-git-send-email-tm@tao.ma>
Cc: zab@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58665 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751730Ab3C1Kf1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Mar 2013 06:35:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Zach reported a problem that if inline data is enabled, we don't
tell the difference between the offset of '.' and '..'. And a
getdents will fail if the user only want to get '.'.

This patch adds a new offset EXT4_INLINE_DOTDOT_OFFSET which
indicates the offset of inline "..", and now 0 is for the "."
and EXT4_INLINE_DOTDOT_OFFSET is for "..".

Reported-by: Zach Brown <zab@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index c0fd1a1..9c09dd5 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -19,7 +19,8 @@
 
 #define EXT4_XATTR_SYSTEM_DATA	"data"
 #define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__le32) * EXT4_N_BLOCKS))
-#define EXT4_INLINE_DOTDOT_SIZE	4
+#define EXT4_INLINE_DOTDOT_SIZE		4
+#define EXT4_INLINE_DOTDOT_OFFSET	2
 
 int ext4_get_inline_size(struct inode *inode)
 {
@@ -1330,6 +1331,7 @@ int ext4_read_inline_dir(struct file *filp,
 	sb = inode->i_sb;
 	stored = 0;
 	parent_ino = le32_to_cpu(((struct ext4_dir_entry_2 *)dir_buf)->inode);
+	offset = filp->f_pos;
 
 	while (!error && !stored && filp->f_pos < inode->i_size) {
 revalidate:
@@ -1342,9 +1344,15 @@ revalidate:
 		if (filp->f_version != inode->i_version) {
 			for (i = 0;
 			     i < inode->i_size && i < offset;) {
+				/*
+				 * "." is with offset 0 and
+				 * ".." is EXT4_INLINE_DOTDOT_OFFSET.
+				 */
 				if (!i) {
-					/* skip "." and ".." if needed. */
-					i += EXT4_INLINE_DOTDOT_SIZE;
+					i = EXT4_INLINE_DOTDOT_OFFSET;
+					continue;
+				} else if (i == EXT4_INLINE_DOTDOT_OFFSET) {
+					i = EXT4_INLINE_DOTDOT_SIZE;
 					continue;
 				}
 				de = (struct ext4_dir_entry_2 *)
@@ -1373,7 +1381,11 @@ revalidate:
 				if (error)
 					break;
 				stored++;
+				filp->f_pos = EXT4_INLINE_DOTDOT_OFFSET;
+				continue;
+			}
 
+			if (filp->f_pos == EXT4_INLINE_DOTDOT_OFFSET) {
 				error = filldir(dirent, "..", 2, 0, parent_ino,
 						DT_DIR);
 				if (error)
-- 
1.7.0.4

