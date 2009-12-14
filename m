From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Fix data / filesystem corruption when write fails to copy data
Date: Mon, 14 Dec 2009 21:35:57 +0100
Message-ID: <1260822957-808-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZLNUgG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 15:36:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext3_write_begin fails after allocating some blocks or
generic_perform_write fails to copy data to write, we truncate blocks already
instantiated beyond i_size. Although these blocks were never inside i_size, we
have to truncate pagecache of these blocks so that corresponding buffers get
unmapped. Otherwise subsequent __block_prepare_write (called because we are
retrying the write) will find the buffers mapped, not call ->get_block, and
thus the page will be backed by already freed blocks leading to filesystem and
data corruption.

Reported-by: James Y Knight <foom@fuhm.net>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

The bug has been introduced by commit 9eaaa2d5759837402ec5eee13b2a97921808c3eb
and thus this fix needs to be applied to 2.6.31 and 2.6.32 kernels. Currently,
it's in Linus's tree as commit 68eb3db08344286733adac48304d9fb7a0e53b27.

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 354ed3b..f9d6937 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1151,6 +1151,16 @@ static int do_journal_get_write_access(handle_t *handle,
 	return ext3_journal_get_write_access(handle, bh);
 }
 
+/*
+ * Truncate blocks that were not used by write. We have to truncate the
+ * pagecache as well so that corresponding buffers get properly unmapped.
+ */
+static void ext3_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	ext3_truncate(inode);
+}
+
 static int ext3_write_begin(struct file *file, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
@@ -1209,7 +1219,7 @@ write_begin_failed:
 		unlock_page(page);
 		page_cache_release(page);
 		if (pos + len > inode->i_size)
-			ext3_truncate(inode);
+			ext3_truncate_failed_write(inode);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
@@ -1304,7 +1314,7 @@ static int ext3_ordered_write_end(struct file *file,
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		ext3_truncate(inode);
+		ext3_truncate_failed_write(inode);
 	return ret ? ret : copied;
 }
 
@@ -1330,7 +1340,7 @@ static int ext3_writeback_write_end(struct file *file,
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		ext3_truncate(inode);
+		ext3_truncate_failed_write(inode);
 	return ret ? ret : copied;
 }
 
@@ -1383,7 +1393,7 @@ static int ext3_journalled_write_end(struct file *file,
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		ext3_truncate(inode);
+		ext3_truncate_failed_write(inode);
 	return ret ? ret : copied;
 }
 
-- 
1.6.4.2

