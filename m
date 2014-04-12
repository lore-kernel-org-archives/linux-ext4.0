From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] ext4: drop aio_mutex after grabbing i_mutex in ext4_file_write()
Date: Sat, 12 Apr 2014 13:02:39 -0400
Message-ID: <1397322161-32148-4-git-send-email-tytso@mit.edu>
References: <1397322161-32148-1-git-send-email-tytso@mit.edu>
Cc: viro@ZenIV.linux.org.uk, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53228 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbaDLRCw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 13:02:52 -0400
In-Reply-To: <1397322161-32148-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Once we have grabbed i_mutex, this will prevent any other writes from
proceeding, so we don't need to worry about any writes to unwritten
regions from taking place.  So drop the aio_mutex so that if there are
any other parallel writes happen to some other inode that happens to
hash to the same hash table entry, we won't end up blocking that work.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/file.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3ec0c09..5e428d58 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -98,7 +98,6 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct blk_plug plug;
-	int unaligned_aio = 0;
 	int overwrite = 0;
 	size_t length = iov_length(iov, nr_segs);
 	ssize_t ret;
@@ -124,24 +123,26 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 	}
 
 	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT)) {
-		if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
-		    !is_sync_kiocb(iocb))
-			unaligned_aio = ext4_unaligned_aio(inode, iov,
-							   nr_segs, pos);
+		struct mutex *aio_mutex = NULL;
 
 		/* Unaligned direct AIO must be serialized; see comment above */
-		if (unaligned_aio) {
-			mutex_lock(ext4_aio_mutex(inode));
+		if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
+		    !is_sync_kiocb(iocb) &&
+		    ext4_unaligned_aio(inode, iov, nr_segs, pos)) {
+			aio_mutex = ext4_aio_mutex(inode);
+			mutex_lock(aio_mutex);
 			ext4_unwritten_wait(inode);
 		}
 
 		mutex_lock(&inode->i_mutex);
+		if (aio_mutex)
+			mutex_unlock(aio_mutex);
 		blk_start_plug(&plug);
 
 		iocb->private = &overwrite;
 
 		/* check whether we do a DIO overwrite or not */
-		if (ext4_should_dioread_nolock(inode) && !unaligned_aio &&
+		if (ext4_should_dioread_nolock(inode) && !aio_mutex &&
 		    !file->f_mapping->nrpages && pos + length <= i_size_read(inode)) {
 			struct ext4_map_blocks map;
 			unsigned int blkbits = inode->i_blkbits;
@@ -181,9 +182,6 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 				ret = err;
 		}
 		blk_finish_plug(&plug);
