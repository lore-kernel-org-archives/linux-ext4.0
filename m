From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] ext4: respect the nobarrier mount option in nojournal mode
Date: Fri, 10 Jun 2016 14:44:50 -0400
Message-ID: <1465584290-2101-1-git-send-email-tytso@mit.edu>
References: <8421f4bf-a49c-572c-c8db-29709a17eee6@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38258 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbcFJSoz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jun 2016 14:44:55 -0400
In-Reply-To: <8421f4bf-a49c-572c-c8db-29709a17eee6@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Also, if we are going to issue the barrier, we should do this after we
write out the parent directories if necessary.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/fsync.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 8850254..5c43725 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -106,9 +106,11 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 
 	if (!journal) {
-		ret = generic_file_fsync(file, start, end, datasync);
+		ret = __generic_file_fsync(file, start, end, datasync);
 		if (!ret && !hlist_empty(&inode->i_dentry))
 			ret = ext4_sync_parent(inode);
+		if (test_opt(inode->i_sb, BARRIER))
+			goto issue_flush;
 		goto out;
 	}
 
@@ -140,6 +142,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		needs_barrier = true;
 	ret = jbd2_complete_transaction(journal, commit_tid);
 	if (needs_barrier) {
+	issue_flush:
 		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 		if (!ret)
 			ret = err;
-- 
2.5.0

