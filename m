From: Jan Kara <jack@suse.cz>
Subject: [PATCH v2] ext3: Convert ext3 to new truncate calling convention
Date: Wed, 25 May 2011 12:43:36 +0200
Message-ID: <1306320216-19368-1-git-send-email-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49822 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1EYKnn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 06:43:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mostly trivial conversion. We fix a bug that IS_IMMUTABLE and IS_APPEND
files could not be truncated during failed writes as we change the code.
In fact we remove the test altogether because do_sys_[f]truncate() and
may_open() do necessary checks anyway.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/file.c          |    1 -
 fs/ext3/inode.c         |   25 ++++++++++---------------
 include/linux/ext3_fs.h |    2 +-
 3 files changed, 11 insertions(+), 17 deletions(-)

 - updated patch to match ext4 version:
    - use truncate_setsize() instead of opencoding it
    - remove IS_APPEND & IS_IMMUTABLE check altogether
    - remove duplicate inode_newsize_ok() check

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
index 4d327a5..d78da39 100644
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
@@ -3264,9 +3260,8 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		rc = vmtruncate(inode, attr->ia_size);
-		if (rc)
-			goto err_out;
+		truncate_setsize(inode, attr->ia_size);
+		ext3_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
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

