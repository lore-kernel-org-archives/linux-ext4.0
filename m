From: Jan Kara <jack@suse.cz>
Subject: [PATCH RESEND] ext4: Cleanup ext4_sync_parent()
Date: Wed, 10 Aug 2016 11:25:45 +0200
Message-ID: <1470821145-14586-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934952AbcHJSdo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2016 14:33:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A condition !hlist_empty(&inode->i_dentry) is always true for open file.
Just remove it. Also ext4_sync_parent() could use some explanation why
races with rmdir() are not an issue - add a comment explaining that.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/fsync.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

This seems to have fallen through the cracks...

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 8850254136ae..9b9335796fbc 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -61,6 +61,13 @@ static int ext4_sync_parent(struct inode *inode)
 			break;
 		iput(inode);
 		inode = next;
+		/*
+		 * The directory inode may have gone through rmdir by now. But
+		 * the inode itself and its blocks are still allocated (we hold
+		 * a reference to the inode so it didn't go through
+		 * ext4_evict_inode()) and so we are safe to flush metadata
+		 * blocks and the inode.
+		 */
 		ret = sync_mapping_buffers(inode->i_mapping);
 		if (ret)
 			break;
@@ -107,7 +114,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (!journal) {
 		ret = generic_file_fsync(file, start, end, datasync);
-		if (!ret && !hlist_empty(&inode->i_dentry))
+		if (!ret)
 			ret = ext4_sync_parent(inode);
 		goto out;
 	}
-- 
2.6.6

