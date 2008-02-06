From: akpm@linux-foundation.org
Subject: [patch 258/260] ext3: fix lock inversion in direct IO
Date: Wed, 06 Feb 2008 01:40:21 -0800
Message-ID: <200802060940.m169e2Gh004844@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, pbadari@us.ibm.com,
	zach.brown@oracle.com
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761535AbYBFJuO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 04:50:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

We cannot start transaction in ext3_direct_IO() and just let it last during
the whole write because dio_get_page() acquires mmap_sem which ranks above
transaction start (e.g.  because we have dependency chain
mmap_sem->PageLock->journal_start, or because we update atime while holding
mmap_sem) and thus deadlocks could happen.  We solve the problem by
starting a transaction separately for each ext3_get_block() call.

We *could* have a problem that we allocate a block and before its data are
written out the machine crashes and thus we expose stale data.  But that
does not happen because for hole-filling generic code falls back to
buffered writes and for file extension, we add inode to orphan list and
thus in case of crash, journal replay will truncate inode back to the
original size.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |  106 ++++++++++++++++++++++------------------------
 1 file changed, 52 insertions(+), 54 deletions(-)

diff -puN fs/ext3/inode.c~ext3-fix-lock-inversion-in-direct-io fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-fix-lock-inversion-in-direct-io
+++ a/fs/ext3/inode.c
@@ -939,55 +939,45 @@ out:
 	return err;
 }
 
-#define DIO_CREDITS (EXT3_RESERVE_TRANS_BLOCKS + 32)
+/* Maximum number of blocks we map for direct IO at once. */
+#define DIO_MAX_BLOCKS 4096
+/*
+ * Number of credits we need for writing DIO_MAX_BLOCKS:
+ * We need sb + group descriptor + bitmap + inode -> 4
+ * For B blocks with A block pointers per block we need:
+ * 1 (triple ind.) + (B/A/A + 2) (doubly ind.) + (B/A + 2) (indirect).
+ * If we plug in 4096 for B and 256 for A (for 1KB block size), we get 25.
+ */
+#define DIO_CREDITS 25
 
 static int ext3_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	int ret = 0;
+	int ret = 0, started = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 
-	if (!create)
-		goto get_block;		/* A read */
-
-	if (max_blocks == 1)
-		goto get_block;		/* A single block get */
-
-	if (handle->h_transaction->t_state == T_LOCKED) {
-		/*
-		 * Huge direct-io writes can hold off commits for long
-		 * periods of time.  Let this commit run.
-		 */
-		ext3_journal_stop(handle);
-		handle = ext3_journal_start(inode, DIO_CREDITS);
-		if (IS_ERR(handle))
+	if (create && !handle) {	/* Direct IO write... */
+		if (max_blocks > DIO_MAX_BLOCKS)
+			max_blocks = DIO_MAX_BLOCKS;
+		handle = ext3_journal_start(inode, DIO_CREDITS +
+				2 * EXT3_QUOTA_TRANS_BLOCKS(inode->i_sb));
+		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
-		goto get_block;
-	}
-
-	if (handle->h_buffer_credits <= EXT3_RESERVE_TRANS_BLOCKS) {
-		/*
-		 * Getting low on buffer credits...
-		 */
-		ret = ext3_journal_extend(handle, DIO_CREDITS);
-		if (ret > 0) {
-			/*
-			 * Couldn't extend the transaction.  Start a new one.
-			 */
-			ret = ext3_journal_restart(handle, DIO_CREDITS);
+			goto out;
 		}
+		started = 1;
 	}
 
-get_block:
-	if (ret == 0) {
-		ret = ext3_get_blocks_handle(handle, inode, iblock,
+	ret = ext3_get_blocks_handle(handle, inode, iblock,
 					max_blocks, bh_result, create, 0);
-		if (ret > 0) {
-			bh_result->b_size = (ret << inode->i_blkbits);
-			ret = 0;
-		}
+	if (ret > 0) {
+		bh_result->b_size = (ret << inode->i_blkbits);
+		ret = 0;
 	}
+	if (started)
+		ext3_journal_stop(handle);
+out:
 	return ret;
 }
 
@@ -1678,7 +1668,8 @@ static int ext3_releasepage(struct page 
  * if the machine crashes during the write.
  *
  * If the O_DIRECT write is intantiating holes inside i_size and the machine
- * crashes then stale disk data _may_ be exposed inside the file.
+ * crashes then stale disk data _may_ be exposed inside the file. But current
+ * VFS code falls back into buffered path in that case so we are safe.
  */
 static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 			const struct iovec *iov, loff_t offset,
@@ -1687,7 +1678,7 @@ static ssize_t ext3_direct_IO(int rw, st
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct ext3_inode_info *ei = EXT3_I(inode);
-	handle_t *handle = NULL;
+	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
 	size_t count = iov_length(iov, nr_segs);
@@ -1695,17 +1686,21 @@ static ssize_t ext3_direct_IO(int rw, st
 	if (rw == WRITE) {
 		loff_t final_size = offset + count;
 
-		handle = ext3_journal_start(inode, DIO_CREDITS);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			goto out;
-		}
 		if (final_size > inode->i_size) {
+			/* Credits for sb + inode write */
+			handle = ext3_journal_start(inode, 2);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				goto out;
+			}
 			ret = ext3_orphan_add(handle, inode);
-			if (ret)
-				goto out_stop;
+			if (ret) {
+				ext3_journal_stop(handle);
+				goto out;
+			}
 			orphan = 1;
 			ei->i_disksize = inode->i_size;
+			ext3_journal_stop(handle);
 		}
 	}
 
@@ -1713,18 +1708,21 @@ static ssize_t ext3_direct_IO(int rw, st
 				 offset, nr_segs,
 				 ext3_get_block, NULL);
 
-	/*
-	 * Reacquire the handle: ext3_get_block() can restart the transaction
-	 */
-	handle = ext3_journal_current_handle();
-
-out_stop:
-	if (handle) {
+	if (orphan) {
 		int err;
 
-		if (orphan && inode->i_nlink)
+		/* Credits for sb + inode write */
+		handle = ext3_journal_start(inode, 2);
+		if (IS_ERR(handle)) {
+			/* This is really bad luck. We've written the data
+			 * but cannot extend i_size. Bail out and pretend
+			 * the write failed... */
+			ret = PTR_ERR(handle);
+			goto out;
+		}
+		if (inode->i_nlink)
 			ext3_orphan_del(handle, inode);
-		if (orphan && ret > 0) {
+		if (ret > 0) {
 			loff_t end = offset + ret;
 			if (end > inode->i_size) {
 				ei->i_disksize = end;
_
