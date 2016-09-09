From: norton <norton.zhu@huawei.com>
Subject: [PATCH]:ext4 these lines are too long while reading
Date: Fri, 9 Sep 2016 17:33:05 +0800
Message-ID: <57D281D1.6020208@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-fsdevel@vger.kernel.org>, <norton.zhu@huawei.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:9625 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbcIIJdg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Sep 2016 05:33:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, all

I'm a freshman in ext4 file system and I'm reading its source code now.
This patch did nothing but make it looks better.(
some lines are too long in vim :( ).

Thanks.

Signed-off-by: Norton <norton.zhu@huawei.com>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ec8708..09314f8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -109,7 +109,8 @@ static void ext4_clear_request_list(void);
  * transaction start -> page lock(s) -> i_data_sem (rw)
  */

-#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT2)
+#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && \
+	defined(CONFIG_EXT4_USE_FOR_EXT2)
 static struct file_system_type ext2_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ext2",
@@ -1751,7 +1752,9 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	} else if (m->flags & MOPT_DATAJ) {
 		if (is_remount) {
 			if (!sbi->s_journal)
-				ext4_msg(sb, KERN_WARNING, "Remounting file system with no journal so ignoring journalled data option");
+				ext4_msg(sb, KERN_WARNING, "Remounting file "
+					"system with no journal so "
+					"ignoring journalled data option");
 			else if (test_opt(sb, DATA_FLAGS) != m->mount_opt) {
 				ext4_msg(sb, KERN_ERR,
 					 "Cannot change data mode on remount");
@@ -5412,7 +5415,8 @@ static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 	return mount_bdev(fs_type, flags, dev_name, data, ext4_fill_super);
 }

-#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT2)
+#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && \
+	defined(CONFIG_EXT4_USE_FOR_EXT2)
 static inline void register_as_ext2(void)
 {
 	int err = register_filesystem(&ext2_fs_type);
@@ -5555,7 +5559,8 @@ static void __exit ext4_exit_fs(void)
 	ext4_exit_es();
 }

-MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
+MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, \
+		Theodore Ts'o and others");
 MODULE_DESCRIPTION("Fourth Extended Filesystem");
 MODULE_LICENSE("GPL");
 module_init(ext4_init_fs)
-- 
1.8.4.3

