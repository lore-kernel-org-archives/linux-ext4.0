From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: fix a warning from sparse check for ext4_dir_llseek
Date: Tue, 19 Feb 2013 17:08:46 +0800
Message-ID: <1361264926-8908-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36381 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab3BSIyF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2013 03:54:05 -0500
Received: by mail-pa0-f44.google.com with SMTP id kp1so3278303pab.3
        for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2013 00:54:03 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

ext4_dir_llseek is only used as a callback function, and no one calls
it directly.  So make it as a static function in order to remove a
warning message from sparse check.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 80a28b2..39460ac 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -333,7 +333,7 @@ static inline loff_t ext4_get_htree_eof(struct file *filp)
  *
  * For non-htree, ext4_llseek already chooses the proper max offset.
  */
-loff_t ext4_dir_llseek(struct file *file, loff_t offset, int whence)
+static loff_t ext4_dir_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file->f_mapping->host;
 	int dx_dir = is_dx_dir(inode);
-- 
1.7.12.rc2.18.g61b472e

