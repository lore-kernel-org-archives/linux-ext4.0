From: Steven Liu <lingjiujianke@gmail.com>
Subject: [PATCH] code cleanup on include/linux/fs.h
Date: Thu, 17 Feb 2011 17:38:43 +0800
Message-ID: <AANLkTinpYGiq_mn7iO4xKW01nLXWrW89bRMXjME=5pSS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, liuqi <liuqi@thunderst.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40829 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab1BQJio (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Feb 2011 04:38:44 -0500
Received: by vxb37 with SMTP id 37so978017vxb.19
        for <linux-ext4@vger.kernel.org>; Thu, 17 Feb 2011 01:38:43 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,


      Can this patch be fixed.

       Cleanup the unsed code on  include/linux/fs.h.
    All filesystem using mount_bdev and mount_nodev
    to replace get_sb_bdev and get_sb_nodev.
    So rmmove the unused code.


Signed-off-by: LiuQi <lingjiujianke@gmail.com.com>
---
 include/linux/fs.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index bd32159..53ad8e6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1807,10 +1807,6 @@ extern struct dentry *mount_ns(struct
file_system_type *fs_type, int flags,
 extern struct dentry *mount_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
 	int (*fill_super)(struct super_block *, void *, int));
-extern int get_sb_bdev(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
-	struct vfsmount *mnt);
 extern struct dentry *mount_single(struct file_system_type *fs_type,
 	int flags, void *data,
 	int (*fill_super)(struct super_block *, void *, int));
@@ -1821,10 +1817,6 @@ extern int get_sb_single(struct
file_system_type *fs_type,
 extern struct dentry *mount_nodev(struct file_system_type *fs_type,
 	int flags, void *data,
 	int (*fill_super)(struct super_block *, void *, int));
-extern int get_sb_nodev(struct file_system_type *fs_type,
-	int flags, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
-	struct vfsmount *mnt);
 void generic_shutdown_super(struct super_block *sb);
 void kill_block_super(struct super_block *sb);
 void kill_anon_super(struct super_block *sb);
-- 
1.6.5.2
