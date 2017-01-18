From: yi zhang <yi.zhang@huawei.com>
Subject: [PATCH 2/2] ext4: add detection of i_nlink
Date: Wed, 18 Jan 2017 17:46:09 +0800
Message-ID: <1484732769-31670-2-git-send-email-yi.zhang@huawei.com>
References: <1484732769-31670-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <viro@ZenIV.linux.org.uk>,
        <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:23971 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752581AbdARJre (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jan 2017 04:47:34 -0500
In-Reply-To: <1484732769-31670-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Because of the disk and hardware issue, the inode->i_nlink of ext4
becomes zero abnormally but the dentry is still positive, it will
cause memory corruption after the following process:

 1) Due to the inode->i_nlink is 0, this inode will be added into
the orhpan list,
 2) ext4_rename() cover this inode, and drop_nlink() will underflow
the inode->i_nlink to 0xFFFFFFFF,
 3) iput() add this inode to LRU,
 4) evict() will call destroy_inode() to destroy this inode but
skip removing it from the orphan list,
 5) after this, the inode's memory address space will be used by
other module, when the ext4 filesystem change the orphan list, it will
trample other module's data and then may cause oops.

This patch detect inode->i_nlink in i_op->valitate, if it becomes zero
abnormally, we call ext4_error and return -EFSCORRUPTED.

Signed-off-by: yi zhang <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    |  1 +
 fs/ext4/file.c    |  1 +
 fs/ext4/inode.c   | 10 ++++++++++
 fs/ext4/namei.c   |  2 ++
 fs/ext4/symlink.c |  3 +++
 5 files changed, 17 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2163c1e..451f3b1f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2472,6 +2472,7 @@ extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 				struct kstat *stat);
+extern int ext4_validate(struct inode *inode);
 extern void ext4_evict_inode(struct inode *);
 extern void ext4_clear_inode(struct inode *);
 extern int  ext4_sync_inode(handle_t *, struct inode *);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index d663d3d..8c6c702 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -762,5 +762,6 @@ const struct inode_operations ext4_file_inode_operations = {
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
 	.fiemap		= ext4_fiemap,
+	.validate	= ext4_validate,
 };
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 88d57af..6f5c393 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5382,6 +5382,16 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	return 0;
 }
 
+int ext4_validate(struct inode *inode)
+{
+	if (inode->i_nlink == 0) {
+		EXT4_ERROR_INODE(inode, "bad nlink value: %lu", inode->i_nlink);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 static int ext4_index_trans_blocks(struct inode *inode, int lblocks,
 				   int pextents)
 {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index eadba91..0396fe2 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3888,6 +3888,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
 	.fiemap         = ext4_fiemap,
+	.validate	= ext4_validate,
 };
 
 const struct inode_operations ext4_special_inode_operations = {
@@ -3895,4 +3896,5 @@ const struct inode_operations ext4_special_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
+	.validate	= ext4_validate,
 };
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index 73b184d..92377d0 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -86,16 +86,19 @@ const struct inode_operations ext4_encrypted_symlink_inode_operations = {
 	.get_link	= ext4_encrypted_get_link,
 	.setattr	= ext4_setattr,
 	.listxattr	= ext4_listxattr,
+	.validate	= ext4_validate,
 };
 
 const struct inode_operations ext4_symlink_inode_operations = {
 	.get_link	= page_get_link,
 	.setattr	= ext4_setattr,
 	.listxattr	= ext4_listxattr,
+	.validate	= ext4_validate,
 };
 
 const struct inode_operations ext4_fast_symlink_inode_operations = {
 	.get_link	= simple_get_link,
 	.setattr	= ext4_setattr,
 	.listxattr	= ext4_listxattr,
+	.validate	= ext4_validate,
 };
-- 
2.5.0

