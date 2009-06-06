From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Make sure inode is deleted from orphan list after truncate
Date: Sat,  6 Jun 2009 02:22:21 +0200
Message-ID: <1244247741-32037-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50615 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbZFFAWX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2009 20:22:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As Ted pointed out, it can happen that ext3_truncate() returns without
removing inode from orphan list. This way we could in some rare cases
(like when we get ENOMEM from an allocation in ext3_truncate called
because of failed ext3_write_begin) leave the inode on orphan list
and that triggers assertion failure on umount.

So make ext3_truncate() always remove inode from in-memory orphan list.

CC: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

 Andrew, would you please merge the patch? Thanks.

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index fcfa243..b50d35d 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2374,7 +2374,7 @@ void ext3_truncate(struct inode *inode)
 	struct page *page;
 
 	if (!ext3_can_truncate(inode))
-		return;
+		goto out_notrans;
 
 	if (inode->i_size == 0 && ext3_should_writeback_data(inode))
 		ei->i_state |= EXT3_STATE_FLUSH_ON_CLOSE;
@@ -2390,7 +2390,7 @@ void ext3_truncate(struct inode *inode)
 		page = grab_cache_page(mapping,
 				inode->i_size >> PAGE_CACHE_SHIFT);
 		if (!page)
-			return;
+			goto out_notrans;
 	}
 
 	handle = start_transaction(inode);
@@ -2401,7 +2401,7 @@ void ext3_truncate(struct inode *inode)
 			unlock_page(page);
 			page_cache_release(page);
 		}
-		return;		/* AKPM: return what? */
+		goto out_notrans;
 	}
 
 	last_block = (inode->i_size + blocksize-1)
@@ -2525,6 +2525,14 @@ out_stop:
 		ext3_orphan_del(handle, inode);
 
 	ext3_journal_stop(handle);
+	return;
+out_notrans:
+	/*
+	 * Delete the inode from orphan list so that it doesn't stay there
+	 * forever and trigger assertion on umount.
+	 */
+	if (inode->i_nlink)
+		ext3_orphan_del(NULL, inode);
 }
 
 static ext3_fsblk_t ext3_get_inode_block(struct super_block *sb,
@@ -3123,12 +3131,6 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 
 	rc = inode_setattr(inode, attr);
 
-	/* If inode_setattr's call to ext3_truncate failed to get a
-	 * transaction handle at all, we need to clean up the in-core
-	 * orphan list manually. */
-	if (inode->i_nlink)
-		ext3_orphan_del(NULL, inode);
