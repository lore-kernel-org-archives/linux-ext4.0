From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Fix lock inversion in direct IO
Date: Mon, 28 Jan 2008 23:23:10 +0100
Message-ID: <20080128222310.GD4145@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59137 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757978AbYA1WXM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 17:23:12 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Andrew,

  the patch below fixes a lock inversion which someone reported recently.
More details below in the changelog. Can you merge the patch please? I'll
also write a similar patch for ext4 once we agree this is the way to go...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

We cannot start transaction in ext3_direct_IO() and just let it last during the
whole write because dio_get_page() acquires mmap_sem which ranks above
transaction start (e.g. because we have dependency chain
mmap_sem->PageLock->journal_start, or because we update atime while holding
mmap_sem) and thus deadlocks could happen. We solve the problem by starting
a transaction separately for each ext3_get_block() call.

We *could* have a problem that we allocate a block and before its data are
written out the machine crashes and thus we expose stale data. But that
does not happen because for hole-filling generic code falls back to buffered
writes and for file extension, we add inode to orphan list and thus in
case of crash, journal replay will truncate inode back to the original size.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 9b162cd..5ab7c57 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -941,55 +941,45 @@ out:
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
+				2 * EXT3_QUOTA_TRANS_BLOCKS(sb));
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
 
@@ -1680,7 +1670,8 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
  * if the machine crashes during the write.
  *
  * If the O_DIRECT write is intantiating holes inside i_size and the machine
- * crashes then stale disk data _may_ be exposed inside the file.
+ * crashes then stale disk data _may_ be exposed inside the file. But current
+ * VFS code falls back into buffered path in that case so we are safe.
  */
 static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 			const struct iovec *iov, loff_t offset,
@@ -1689,7 +1680,7 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct ext3_inode_info *ei = EXT3_I(inode);
-	handle_t *handle = NULL;
+	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
 	size_t count = iov_length(iov, nr_segs);
@@ -1697,17 +1688,21 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
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
 
@@ -1715,18 +1710,21 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
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
