From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/17] ext4: Remove syncing logic from ext4_file_write
Date: Wed, 19 Aug 2009 18:04:37 +0200
Message-ID: <1250697884-22288-11-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55950 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbZHSQEr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:47 -0400
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The syncing is now properly handled by generic_file_aio_write() so
no special ext4 code is needed.

CC: linux-ext4@vger.kernel.org
CC: tytso@mit.edu
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c |   53 ++---------------------------------------------------
 1 files changed, 2 insertions(+), 51 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3f1873f..aafe432 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -58,10 +58,7 @@ static ssize_t
 ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos)
 {
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_path.dentry->d_inode;
-	ssize_t ret;
-	int err;
+	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
 
 	/*
 	 * If we have encountered a bitmap-format file, the size limit
@@ -81,53 +78,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
-	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
-	/*
-	 * Skip flushing if there was an error, or if nothing was written.
-	 */
-	if (ret <= 0)
-		return ret;
-
-	/*
-	 * If the inode is IS_SYNC, or is O_SYNC and we are doing data
-	 * journalling then we need to make sure that we force the transaction
-	 * to disk to keep all metadata uptodate synchronously.
-	 */
-	if (file->f_flags & O_SYNC) {
-		/*
-		 * If we are non-data-journaled, then the dirty data has
-		 * already been flushed to backing store by generic_osync_inode,
-		 * and the inode has been flushed too if there have been any
-		 * modifications other than mere timestamp updates.
-		 *
-		 * Open question --- do we care about flushing timestamps too
-		 * if the inode is IS_SYNC?
-		 */
-		if (!ext4_should_journal_data(inode))
-			return ret;
-
-		goto force_commit;
-	}
-
-	/*
-	 * So we know that there has been no forced data flush.  If the inode
-	 * is marked IS_SYNC, we need to force one ourselves.
-	 */
-	if (!IS_SYNC(inode))
-		return ret;
-
-	/*
-	 * Open question #2 --- should we force data to disk here too?  If we
-	 * don't, the only impact is that data=writeback filesystems won't
-	 * flush data to disk automatically on IS_SYNC, only metadata (but
-	 * historically, that is what ext2 has done.)
-	 */
