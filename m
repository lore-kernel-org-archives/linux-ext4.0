From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/16] ext3: Use lowercase names of quota functions
Date: Tue, 27 Jan 2009 17:48:41 +0100
Message-ID: <1233074929-12277-9-git-send-email-jack@suse.cz>
References: <y>
 <1233074929-12277-1-git-send-email-jack@suse.cz>
 <1233074929-12277-2-git-send-email-jack@suse.cz>
 <1233074929-12277-3-git-send-email-jack@suse.cz>
 <1233074929-12277-4-git-send-email-jack@suse.cz>
 <1233074929-12277-5-git-send-email-jack@suse.cz>
 <1233074929-12277-6-git-send-email-jack@suse.cz>
 <1233074929-12277-7-git-send-email-jack@suse.cz>
 <1233074929-12277-8-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42476 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754721AbZA0Qsy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 11:48:54 -0500
In-Reply-To: <1233074929-12277-8-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use lowercase names of quota functions instead of old uppercase ones.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: linux-ext4@vger.kernel.org
---
 fs/ext3/balloc.c |    8 ++++----
 fs/ext3/ialloc.c |   12 ++++++------
 fs/ext3/inode.c  |    6 +++---
 fs/ext3/namei.c  |    6 +++---
 fs/ext3/super.c  |    4 ++--
 fs/ext3/xattr.c  |    6 +++---
 6 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 0dbf1c0..225202d 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -676,7 +676,7 @@ void ext3_free_blocks(handle_t *handle, struct inode *inode,
 	}
 	ext3_free_blocks_sb(handle, sb, block, count, &dquot_freed_blocks);
 	if (dquot_freed_blocks)
-		DQUOT_FREE_BLOCK(inode, dquot_freed_blocks);
+		vfs_dq_free_block(inode, dquot_freed_blocks);
 	return;
 }
 
@@ -1502,7 +1502,7 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 	/*
 	 * Check quota for allocation of this block.
 	 */
-	if (DQUOT_ALLOC_BLOCK(inode, num)) {
+	if (vfs_dq_alloc_block(inode, num)) {
 		*errp = -EDQUOT;
 		return 0;
 	}
@@ -1714,7 +1714,7 @@ allocated:
 
 	*errp = 0;
 	brelse(bitmap_bh);
-	DQUOT_FREE_BLOCK(inode, *count-num);
+	vfs_dq_free_block(inode, *count-num);
 	*count = num;
 	return ret_block;
 
@@ -1729,7 +1729,7 @@ out:
 	 * Undo the block allocation
 	 */
 	if (!performed_allocation)
-		DQUOT_FREE_BLOCK(inode, *count);
+		vfs_dq_free_block(inode, *count);
 	brelse(bitmap_bh);
 	return 0;
 }
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 8de6c72..dd13d60 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -123,10 +123,10 @@ void ext3_free_inode (handle_t *handle, struct inode * inode)
 	 * Note: we must free any quota before locking the superblock,
 	 * as writing the quota to disk may need the lock as well.
 	 */
-	DQUOT_INIT(inode);
+	vfs_dq_init(inode);
 	ext3_xattr_delete_inode(handle, inode);
-	DQUOT_FREE_INODE(inode);
-	DQUOT_DROP(inode);
+	vfs_dq_free_inode(inode);
+	vfs_dq_drop(inode);
 
 	is_directory = S_ISDIR(inode->i_mode);
 
@@ -589,7 +589,7 @@ got:
 		sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE : 0;
 
 	ret = inode;
-	if(DQUOT_ALLOC_INODE(inode)) {
+	if (vfs_dq_alloc_inode(inode)) {
 		err = -EDQUOT;
 		goto fail_drop;
 	}
@@ -620,10 +620,10 @@ really_out:
 	return ret;
 
 fail_free_drop:
-	DQUOT_FREE_INODE(inode);
+	vfs_dq_free_inode(inode);
 
 fail_drop:
-	DQUOT_DROP(inode);
+	vfs_dq_drop(inode);
 	inode->i_flags |= S_NOQUOTA;
 	inode->i_nlink = 0;
 	unlock_new_inode(inode);
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5fa453b..c8f9bd3 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3055,7 +3055,7 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 			error = PTR_ERR(handle);
 			goto err_out;
 		}
-		error = DQUOT_TRANSFER(inode, attr) ? -EDQUOT : 0;
+		error = vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
 		if (error) {
 			ext3_journal_stop(handle);
 			return error;
@@ -3146,7 +3146,7 @@ static int ext3_writepage_trans_blocks(struct inode *inode)
 		ret = 2 * (bpp + indirects) + 2;
 
 #ifdef CONFIG_QUOTA
-	/* We know that structure was already allocated during DQUOT_INIT so
+	/* We know that structure was already allocated during vfs_dq_init so
 	 * we will be updating only the data blocks + inodes */
 	ret += 2*EXT3_QUOTA_TRANS_BLOCKS(inode->i_sb);
 #endif
@@ -3237,7 +3237,7 @@ int ext3_mark_inode_dirty(handle_t *handle, struct inode *inode)
  * i_size has been changed by generic_commit_write() and we thus need
  * to include the updated inode in the current transaction.
  *
- * Also, DQUOT_ALLOC_SPACE() will always dirty the inode when blocks
+ * Also, vfs_dq_alloc_space() will always dirty the inode when blocks
  * are allocated to the file.
  *
  * If the inode is marked synchronous, we don't honour that here - doing
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 69a3d19..c4f21f5 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2041,7 +2041,7 @@ static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
 
 	/* Initialize quotas before so that eventual writes go in
 	 * separate transaction */
-	DQUOT_INIT(dentry->d_inode);
+	vfs_dq_init(dentry->d_inode);
 	handle = ext3_journal_start(dir, EXT3_DELETE_TRANS_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -2100,7 +2100,7 @@ static int ext3_unlink(struct inode * dir, struct dentry *dentry)
 
 	/* Initialize quotas before so that eventual writes go
 	 * in separate transaction */
-	DQUOT_INIT(dentry->d_inode);
+	vfs_dq_init(dentry->d_inode);
 	handle = ext3_journal_start(dir, EXT3_DELETE_TRANS_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -2264,7 +2264,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	/* Initialize quotas before so that eventual writes go
 	 * in separate transaction */
 	if (new_dentry->d_inode)
-		DQUOT_INIT(new_dentry->d_inode);
+		vfs_dq_init(new_dentry->d_inode);
 	handle = ext3_journal_start(old_dir, 2 *
 					EXT3_DATA_TRANS_BLOCKS(old_dir->i_sb) +
 					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 2);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index ec410a9..71b1d63 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1436,7 +1436,7 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 		}
 
 		list_add(&EXT3_I(inode)->i_orphan, &EXT3_SB(sb)->s_orphan);
-		DQUOT_INIT(inode);
+		vfs_dq_init(inode);
 		if (inode->i_nlink) {
 			printk(KERN_DEBUG
 				"%s: truncating inode %lu to %Ld bytes\n",
@@ -2699,7 +2699,7 @@ static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf)
  * Process 1                         Process 2
  * ext3_create()                     quota_sync()
  *   journal_start()                   write_dquot()
- *   DQUOT_INIT()                        down(dqio_mutex)
+ *   vfs_dq_init()                       down(dqio_mutex)
  *     down(dqio_mutex)                    journal_start()
  *
  */
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 175414a..83b7be8 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -498,7 +498,7 @@ ext3_xattr_release_block(handle_t *handle, struct inode *inode,
 		error = ext3_journal_dirty_metadata(handle, bh);
 		if (IS_SYNC(inode))
 			handle->h_sync = 1;
-		DQUOT_FREE_BLOCK(inode, 1);
+		vfs_dq_free_block(inode, 1);
 		ea_bdebug(bh, "refcount now=%d; releasing",
 			  le32_to_cpu(BHDR(bh)->h_refcount));
 		if (ce)
@@ -774,7 +774,7 @@ inserted:
 				/* The old block is released after updating
 				   the inode. */
 				error = -EDQUOT;
-				if (DQUOT_ALLOC_BLOCK(inode, 1))
+				if (vfs_dq_alloc_block(inode, 1))
 					goto cleanup;
 				error = ext3_journal_get_write_access(handle,
 								      new_bh);
@@ -848,7 +848,7 @@ cleanup:
 	return error;
 
 cleanup_dquot:
-	DQUOT_FREE_BLOCK(inode, 1);
+	vfs_dq_free_block(inode, 1);
 	goto cleanup;
 
 bad_block:
-- 
1.6.0.2

