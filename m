From: Steven Liu <lingjiujianke@gmail.com>
Subject: [PATCH] code cleanup on fs/super.c
Date: Thu, 17 Feb 2011 17:29:23 +0800
Message-ID: <AANLkTiknstm30Woccr-BSZYYYr=0DdKe4=aUVQuj2Z_s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, liuqi <liuqi@thunderst.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54984 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab1BQJ3X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Feb 2011 04:29:23 -0500
Received: by vxb37 with SMTP id 37so974606vxb.19
        for <linux-ext4@vger.kernel.org>; Thu, 17 Feb 2011 01:29:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Tso,


  Can this patch be fixed?

  Clean up the unused code on fs/super.c. All the filesystem
  are using mount_bdev and mount_nodev to replace
   get_sb_bdev and get_sb_nodev.





Signed-off-by: root <root@localhost.(none)>
---
 fs/super.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 7e9dd4c..8272f26 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -843,22 +843,6 @@ error:
 }
 EXPORT_SYMBOL(mount_bdev);

-int get_sb_bdev(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
-	struct vfsmount *mnt)
-{
-	struct dentry *root;
-
-	root = mount_bdev(fs_type, flags, dev_name, data, fill_super);
-	if (IS_ERR(root))
-		return PTR_ERR(root);
-	mnt->mnt_root = root;
-	mnt->mnt_sb = root->d_sb;
-	return 0;
-}
-
-EXPORT_SYMBOL(get_sb_bdev);

 void kill_block_super(struct super_block *sb)
 {
@@ -897,21 +881,6 @@ struct dentry *mount_nodev(struct
file_system_type *fs_type,
 }
 EXPORT_SYMBOL(mount_nodev);

-int get_sb_nodev(struct file_system_type *fs_type,
-	int flags, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
-	struct vfsmount *mnt)
-{
-	struct dentry *root;
