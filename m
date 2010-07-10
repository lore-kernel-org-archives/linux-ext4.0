From: shenghui <crosslonelyover@gmail.com>
Subject: [PATCH] avoid NULL deference in ext2_xattr_get
Date: Sat, 10 Jul 2010 16:07:28 +0800
Message-ID: <AANLkTimwrORk9yfJlSMpVdn1V0sg0tssKhxc-3q1xoMX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:35931 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab0GJIH3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Jul 2010 04:07:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

         I walked through ext2 code, and found one potential NULL deference
in ext2/xattr.c.  The version is 2.6.35-rc4, while earlier versions have the
same problem.
         If you configure EXT2_XATTR_DEBUG, you'll get:
# define ea_idebug(inode, f...) do { \
                printk(KERN_DEBUG "inode %s:%ld: ", \
                        inode->i_sb->s_id, inode->i_ino); \
                printk(f); \
                printk("\n"); \
        } while (0)

In ext2/xttr.c ext2_xattr_get, NULL pointer check is done after
ea_idebug call, so some may hit NULL deference here.
 ext2_xattr_get(struct inode *inode, int name_index, const char *name,
                void *buffer, size_t buffer_size)
 {
         struct buffer_head *bh = NULL;
         struct ext2_xattr_entry *entry;
         size_t name_len, size;
         char *end;
         int error;

         ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
                   name_index, name, buffer, (long)buffer_size);

         if (name == NULL)
                 return -EINVAL;


Following is my patch. Please check it.
The patch is against kernel 2.6.35-rc4.


>From adc1fa6535034db3b6d8deebda6ec7eaa8bfd2f8 Mon Sep 17 00:00:00 2001
From: Wang Sheng-Hui <crosslonelyover@gmail.com>
Date: Sat, 10 Jul 2010 16:05:53 +0800
Subject: [PATCH] avoid NULL deference in ext2_xattr_get


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 fs/ext2/xattr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7c39157..81ec1c6 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -156,11 +156,12 @@ ext2_xattr_get(struct inode *inode, int
name_index, const char *name,
 	char *end;
 	int error;

+	if (name == NULL)
+		return -EINVAL;
+
 	ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
 		  name_index, name, buffer, (long)buffer_size);

-	if (name == NULL)
-		return -EINVAL;
 	down_read(&EXT2_I(inode)->xattr_sem);
 	error = -ENODATA;
 	if (!EXT2_I(inode)->i_file_acl)
-- 
1.6.3.3




-- 


Thanks and Best Regards,
shenghui
