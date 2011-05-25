From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Convert ext3 to new truncate calling convention
Date: Wed, 25 May 2011 10:44:09 +0200
Message-ID: <1306313049-5551-1-git-send-email-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932931Ab1EYIoM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 04:44:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mostly trivial conversion. We fix a bug that IS_IMMUTABLE and IS_APPEND
files could not be truncated during failed writes as we change the code.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/file.c          |    1 -
 fs/ext3/inode.c         |   40 +++++++++++++++++++++++++++-------------
 include/linux/ext3_fs.h |    2 +-
 3 files changed, 28 insertions(+), 15 deletions(-)

 I've added this patch to my tree.

diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index f55df0e..86c8ab3 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -71,7 +71,6 @@ const struct file_operations ext3_file_operations = {
 };
 
 const struct inode_operations ext3_file_inode_operations = {
-	.truncate	= ext3_truncate,
 	.setattr	= ext3_setattr,
 #ifdef CONFIG_EXT3_FS_XATTR
 	.setxattr	= generic_setxattr,
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 4d327a5..abb33cd 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -234,12 +234,10 @@ void ext3_evict_inode (struct inode *inode)
 	if (inode->i_blocks)
 		ext3_truncate(inode);
 	/*
-	 * Kill off the orphan record which ext3_truncate created.
-	 * AKPM: I think this can be inside the above `if'.
-	 * Note that ext3_orphan_del() has to be able to cope with the
-	 * deletion of a non-existent orphan - this is because we don't
-	 * know if ext3_truncate() actually created an orphan record.
-	 * (Well, we could do this if we need to, but heck - it works)
+	 * Kill off the orphan record created when the inode lost the last
+	 * link.  Note that ext3_orphan_del() has to be able to cope with the
+	 * deletion of a non-existent orphan - ext3_truncate() could
+	 * have removed the record.
 	 */
 	ext3_orphan_del(handle, inode);
 	EXT3_I(inode)->i_dtime	= get_seconds();
@@ -890,6 +888,9 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	if (!create || err == -EIO)
 		goto cleanup;
 
+	/*
+	 * Block out ext3_truncate while we alter the tree
+	 */
 	mutex_lock(&ei->truncate_mutex);
 
 	/*
@@ -938,9 +939,6 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	 */
 	count = ext3_blks_to_allocate(partial, indirect_blks,
 					maxblocks, blocks_to_boundary);
-	/*
-	 * Block out ext3_truncate while we alter the tree
-	 */
 	err = ext3_alloc_branch(handle, inode, indirect_blks, &count, goal,
 				offsets + (partial - chain), partial);
 
@@ -1863,7 +1861,7 @@ retry:
 			/* This is really bad luck. We've written the data
 			 * but cannot extend i_size. Truncate allocated blocks
 			 * and pretend the write failed... */
-			ext3_truncate(inode);
+			ext3_truncate_failed_write(inode);
 			ret = PTR_ERR(handle);
 			goto out;
 		}
@@ -2414,8 +2412,6 @@ static void ext3_free_branches(handle_t *handle, struct inode *inode,
 
 int ext3_can_truncate(struct inode *inode)
 {
-	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-		return 0;
 	if (S_ISREG(inode->i_mode))
 		return 1;
 	if (S_ISDIR(inode->i_mode))
@@ -3188,6 +3184,24 @@ int ext3_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return ext3_force_commit(inode->i_sb);
 }
 
+static int ext3_setsize(struct inode *inode, loff_t newsize)
+{
+	loff_t oldsize;
+	int rc;
+
+	rc = inode_newsize_ok(inode, newsize);		
+	if (rc)
+		return rc;
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return -EPERM;
+	oldsize = inode->i_size;
+	i_size_write(inode, newsize);
+	truncate_pagecache(inode, oldsize, newsize);
+	ext3_truncate(inode);
+
+	return 0;
+}
+
 /*
  * ext3_setattr()
  *
@@ -3264,7 +3278,7 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		rc = vmtruncate(inode, attr->ia_size);
+		rc = ext3_setsize(inode, attr->ia_size);
 		if (rc)
 			goto err_out;
 	}
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 85c1d30..d7511b4 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -913,7 +913,7 @@ extern void ext3_dirty_inode(struct inode *);
 extern int ext3_change_inode_journal_flag(struct inode *, int);
 extern int ext3_get_inode_loc(struct inode *, struct ext3_iloc *);
 extern int ext3_can_truncate(struct inode *inode);
-extern void ext3_truncate (struct inode *);
+extern void ext3_truncate(struct inode *inode);
 extern void ext3_set_inode_flags(struct inode *);
 extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
-- 
1.7.1

