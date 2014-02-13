From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH] ext4: handle fast symlink properly with inline_data
Date: Thu, 13 Feb 2014 15:07:17 +0800
Message-ID: <1392275237-6998-1-git-send-email-wenqing.lz@taobao.com>
Cc: Ian Nartowicz <claws@nartowicz.co.uk>, Tao Ma <tm@tao.ma>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33214 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaBMHCX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Feb 2014 02:02:23 -0500
Received: by mail-pb0-f53.google.com with SMTP id md12so10352558pbc.40
        for <linux-ext4@vger.kernel.org>; Wed, 12 Feb 2014 23:02:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit tries to fix a bug that we can't read fast symlink properly.
The following script can hit the bug.

  #!/bin/bash

  cd ${MNT}
  filename=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
  rm -rf test
  mkdir test
  cd test
  echo "hello" >$filename
  ln -s $filename symlinkfile
  cd
  sudo umount /mnt/sda1
  sudo mount -t ext4 /dev/sda1 /mnt/sda1
  readlink /mnt/sda1/test/symlinkfile

The root cause is that we don't handle inline data in ext4_follow_link.
In this commit it makes ext4_follow_link handle inline data properly.

Reported-by: Ian Nartowicz <claws@nartowicz.co.uk>
Cc: Ian Nartowicz <claws@nartowicz.co.uk>
Cc: Tao Ma <tm@tao.ma>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
Hi all,

I am not sure whether or not we need to enable inline_data for a fast
symlink inode.  Obviously, it brings a benefit that after enabling
inline_data feature for a fast symlink we can get more space to store
the path.  But it seems that the original patch doesn't want to do this
Another solution for fixing this bug is to disable inline_data for a
fast symlink.  Any comment?

Thanks,
						- Zheng

 fs/ext4/ext4.h    |    2 ++
 fs/ext4/inline.c  |    5 ++---
 fs/ext4/symlink.c |   46 +++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ece5556..d943f9c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2589,6 +2589,8 @@ extern int ext4_has_inline_data(struct inode *inode);
 extern int ext4_get_inline_size(struct inode *inode);
 extern int ext4_get_max_inline_size(struct inode *inode);
 extern int ext4_find_inline_data_nolock(struct inode *inode);
+extern int ext4_read_inline_data(struct inode *inode, void *buffer,
+				 unsigned int len, struct ext4_iloc *iloc);
 extern void ext4_write_inline_data(struct inode *inode,
 				   struct ext4_iloc *iloc,
 				   void *buffer, loff_t pos,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 82edf5b..6dda3c4 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -165,9 +165,8 @@ out:
 	return error;
 }
 
-static int ext4_read_inline_data(struct inode *inode, void *buffer,
-				 unsigned int len,
-				 struct ext4_iloc *iloc)
+int ext4_read_inline_data(struct inode *inode, void *buffer,
+			  unsigned int len, struct ext4_iloc *iloc)
 {
 	struct ext4_xattr_entry *entry;
 	struct ext4_xattr_ibody_header *header;
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index ff37119..66b62f8 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -25,9 +25,48 @@
 
 static void *ext4_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
-	struct ext4_inode_info *ei = EXT4_I(dentry->d_inode);
-	nd_set_link(nd, (char *) ei->i_data);
-	return NULL;
+	struct inode *inode = dentry->d_inode;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_iloc iloc;
+	char *inline_data = NULL;
+	int ret, inline_size = 0;
+	int error;
+
+	if (!ext4_has_inline_data(inode)) {
+		nd_set_link(nd, (char *) ei->i_data);
+		return NULL;
+	}
+
+	error = ext4_get_inode_loc(inode, &iloc);
+	if (error)
+		return ERR_PTR(error);
+
+	down_read(&ei->xattr_sem);
+	if (!ext4_has_inline_data(inode)) {
+		up_read(&ei->xattr_sem);
+		return ERR_PTR(-EAGAIN);
+	}
+	inline_size = ext4_get_inline_size(inode);
+	inline_data = kmalloc(inline_size + 1, GFP_NOFS);
+	if (!inline_data) {
+		up_read(&ei->xattr_sem);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ret = ext4_read_inline_data(inode, inline_data, inline_size, &iloc);
+	up_read(&ei->xattr_sem);
+	if (ret < 0)
+		return ERR_PTR(-EIO);
+
+	inline_data[inline_size] = '\0';
+	nd_set_link(nd, inline_data);
+	return inline_data;
+}
+
+static void ext4_put_link(struct dentry *dentry, struct nameidata *nd, void *cookie)
+{
+	if (cookie)
+		kfree(cookie);
 }
 
 const struct inode_operations ext4_symlink_inode_operations = {
@@ -44,6 +83,7 @@ const struct inode_operations ext4_symlink_inode_operations = {
 const struct inode_operations ext4_fast_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= ext4_follow_link,
+	.put_link	= ext4_put_link,
 	.setattr	= ext4_setattr,
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
-- 
1.7.9.7

