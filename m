From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/5] ext3: Fix truncation of symlinks after failed write
Date: Tue, 21 Jul 2009 12:04:16 +0200
Message-ID: <1248170659-11771-3-git-send-email-jack@suse.cz>
References: <1248170659-11771-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbZGUKEV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 06:04:21 -0400
In-Reply-To: <1248170659-11771-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Contents of long symlinks is written via standard write methods. So when the
write fails, we add inode to orphan list. But symlinks don't have .truncate
method defined so nobody properly removes them from the orphan list (both on
disk and in memory).

Fix this by calling ext3_truncate() directly instead of calling vmtruncate()
(which is saner anyway since we don't need anything vmtruncate() does except
from calling .truncate in these paths).  We also add inode to orphan list only
if ext3_can_truncate() is true (currently, it can be false for symlinks when
there are no blocks allocated) - otherwise orphan list processing will complain
and ext3_truncate() will not remove inode from on-disk orphan list.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5f51fed..4d7da6f 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1193,15 +1193,16 @@ write_begin_failed:
 		 * i_size_read because we hold i_mutex.
 		 *
 		 * Add inode to orphan list in case we crash before truncate
-		 * finishes.
+		 * finishes. Do this only if ext3_can_truncate() agrees so
+		 * that orphan processing code is happy.
 		 */
-		if (pos + len > inode->i_size)
+		if (pos + len > inode->i_size && ext3_can_truncate(inode))
 			ext3_orphan_add(handle, inode);
 		ext3_journal_stop(handle);
 		unlock_page(page);
 		page_cache_release(page);
 		if (pos + len > inode->i_size)
-			vmtruncate(inode, inode->i_size);
+			ext3_truncate(inode);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
@@ -1287,7 +1288,7 @@ static int ext3_ordered_write_end(struct file *file,
 	 * There may be allocated blocks outside of i_size because
 	 * we failed to copy some data. Prepare for truncate.
 	 */
-	if (pos + len > inode->i_size)
+	if (pos + len > inode->i_size && ext3_can_truncate(inode))
 		ext3_orphan_add(handle, inode);
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
@@ -1296,7 +1297,7 @@ static int ext3_ordered_write_end(struct file *file,
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		vmtruncate(inode, inode->i_size);
+		ext3_truncate(inode);
 	return ret ? ret : copied;
 }
 
@@ -1315,14 +1316,14 @@ static int ext3_writeback_write_end(struct file *file,
 	 * There may be allocated blocks outside of i_size because
 	 * we failed to copy some data. Prepare for truncate.
 	 */
-	if (pos + len > inode->i_size)
+	if (pos + len > inode->i_size && ext3_can_truncate(inode))
 		ext3_orphan_add(handle, inode);
 	ret = ext3_journal_stop(handle);
 	unlock_page(page);
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		vmtruncate(inode, inode->i_size);
+		ext3_truncate(inode);
 	return ret ? ret : copied;
 }
 
@@ -1358,7 +1359,7 @@ static int ext3_journalled_write_end(struct file *file,
 	 * There may be allocated blocks outside of i_size because
 	 * we failed to copy some data. Prepare for truncate.
 	 */
-	if (pos + len > inode->i_size)
+	if (pos + len > inode->i_size && ext3_can_truncate(inode))
 		ext3_orphan_add(handle, inode);
 	EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
 	if (inode->i_size > EXT3_I(inode)->i_disksize) {
@@ -1375,7 +1376,7 @@ static int ext3_journalled_write_end(struct file *file,
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		vmtruncate(inode, inode->i_size);
+		ext3_truncate(inode);
 	return ret ? ret : copied;
 }
 
-- 
1.6.0.2

