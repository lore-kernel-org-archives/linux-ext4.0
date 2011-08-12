From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Fix ext4_should_writeback_data() for no-journal mode
Date: Fri, 12 Aug 2011 08:53:34 -0700
Message-ID: <1313164414-24204-1-git-send-email-curtw@google.com>
Cc: linux-ext4@vger.kernel.org, Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:15427 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1HLPxr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Aug 2011 11:53:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_should_writeback_data() had an incorrect sequence of
tests to determine if it should return 0 or 1: in
particular, even in no-journal mode, 0 was being returned
for a non-regular-file inode.

This meant that, in non-journal mode, we would use
ext4_journalled_aops for directories, symlinks, and other
non-regular files.  However, calling journalled aop
callbacks when there is no valid handle, can cause problems.

This would cause a kernel crash with Jan Kara's commit
2d859db3e4 ("ext4: fix data corruption in inodes with
journalled data"), because we now dereference 'handle' in
ext4_journalled_write_end().

I also added BUG_ONs to check for a valid handle in the
obviously journal-only aops callbacks.

I tested this running xfstests with a scratch device in
these modes:

   - no-journal
   - data=ordered
   - data=writeback
   - data=journal

All work fine; the data=journal run has many failures and a
crash in xfstests 074, but this is no different from a
vanilla kernel.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
 fs/ext4/ext4_jbd2.h |    4 ++--
 fs/ext4/inode.c     |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index bb85757..5802fa1 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -289,10 +289,10 @@ static inline int ext4_should_order_data(struct inode *inode)
 
 static inline int ext4_should_writeback_data(struct inode *inode)
 {
-	if (!S_ISREG(inode->i_mode))
-		return 0;
 	if (EXT4_JOURNAL(inode) == NULL)
 		return 1;
+	if (!S_ISREG(inode->i_mode))
+		return 0;
 	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
 		return 0;
 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d47264c..ad3a7ca 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -983,6 +983,8 @@ static int ext4_journalled_write_end(struct file *file,
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
+	BUG_ON(!ext4_handle_valid(handle));
+
 	if (copied < len) {
 		if (!PageUptodate(page))
 			copied = 0;
@@ -1699,6 +1701,8 @@ static int __ext4_journalled_writepage(struct page *page,
 		goto out;
 	}
 
+	BUG_ON(!ext4_handle_valid(handle));
+
 	ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
 				do_journal_get_write_access);
 
-- 
1.7.3.1

