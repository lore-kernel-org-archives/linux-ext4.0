From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Convert filesystem to the new truncate calling sequence
Date: Thu,  3 Sep 2009 13:07:05 +0200
Message-ID: <1251976025-25211-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: npiggin@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54676 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbZICLHJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Sep 2009 07:07:09 -0400
Received: from relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 2DC2E94033
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2009 13:07:11 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/file.c  |    2 +-
 fs/ext3/inode.c |   68 +++++++++++++++++++++++++++++++++---------------------
 2 files changed, 42 insertions(+), 28 deletions(-)

 Nick, here is a minimalistic patch converting ext3 to the new truncate
sequence. It has survived some basic testing so feel free to add it to
your patch series.

diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 5b49704..299d3c1 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -129,7 +129,7 @@ const struct file_operations ext3_file_operations = {
 };
 
 const struct inode_operations ext3_file_inode_operations = {
-	.truncate	= ext3_truncate,
+	.new_truncate	= 1,
 	.setattr	= ext3_setattr,
 #ifdef CONFIG_EXT3_FS_XATTR
 	.setxattr	= generic_setxattr,
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index b49908a..ac165bf 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3047,21 +3047,45 @@ int ext3_write_inode(struct inode *inode, int wait)
 }
 
 /*
- * ext3_setattr()
+ * ext3_setsize()
  *
- * Called from notify_change.
+ * This is a helper for ext3_setattr(). It sets i_size, truncates
+ * page cache and truncates inode blocks if they are over i_size.
  *
- * We want to trap VFS attempts to truncate the file as soon as
- * possible.  In particular, we want to make sure that when the VFS
- * shrinks i_size, we put the inode on the orphan list and modify
- * i_disksize immediately, so that during the subsequent flushing of
- * dirty pages and freeing of disk blocks, we can guarantee that any
- * commit will leave the blocks being flushed in an unused state on
+ * ext3_truncate() takes care of updating i_disksize and adding inode
+ * to the orphan list. That makes sure that we can guarantee that any
+ * commit will leave the blocks being truncated in an unused state on
  * disk.  (On recovery, the inode will get truncated and the blocks will
  * be freed, so we have a strong guarantee that no future commit will
  * leave these blocks visible to the user.)
+ */
+static int ext3_setsize(struct inode *inode, loff_t newsize)
+{
+	int error = 0;
+	loff_t oldsize;
+
+	error = inode_newsize_ok(inode, newsize);
+	if (error)
+		goto out;
+	/* VFS should have checked these and return error... */
+	WARN_ON(!S_ISREG(inode->i_mode) || IS_APPEND(inode) ||
+		IS_IMMUTABLE(inode));
+
+	oldsize = inode->i_size;
+	i_size_write(inode, newsize);
+	truncate_pagecache(inode, oldsize, newsize);
+	ext3_truncate(inode);
+out:
+	return error;
+}
+
+/*
+ * ext3_setattr()
+ *
+ * Handle special things ext3 needs for changing owner of the file,
+ * changing ACLs or truncating file.
  *
- * Called with inode->sem down.
+ * Called from notify_change with inode->i_mutex down.
  */
 int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -3100,29 +3124,19 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 		ext3_journal_stop(handle);
 	}
 
-	if (S_ISREG(inode->i_mode) &&
-	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
-		handle_t *handle;
-
-		handle = ext3_journal_start(inode, 3);
-		if (IS_ERR(handle)) {
-			error = PTR_ERR(handle);
-			goto err_out;
-		}
-
-		error = ext3_orphan_add(handle, inode);
-		EXT3_I(inode)->i_disksize = attr->ia_size;
-		rc = ext3_mark_inode_dirty(handle, inode);
-		if (!error)
-			error = rc;
-		ext3_journal_stop(handle);
+	if (attr->ia_valid & ATTR_SIZE) {
+		error = ext3_setsize(inode, attr->ia_size);
+		if (error)
+			return error;
 	}
 
-	rc = inode_setattr(inode, attr);
+	generic_setattr(inode, attr);
 
-	if (!rc && (ia_valid & ATTR_MODE))
+	if (ia_valid & ATTR_MODE)
 		rc = ext3_acl_chmod(inode);
 
+	/* Mark inode dirty due to changes done by generic_setattr() */
+	mark_inode_dirty(inode);
 err_out:
 	ext3_std_error(inode->i_sb, error);
 	if (!error)
-- 
1.6.0.2

