From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/16] ext2: Use lowercase names of quota functions
Date: Tue, 27 Jan 2009 17:48:40 +0100
Message-ID: <1233074929-12277-8-git-send-email-jack@suse.cz>
References: <y>
 <1233074929-12277-1-git-send-email-jack@suse.cz>
 <1233074929-12277-2-git-send-email-jack@suse.cz>
 <1233074929-12277-3-git-send-email-jack@suse.cz>
 <1233074929-12277-4-git-send-email-jack@suse.cz>
 <1233074929-12277-5-git-send-email-jack@suse.cz>
 <1233074929-12277-6-git-send-email-jack@suse.cz>
 <1233074929-12277-7-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1233074929-12277-7-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use lowercase names of quota functions instead of old uppercase ones.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: linux-ext4@vger.kernel.org
---
 fs/ext2/balloc.c |    8 ++++----
 fs/ext2/ialloc.c |   10 +++++-----
 fs/ext2/inode.c  |    2 +-
 fs/ext2/xattr.c  |    8 ++++----
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 4a29d63..7f8d2e5 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -570,7 +570,7 @@ do_more:
 error_return:
 	brelse(bitmap_bh);
 	release_blocks(sb, freed);
-	DQUOT_FREE_BLOCK(inode, freed);
+	vfs_dq_free_block(inode, freed);
 }
 
 /**
@@ -1247,7 +1247,7 @@ ext2_fsblk_t ext2_new_blocks(struct inode *inode, ext2_fsblk_t goal,
 	/*
 	 * Check quota for allocation of this block.
 	 */
-	if (DQUOT_ALLOC_BLOCK(inode, num)) {
+	if (vfs_dq_alloc_block(inode, num)) {
 		*errp = -EDQUOT;
 		return 0;
 	}
@@ -1409,7 +1409,7 @@ allocated:
 
 	*errp = 0;
 	brelse(bitmap_bh);
-	DQUOT_FREE_BLOCK(inode, *count-num);
+	vfs_dq_free_block(inode, *count-num);
 	*count = num;
 	return ret_block;
 
@@ -1420,7 +1420,7 @@ out:
 	 * Undo the block allocation
 	 */
 	if (!performed_allocation)
-		DQUOT_FREE_BLOCK(inode, *count);
+		vfs_dq_free_block(inode, *count);
 	brelse(bitmap_bh);
 	return 0;
 }
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 66321a8..15387c9 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -121,8 +121,8 @@ void ext2_free_inode (struct inode * inode)
 	if (!is_bad_inode(inode)) {
 		/* Quota is already initialized in iput() */
 		ext2_xattr_delete_inode(inode);
-	    	DQUOT_FREE_INODE(inode);
-		DQUOT_DROP(inode);
+		vfs_dq_free_inode(inode);
+		vfs_dq_drop(inode);
 	}
 
 	es = EXT2_SB(sb)->s_es;
@@ -586,7 +586,7 @@ got:
 		goto fail_drop;
 	}
 
-	if (DQUOT_ALLOC_INODE(inode)) {
+	if (vfs_dq_alloc_inode(inode)) {
 		err = -EDQUOT;
 		goto fail_drop;
 	}
@@ -605,10 +605,10 @@ got:
 	return inode;
 
 fail_free_drop:
-	DQUOT_FREE_INODE(inode);
+	vfs_dq_free_inode(inode);
 
 fail_drop:
-	DQUOT_DROP(inode);
+	vfs_dq_drop(inode);
 	inode->i_flags |= S_NOQUOTA;
 	inode->i_nlink = 0;
 	unlock_new_inode(inode);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 23fff2f..b43b955 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1444,7 +1444,7 @@ int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
 		return error;
 	if ((iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid) ||
 	    (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid)) {
-		error = DQUOT_TRANSFER(inode, iattr) ? -EDQUOT : 0;
+		error = vfs_dq_transfer(inode, iattr) ? -EDQUOT : 0;
 		if (error)
 			return error;
 	}
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 987a526..7913531 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -642,7 +642,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 				ea_bdebug(new_bh, "reusing block");
 
 				error = -EDQUOT;
-				if (DQUOT_ALLOC_BLOCK(inode, 1)) {
+				if (vfs_dq_alloc_block(inode, 1)) {
 					unlock_buffer(new_bh);
 					goto cleanup;
 				}
@@ -699,7 +699,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 		 * as if nothing happened and cleanup the unused block */
 		if (error && error != -ENOSPC) {
 			if (new_bh && new_bh != old_bh)
-				DQUOT_FREE_BLOCK(inode, 1);
+				vfs_dq_free_block(inode, 1);
 			goto cleanup;
 		}
 	} else
@@ -731,7 +731,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 			le32_add_cpu(&HDR(old_bh)->h_refcount, -1);
 			if (ce)
 				mb_cache_entry_release(ce);
-			DQUOT_FREE_BLOCK(inode, 1);
+			vfs_dq_free_block(inode, 1);
 			mark_buffer_dirty(old_bh);
 			ea_bdebug(old_bh, "refcount now=%d",
 				le32_to_cpu(HDR(old_bh)->h_refcount));
@@ -794,7 +794,7 @@ ext2_xattr_delete_inode(struct inode *inode)
 		mark_buffer_dirty(bh);
 		if (IS_SYNC(inode))
 			sync_dirty_buffer(bh);
-		DQUOT_FREE_BLOCK(inode, 1);
+		vfs_dq_free_block(inode, 1);
 	}
 	EXT2_I(inode)->i_file_acl = 0;
 
-- 
1.6.0.2

