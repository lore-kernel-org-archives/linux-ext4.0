From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] ext4: Fix data / filesystem corruption when write fails to copy data
Date: Wed,  2 Dec 2009 20:16:48 +0100
Message-ID: <1259781409-31318-2-git-send-email-jack@suse.cz>
References: <1259781409-31318-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48187 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752AbZLBTRT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Dec 2009 14:17:19 -0500
In-Reply-To: <1259781409-31318-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext4_write_begin fails after allocating some blocks or
generic_perform_write fails to copy data to write, we truncate blocks already
instantiated beyond i_size. Although these blocks were never inside i_size, we
have to truncate pagecache of these blocks so that corresponding buffers get
unmapped. Otherwise subsequent __block_prepare_write (called because we are
retrying the write) will find the buffers mapped, not call ->get_block, and
thus the page will be backed by already freed blocks leading to filesystem and
data corruption.

CC: linux-ext4@vger.kernel.org
CC: tytso@mit.edu
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

Ted, will you please merge this patch? Thanks.

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2c8caa5..18b9416 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1534,6 +1534,16 @@ static int do_journal_get_write_access(handle_t *handle,
 	return ext4_journal_get_write_access(handle, bh);
 }
 
+/*
+ * Truncate blocks that were not used by write. We have to truncate the
+ * pagecache as well so that corresponding buffers get properly unmapped.
+ */
+static void ext4_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+        ext4_truncate(inode);
+}
+
 static int ext4_write_begin(struct file *file, struct address_space *mapping,
 			    loff_t pos, unsigned len, unsigned flags,
 			    struct page **pagep, void **fsdata)
@@ -1599,7 +1609,7 @@ retry:
 
 		ext4_journal_stop(handle);
 		if (pos + len > inode->i_size) {
-			ext4_truncate(inode);
+			ext4_truncate_failed_write(inode);
 			/*
 			 * If truncate failed early the inode might
 			 * still be on the orphan list; we need to
@@ -1709,7 +1719,7 @@ static int ext4_ordered_write_end(struct file *file,
 		ret = ret2;
 
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -1751,7 +1761,7 @@ static int ext4_writeback_write_end(struct file *file,
 		ret = ret2;
 
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -1814,7 +1824,7 @@ static int ext4_journalled_write_end(struct file *file,
 	if (!ret)
 		ret = ret2;
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -3091,7 +3101,7 @@ retry:
 		 * i_size_read because we hold i_mutex.
 		 */
 		if (pos + len > inode->i_size)
-			ext4_truncate(inode);
+			ext4_truncate_failed_write(inode);
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-- 
1.6.4.2

