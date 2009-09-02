From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/16] ext3: Remove syncing logic from ext3_file_write
Date: Wed,  2 Sep 2009 15:59:19 +0200
Message-ID: <1251899966-7316-10-git-send-email-jack@suse.cz>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752728AbZIBOCp@vger.kernel.org>
In-Reply-To: <1251899966-7316-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Syncing is now properly done by generic_file_aio_write() so no special logic is
needed in ext3.

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/file.c |   61 +-------------------------------------------------------
 1 files changed, 1 insertions(+), 60 deletions(-)

diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 5b49704..51fee5f 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -51,71 +51,12 @@ static int ext3_release_file (struct inode * inode, struct file * filp)
 	return 0;
 }
 
-static ssize_t
-ext3_file_write(struct kiocb *iocb, const struct iovec *iov,
-		unsigned long nr_segs, loff_t pos)
-{
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_path.dentry->d_inode;
-	ssize_t ret;
-	int err;
-
-	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
-
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
-		if (!ext3_should_journal_data(inode))
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
-
-force_commit:
-	err = ext3_force_commit(inode->i_sb);
-	if (err)
-		return err;
-	return ret;
-}
-
 const struct file_operations ext3_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
-	.aio_write	= ext3_file_write,
+	.aio_write	= generic_file_aio_write,
 	.unlocked_ioctl	= ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
-- 
1.6.0.2
