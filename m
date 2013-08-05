From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ext4: Simplify truncation code in ext4_setattr()
Date: Mon,  5 Aug 2013 15:52:23 +0200
Message-ID: <1375710744-29329-4-git-send-email-jack@suse.cz>
References: <1375710744-29329-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab3HENw2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Aug 2013 09:52:28 -0400
In-Reply-To: <1375710744-29329-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Merge conditions in ext4_setattr() handling inode size changes, also
move ext4_begin_ordered_truncate() call somewhat earlier because it
simplifies error recovery in case of failure. Also add error handling in
case i_disksize update fails.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 109 +++++++++++++++++++++++++-------------------------------
 1 file changed, 49 insertions(+), 60 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4263878..e7d98d2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4560,7 +4560,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		ext4_journal_stop(handle);
 	}
 
-	if (attr->ia_valid & ATTR_SIZE) {
+	if (attr->ia_valid & ATTR_SIZE && attr->ia_size != inode->i_size) {
+		handle_t *handle;
+		loff_t oldsize = inode->i_size;
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -4568,73 +4570,60 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			if (attr->ia_size > sbi->s_bitmap_maxbytes)
 				return -EFBIG;
 		}
-	}
-
-	if (S_ISREG(inode->i_mode) &&
-	    attr->ia_valid & ATTR_SIZE &&
-	    (attr->ia_size < inode->i_size)) {
-		handle_t *handle;
-
-		handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
-		if (IS_ERR(handle)) {
-			error = PTR_ERR(handle);
-			goto err_out;
-		}
-		if (ext4_handle_valid(handle)) {
-			error = ext4_orphan_add(handle, inode);
-			orphan = 1;
-		}
-		EXT4_I(inode)->i_disksize = attr->ia_size;
-		rc = ext4_mark_inode_dirty(handle, inode);
-		if (!error)
-			error = rc;
-		ext4_journal_stop(handle);
-
-		if (ext4_should_order_data(inode)) {
-			error = ext4_begin_ordered_truncate(inode,
+		if (S_ISREG(inode->i_mode) &&
+		    (attr->ia_size < inode->i_size)) {
+			if (ext4_should_order_data(inode)) {
+				error = ext4_begin_ordered_truncate(inode,
 							    attr->ia_size);
-			if (error) {
-				/* Do as much error cleanup as possible */
-				handle = ext4_journal_start(inode,
-							    EXT4_HT_INODE, 3);
-				if (IS_ERR(handle)) {
-					ext4_orphan_del(NULL, inode);
+				if (error)
 					goto err_out;
-				}
-				ext4_orphan_del(handle, inode);
-				orphan = 0;
-				ext4_journal_stop(handle);
+			}
+			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
+			if (IS_ERR(handle)) {
+				error = PTR_ERR(handle);
+				goto err_out;
+			}
+			if (ext4_handle_valid(handle)) {
+				error = ext4_orphan_add(handle, inode);
+				orphan = 1;
+			}
+			EXT4_I(inode)->i_disksize = attr->ia_size;
+			rc = ext4_mark_inode_dirty(handle, inode);
+			if (!error)
+				error = rc;
+			ext4_journal_stop(handle);
+			if (error) {
+				ext4_orphan_del(NULL, inode);
 				goto err_out;
 			}
 		}
-	}
-
-	if (attr->ia_valid & ATTR_SIZE) {
-		if (attr->ia_size != inode->i_size) {
-			loff_t oldsize = inode->i_size;
 
-			i_size_write(inode, attr->ia_size);
-			/*
-			 * Blocks are going to be removed from the inode. Wait
-			 * for dio in flight.  Temporarily disable
-			 * dioread_nolock to prevent livelock.
-			 */
-			if (orphan) {
-				if (!ext4_should_journal_data(inode)) {
-					ext4_inode_block_unlocked_dio(inode);
-					inode_dio_wait(inode);
-					ext4_inode_resume_unlocked_dio(inode);
-				} else
-					ext4_wait_for_tail_page_commit(inode);
-			}
-			/*
-			 * Truncate pagecache after we've waited for commit
-			 * in data=journal mode to make pages freeable.
-			 */
-			truncate_pagecache(inode, oldsize, inode->i_size);
+		i_size_write(inode, attr->ia_size);
+		/*
+		 * Blocks are going to be removed from the inode. Wait
+		 * for dio in flight.  Temporarily disable
+		 * dioread_nolock to prevent livelock.
+		 */
+		if (orphan) {
+			if (!ext4_should_journal_data(inode)) {
+				ext4_inode_block_unlocked_dio(inode);
+				inode_dio_wait(inode);
+				ext4_inode_resume_unlocked_dio(inode);
+			} else
+				ext4_wait_for_tail_page_commit(inode);
 		}
-		ext4_truncate(inode);
+		/*
+		 * Truncate pagecache after we've waited for commit
+		 * in data=journal mode to make pages freeable.
+		 */
+		truncate_pagecache(inode, oldsize, inode->i_size);
 	}
+	/*
+	 * We want to call ext4_truncate() even if attr->ia_size ==
+ 	 * inode->i_size for cases like truncation of fallocated space
+	 */
+	if (attr->ia_valid & ATTR_SIZE)
+		ext4_truncate(inode);
 
 	if (!rc) {
 		setattr_copy(inode, attr);
-- 
1.8.1.4

