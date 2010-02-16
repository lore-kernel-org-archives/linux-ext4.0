From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext3: quota_write cross block boundary behaviour
Date: Tue, 16 Feb 2010 19:33:42 +0300
Message-ID: <1266338022-24298-2-git-send-email-dmonakhov@openvz.org>
References: <1266338022-24298-1-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:54154 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043Ab0BPQkK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2010 11:40:10 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXY005W418D1720@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Tue, 16 Feb 2010 19:45:54 +0300 (MSK)
In-reply-to: <1266338022-24298-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We always assume what dquot update result in changes in one data block
But ext3_quota_write() function may handle cross block boundary writes
In fact if this ever happen it will result in incorrect journal credits
reservation. And later bug_on triggering. As soon this never happen the
boundary cross loop is NOOP. In order to make things straight
let's remove this loop and assert cross boundary condition.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/super.c |   69 +++++++++++++++++++++++++++----------------------------
 1 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index afa2b56..016c841 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2942,9 +2942,7 @@ static ssize_t ext3_quota_write(struct super_block *sb, int type,
 	sector_t blk = off >> EXT3_BLOCK_SIZE_BITS(sb);
 	int err = 0;
 	int offset = off & (sb->s_blocksize - 1);
-	int tocopy;
 	int journal_quota = EXT3_SB(sb)->s_qf_names[type] != NULL;
-	size_t towrite = len;
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
 
@@ -2955,53 +2953,54 @@ static ssize_t ext3_quota_write(struct super_block *sb, int type,
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
+
+	/*
+	 * Since we account only one data block in transaction credits,
+	 * then it is impossible to cross a block boundary.
+	 */
+	if (sb->s_blocksize - offset < len) {
+		ext3_msg(sb, KERN_WARNING, "Quota write (off=%llu, len=%llu)"
+			" cancelled because not block aligned",
+			(unsigned long long)off, (unsigned long long)len);
+		return -EIO;
+	}
 	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
-	while (towrite > 0) {
-		tocopy = sb->s_blocksize - offset < towrite ?
-				sb->s_blocksize - offset : towrite;
-		bh = ext3_bread(handle, inode, blk, 1, &err);
-		if (!bh)
+	bh = ext3_bread(handle, inode, blk, 1, &err);
+	if (!bh)
+		goto out;
+	if (journal_quota) {
+		err = ext3_journal_get_write_access(handle, bh);
+		if (err) {
+			brelse(bh);
 			goto out;
-		if (journal_quota) {
-			err = ext3_journal_get_write_access(handle, bh);
-			if (err) {
-				brelse(bh);
-				goto out;
-			}
-		}
-		lock_buffer(bh);
-		memcpy(bh->b_data+offset, data, tocopy);
-		flush_dcache_page(bh->b_page);
-		unlock_buffer(bh);
-		if (journal_quota)
-			err = ext3_journal_dirty_metadata(handle, bh);
-		else {
-			/* Always do at least ordered writes for quotas */
-			err = ext3_journal_dirty_data(handle, bh);
-			mark_buffer_dirty(bh);
 		}
-		brelse(bh);
-		if (err)
-			goto out;
-		offset = 0;
-		towrite -= tocopy;
-		data += tocopy;
-		blk++;
 	}
+	lock_buffer(bh);
+	memcpy(bh->b_data+offset, data, len);
+	flush_dcache_page(bh->b_page);
+	unlock_buffer(bh);
+	if (journal_quota)
+		err = ext3_journal_dirty_metadata(handle, bh);
+	else {
+		/* Always do at least ordered writes for quotas */
+		err = ext3_journal_dirty_data(handle, bh);
+		mark_buffer_dirty(bh);
+	}
+	brelse(bh);
 out:
-	if (len == towrite) {
+	if (err) {
 		mutex_unlock(&inode->i_mutex);
 		return err;
 	}
-	if (inode->i_size < off+len-towrite) {
-		i_size_write(inode, off+len-towrite);
+	if (inode->i_size < off + len) {
+		i_size_write(inode, off + len);
 		EXT3_I(inode)->i_disksize = inode->i_size;
 	}
 	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	ext3_mark_inode_dirty(handle, inode);
 	mutex_unlock(&inode->i_mutex);
-	return len - towrite;
+	return len;
 }
 
 #endif
-- 
1.6.6

