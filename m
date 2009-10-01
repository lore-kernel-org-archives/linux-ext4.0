From: scjody@sun.com
Subject: [patch 3/4] [jbd] Add support for journal guided resync.
Date: Thu, 01 Oct 2009 18:39:32 -0400
Message-ID: <20091001224018.740641147@sun.com>
References: <20091001223929.120106893@sun.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; NAME=''jbd-journal-guided-resync-infra.patch
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60602 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbZJAWkU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 18:40:20 -0400
Content-disposition: inline; filename=jbd-journal-guided-resync-infra.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adds support for declare blocks, used by ext3's journal guided resync (declared
mode.)  A declare block is added to the journal to list blocks to be written
during the current transaction.  During journal replay, we perform a RAID
resync of only these blocks and skip the rest of the resync.

Index: linux-2.6.18-128.1.6/fs/jbd/checkpoint.c
===================================================================
--- linux-2.6.18-128.1.6.orig/fs/jbd/checkpoint.c
+++ linux-2.6.18-128.1.6/fs/jbd/checkpoint.c
@@ -712,6 +712,8 @@ void __journal_drop_transaction(journal_
 
 	J_ASSERT(transaction->t_state == T_FINISHED);
 	J_ASSERT(transaction->t_buffers == NULL);
+	J_ASSERT(transaction->t_declare_root.rnode == NULL);
+	J_ASSERT(transaction->t_declare_done_root.rnode == NULL);
 	J_ASSERT(transaction->t_sync_datalist == NULL);
 	J_ASSERT(transaction->t_forget == NULL);
 	J_ASSERT(transaction->t_iobuf_list == NULL);
Index: linux-2.6.18-128.1.6/fs/jbd/commit.c
===================================================================
--- linux-2.6.18-128.1.6.orig/fs/jbd/commit.c
+++ linux-2.6.18-128.1.6/fs/jbd/commit.c
@@ -373,6 +373,262 @@ static inline __u32 jbd_checksum_data(__
 	return checksum;
 }
 
+int wait_for_descriptors(journal_t *journal, transaction_t *trans) {
+	struct journal_head *jh;
+	struct buffer_head *bh;
+	int err = 0;
+
+wait_for_ctlbuf:
+
+	while (trans->t_log_list != NULL) {
+
+		jh = trans->t_log_list->b_tprev;
+		bh = jh2bh(jh);
+		if (buffer_locked(bh)) {
+			wait_on_buffer(bh);
+			goto wait_for_ctlbuf;
+		}
+		if (cond_resched())
+			goto wait_for_ctlbuf;
+
+		if (unlikely(!buffer_uptodate(bh)))
+			err = -EIO;
+
+		BUFFER_TRACE(bh, "ph5: control buffer writeout done: unfile");
+		clear_buffer_jwrite(bh);
+		journal_unfile_buffer(journal, jh);
+		journal_put_journal_head(jh);
+		__brelse(bh);		/* One for getblk */
+	}
+
+	return err;
+}
+
+struct journal_head *get_descriptor(journal_t *journal, transaction_t *trans,
+				    int blocktype, char **tagp, int *space_left) {
+	struct journal_head *descriptor;
+	struct buffer_head *dbh;
+	journal_header_t *header;
+
+	jbd_debug(4, "JBD: get descriptor\n");
+
+	descriptor = journal_get_descriptor_buffer(journal);
+	if (!descriptor)
+		return NULL;
+
+	dbh = jh2bh(descriptor);
+	jbd_debug(4, "JBD: got buffer %llu (%p)\n",
+	    (unsigned long long)dbh->b_blocknr, dbh->b_data);
+	header = (journal_header_t *)&dbh->b_data[0];
+	header->h_magic     = cpu_to_be32(JFS_MAGIC_NUMBER);
+	header->h_blocktype = cpu_to_be32(blocktype);
+	header->h_sequence  = cpu_to_be32(trans->t_tid);
+
+	*tagp = &dbh->b_data[sizeof(journal_header_t)];
+	*space_left = dbh->b_size - sizeof(journal_header_t);
+
+	set_buffer_jwrite(dbh);
+	set_buffer_dirty(dbh);
+
+	/* Record it so that we can wait for it later */
+	BUFFER_TRACE(dbh, "ph3: file as descriptor");
+	journal_file_buffer(descriptor, trans, BJ_LogCtl);
+
+	return descriptor;
+}
+
+/*
+ * Write declare blocks containing a list of the data blocks that will be
+ * written out
+ */
+void write_declare_blocks(journal_t *journal, transaction_t *transaction,
+			  int committing)
+{
+	struct journal_head *jh, *descriptor = NULL;
+	struct buffer_head *bh;
+	int i, bufs = 0, err;
+	unsigned int n, count = 0, to_write;
+	unsigned long nextblock = 0;
+	char *tagp = NULL;
+	journal_block_tag_t *tag = NULL;
+	int space_left = 0, first_tag = 0, tag_flag;
+	struct radix_tree_root *root;
+
+	root = &transaction->t_declare_root;
+
+	spin_lock(&journal->j_list_lock);
+	to_write = transaction->t_declare_request;
+	transaction->t_declare_request = 0;
+	spin_unlock(&journal->j_list_lock);
+
+	if (to_write == UINT_MAX)
+		jbd_debug (1, "jbd: tid %d write declare request for ALL "
+			   "blocks\n", transaction->t_tid);
+	else
+		jbd_debug (1, "jbd: tid %d write declare request for %u "
+			   "blocks\n", transaction->t_tid, to_write);
+write_declare:
+	cond_resched();
+	spin_lock(&journal->j_list_lock);
+
+	n = radix_tree_gang_lookup(root, journal->j_declare_jhs, nextblock, 1);
+	while (n) {
+		if (!descriptor) {
+			J_ASSERT(bufs == 0);
+
+			spin_unlock(&journal->j_list_lock);
+
+			descriptor = get_descriptor(journal, transaction,
+						    JFS_DECLARE_BLOCK,
+						    &tagp, &space_left);
+
+			if (!descriptor) {
+				journal_abort(journal, -EIO);
+				return;
+			}
+
+			first_tag = 1;
+			journal->j_declare_bhs[bufs++] = jh2bh(descriptor);
+
+			goto write_declare;
+		}
+
+		jh = (struct journal_head *)journal->j_declare_jhs[0];
+		bh = jh2bh(jh);
+
+		/* refile the buffer as having been declared */
+		if (!inverted_lock(journal, bh))
+			goto write_declare;
+		__journal_unfile_buffer(jh);
+		__journal_file_buffer(jh, transaction, BJ_DeclareDone);
+
+		jbd_unlock_bh_state(bh);
+
+		/* record the block's tag in the current descriptor buffer */
+		tag_flag = 0;
+		if (!first_tag)
+			tag_flag |= JFS_FLAG_SAME_UUID;
+
+		tag = (journal_block_tag_t *)tagp;
+		tag->t_blocknr = cpu_to_be32(bh->b_blocknr);
+		tag->t_flags = cpu_to_be32(tag_flag);
+		tagp += sizeof(journal_block_tag_t);
+		space_left -= sizeof(journal_block_tag_t);
+
+		if (first_tag) {
+			memcpy (tagp, journal->j_uuid, 16);
+			tagp += 16;
+			space_left -= 16;
+			first_tag = 0;
+		}
+
+		count++;
+
+		/* advance to the next journal head and buffer */
+		nextblock = bh->b_blocknr + 1;
+		n = radix_tree_gang_lookup(root, journal->j_declare_jhs,
+					   nextblock, 1);
+
+		/* If there's no more to do, or if the descriptor is full,
+		   let the IO rip! */
+
+		if (bufs == ARRAY_SIZE(journal->j_declare_bhs) || n == 0 ||
+		    count == to_write ||
+		    space_left < sizeof(journal_block_tag_t) + 16) {
+
+			jbd_debug(4, "JBD: Submit %d IOs\n", bufs);
+
+			/* Write an end-of-descriptor marker before
+			 * submitting the IOs.  "tag" still points to
+                         * the last tag we set up.
+			 */
+
+			tag->t_flags |= cpu_to_be32(JFS_FLAG_LAST_TAG);
+
+			spin_unlock(&journal->j_list_lock);
+
+			for (i = 0; i < bufs; i++) {
+				struct buffer_head *bh = journal->j_declare_bhs[i];
+				lock_buffer(bh);
+				clear_buffer_dirty(bh);
+				set_buffer_uptodate(bh);
+				bh->b_end_io = journal_end_buffer_io_sync;
+				submit_bh(WRITE, bh);
+			}
+
+			cond_resched();
+			spin_lock(&journal->j_list_lock);
+
+			/* force a new descriptor to be generated next time */
+			descriptor = NULL;
+			bufs = 0;
+
+			/* need to redo tree lookup since we lost the lock,
+			   but that will happen after we get a new descriptor */
+		}
+
+		if (count == to_write) break;
+	}
+	spin_unlock(&journal->j_list_lock);
+
+	jbd_debug(2, "jbd: tid %d wrote declarations for %u blocks\n",
+		  transaction->t_tid, count);
+	if (to_write == UINT_MAX)
+		J_ASSERT(transaction->t_declare_root.rnode == NULL);
+
+	/* wait for the declare blocks to be written */
+	err = wait_for_descriptors(journal, transaction);
+
+	/* move the declared buffers to the sync data list */
+
+	root = &transaction->t_declare_done_root;
+	count = 0;
+	nextblock = 0;
+
+move_declare:
+	cond_resched();
+	spin_lock(&journal->j_list_lock);
+
+	while ((n = radix_tree_gang_lookup(root, journal->j_declare_jhs,
+					   nextblock,
+					   ARRAY_SIZE(journal->j_declare_jhs)))) {
+		/* loop and move the journal heads */
+		for (i = 0; i < n; i++) {
+			jh = journal->j_declare_jhs[i];
+			bh = jh2bh(jh);
+
+			if (!inverted_lock(journal, bh)) {
+				goto move_declare;
+			}
+			__journal_unfile_buffer(jh);
+
+			if (committing)
+				/* set buffer dirty for writing below */
+				set_buffer_dirty(bh);
+			else
+				/* set page dirty for virtual memory */
+				mark_buffer_dirty(bh);
+
+			__journal_file_buffer(jh, transaction, BJ_SyncData);
+
+			count++;
+
+			nextblock = bh->b_blocknr + 1;
+
+			jbd_unlock_bh_state(bh);
+
+			if (lock_need_resched(&journal->j_list_lock)) {
+				spin_unlock(&journal->j_list_lock);
+				goto move_declare;
+			}
+		}
+	}
+	spin_unlock(&journal->j_list_lock);
+
+	jbd_debug(2, "jbd: tid %d moved %u declare blocks\n",
+		  transaction->t_tid, count);
+}
+
 /*
  * journal_commit_transaction
  *
@@ -390,7 +646,6 @@ void journal_commit_transaction(journal_
 	int err;
 	unsigned long blocknr;
 	char *tagp = NULL;
-	journal_header_t *header;
 	journal_block_tag_t *tag = NULL;
 	int space_left = 0;
 	int first_tag = 0;
@@ -517,6 +772,11 @@ void journal_commit_transaction(journal_
 
 	jbd_debug (3, "JBD: commit phase 2\n");
 
+	if (journal->j_flags & JFS_DECLARE) {
+		commit_transaction->t_declare_request = UINT_MAX;
+		write_declare_blocks(journal, commit_transaction, 1);
+	}
+
 	/*
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
@@ -545,9 +805,13 @@ void journal_commit_transaction(journal_
 	 * If we found any dirty or locked buffers, then we should have
 	 * looped back up to the write_out_data label.  If there weren't
 	 * any then journal_clean_data_list should have wiped the list
-	 * clean by now, so check that it is in fact empty.
+	 * clean by now, so check that it is in fact empty.  Also check
+	 * declared mode trees - write_declare_blocks() should have left
+	 * them empty.
 	 */
-	J_ASSERT (commit_transaction->t_sync_datalist == NULL);
+	J_ASSERT(commit_transaction->t_sync_datalist == NULL);
+	J_ASSERT(commit_transaction->t_declare_root.rnode == NULL);
+	J_ASSERT(commit_transaction->t_declare_done_root.rnode == NULL);
 
 	jbd_debug (3, "JBD: commit phase 3\n");
 
@@ -596,38 +860,20 @@ void journal_commit_transaction(journal_
 		   record the metadata buffer. */
 
 		if (!descriptor) {
-			struct buffer_head *bh;
-
 			J_ASSERT (bufs == 0);
 
-			jbd_debug(4, "JBD: get descriptor\n");
+			descriptor = get_descriptor(journal,
+						    commit_transaction,
+						    JFS_DESCRIPTOR_BLOCK,
+						    &tagp, &space_left);
 
-			descriptor = journal_get_descriptor_buffer(journal);
 			if (!descriptor) {
 				journal_abort(journal, -EIO);
 				continue;
 			}
 
-			bh = jh2bh(descriptor);
-			jbd_debug(4, "JBD: got buffer %llu (%p)\n",
-				(unsigned long long)bh->b_blocknr, bh->b_data);
-			header = (journal_header_t *)&bh->b_data[0];
-			header->h_magic     = cpu_to_be32(JFS_MAGIC_NUMBER);
-			header->h_blocktype = cpu_to_be32(JFS_DESCRIPTOR_BLOCK);
-			header->h_sequence  = cpu_to_be32(commit_transaction->t_tid);
-
-			tagp = &bh->b_data[sizeof(journal_header_t)];
-			space_left = bh->b_size - sizeof(journal_header_t);
 			first_tag = 1;
-			set_buffer_jwrite(bh);
-			set_buffer_dirty(bh);
-			wbuf[bufs++] = bh;
-
-			/* Record it so that we can wait for IO
-                           completion later */
-			BUFFER_TRACE(bh, "ph3: file as descriptor");
-			journal_file_buffer(descriptor, commit_transaction,
-					BJ_LogCtl);
+			wbuf[bufs++] = jh2bh(descriptor);
 		}
 
 		/* Where is the buffer to be written? */
@@ -826,29 +1072,7 @@ wait_for_iobuf:
 	jbd_debug(3, "JBD: commit phase 5\n");
 
 	/* Here we wait for the revoke record and descriptor record buffers */
- wait_for_ctlbuf:
-	while (commit_transaction->t_log_list != NULL) {
-		struct buffer_head *bh;
-
-		jh = commit_transaction->t_log_list->b_tprev;
-		bh = jh2bh(jh);
-		if (buffer_locked(bh)) {
-			wait_on_buffer(bh);
-			goto wait_for_ctlbuf;
-		}
-		if (cond_resched())
-			goto wait_for_ctlbuf;
-
-		if (unlikely(!buffer_uptodate(bh)))
-			err = -EIO;
-
-		BUFFER_TRACE(bh, "ph5: control buffer writeout done: unfile");
-		clear_buffer_jwrite(bh);
-		journal_unfile_buffer(journal, jh);
-		journal_put_journal_head(jh);
-		__brelse(bh);		/* One for getblk */
-		/* AKPM: bforget here */
-	}
+	err = wait_for_descriptors(journal, commit_transaction);
 
 	if (err)
 		journal_abort(journal, err);
@@ -904,6 +1128,8 @@ wait_for_iobuf:
 	J_ASSERT(commit_transaction->t_iobuf_list == NULL);
 	J_ASSERT(commit_transaction->t_shadow_list == NULL);
 	J_ASSERT(commit_transaction->t_log_list == NULL);
+	J_ASSERT(commit_transaction->t_declare_root.rnode == NULL);
+	J_ASSERT(commit_transaction->t_declare_done_root.rnode == NULL);
 
 restart_loop:
 	/*
Index: linux-2.6.18-128.1.6/fs/jbd/journal.c
===================================================================
--- linux-2.6.18-128.1.6.orig/fs/jbd/journal.c
+++ linux-2.6.18-128.1.6/fs/jbd/journal.c
@@ -86,6 +86,10 @@ EXPORT_SYMBOL(journal_invalidatepage);
 EXPORT_SYMBOL(journal_try_to_free_buffers);
 EXPORT_SYMBOL(journal_bmap);
 EXPORT_SYMBOL(journal_force_commit);
+EXPORT_SYMBOL(journal_write_declare);
+
+extern void write_declare_blocks(journal_t *journal,
+			  transaction_t *commit_transaction, int committing);
 
 static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
@@ -156,6 +160,16 @@ loop:
 		journal_commit_transaction(journal);
 		spin_lock(&journal->j_state_lock);
 		goto loop;
+	} else if (journal->j_flags & JFS_DECLARE &&
+		   (transaction = journal->j_running_transaction) &&
+		   transaction->t_declare_request) {
+		jbd_debug(2, "early declare\n");
+		spin_unlock(&journal->j_state_lock);
+		write_declare_blocks(journal, transaction, 0);
+		spin_lock(&journal->j_state_lock);
+
+		wake_up(&journal->j_wait_declare);
+		goto loop;
 	}
 
 	wake_up(&journal->j_wait_done_commit);
@@ -494,6 +508,38 @@ int journal_force_commit_nested(journal_
 }
 
 /*
+ * For ext3_fsync: start a request to declare the file's data and wait
+ * for the declarations to complete.
+ */
+int journal_write_declare(journal_t *journal)
+{
+	transaction_t *transaction = journal->j_running_transaction;
+	DEFINE_WAIT(wait);
+
+	if (transaction == NULL)
+		return 0;
+
+	spin_lock(&journal->j_list_lock);
+
+	if (transaction->t_declare_root.rnode == NULL) {
+		spin_unlock(&journal->j_list_lock);
+		return 0;
+	}
+
+	transaction->t_declare_request = UINT_MAX;
+
+	jbd_debug(1, "waking commit thread for fsync declare\n");
+	wake_up(&journal->j_wait_commit);
+
+	prepare_to_wait(&journal->j_wait_declare, &wait, TASK_INTERRUPTIBLE);
+	spin_unlock(&journal->j_list_lock);
+	schedule();
+	finish_wait(&journal->j_wait_declare, &wait);
+
+	return 0;
+}
+
+/*
  * Start a commit of the current running transaction (if any).  Returns true
  * if a transaction was started, and fills its tid in at *ptid
  */
@@ -959,6 +1005,7 @@ static journal_t * journal_init_common (
 	init_waitqueue_head(&journal->j_wait_checkpoint);
 	init_waitqueue_head(&journal->j_wait_commit);
 	init_waitqueue_head(&journal->j_wait_updates);
+	init_waitqueue_head(&journal->j_wait_declare);
 	mutex_init(&journal->j_barrier);
 	mutex_init(&journal->j_checkpoint_mutex);
 	spin_lock_init(&journal->j_revoke_lock);
@@ -1292,6 +1339,8 @@ static int journal_get_superblock(journa
 
 	J_ASSERT(bh != NULL);
 	if (!buffer_uptodate(bh)) {
+		/* TODO: resync the superblock */
+
 		ll_rw_block(READ, 1, &bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
Index: linux-2.6.18-128.1.6/fs/jbd/recovery.c
===================================================================
--- linux-2.6.18-128.1.6.orig/fs/jbd/recovery.c
+++ linux-2.6.18-128.1.6/fs/jbd/recovery.c
@@ -22,6 +22,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/crc32.h>
+#include <linux/raid/md.h>
 #endif
 
 /*
@@ -36,6 +37,9 @@ struct recovery_info 
 	int		nr_replays;
 	int		nr_revokes;
 	int		nr_revoke_hits;
+	int		nr_declared;
+
+	int		resync_errors;
 };
 
 enum passtype {PASS_SCAN, PASS_REVOKE, PASS_REPLAY};
@@ -43,6 +47,7 @@ static int do_one_pass(journal_t *journa
 				struct recovery_info *info, enum passtype pass);
 static int scan_revoke_records(journal_t *, struct buffer_head *,
 				tid_t, struct recovery_info *);
+static int journal_syncraid(journal_t *, unsigned long);
 
 #ifdef __KERNEL__
 
@@ -53,6 +58,37 @@ void journal_brelse_array(struct buffer_
 		brelse (b[n]);
 }
 
+static int resync_range(journal_t *j, unsigned long start,
+			unsigned long end)
+{
+	int err;
+	struct inode *fake_inode = kmalloc(sizeof(*fake_inode), GFP_KERNEL);
+	mdu_range_t range;
+	sector_t sectors_per_block = j->j_blocksize >> 9;
+	mm_segment_t old_fs;
+
+	if (fake_inode == NULL) {
+		printk(KERN_ERR "JBD: Out of memory during recovery.\n");
+		return -ENOMEM;
+	}
+
+	fake_inode->i_bdev = j->j_fs_dev;
+	range.start = start * sectors_per_block;
+	range.end = end * sectors_per_block + sectors_per_block - 1;
+
+	old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	err = blkdev_driver_ioctl(fake_inode, NULL, j->j_fs_dev->bd_disk,
+				  RESYNC_RANGE, (long)&range);
+	set_fs(old_fs);
+
+	jbd_debug(3, "RESYNC_RANGE of sectors %llu - %llu returned %d\n",
+		  range.start, range.end, err);
+
+	kfree(fake_inode);
+
+	return err;
+}
 
 /*
  * When reading from the journal, we are going through the block device
@@ -67,7 +103,7 @@ void journal_brelse_array(struct buffer_
  */
 
 #define MAXBUF 8
-static int do_readahead(journal_t *journal, unsigned int start)
+static int do_readahead(journal_t *journal, unsigned int start, int raid_sync)
 {
 	int err;
 	unsigned int max, nbufs, next;
@@ -95,6 +131,14 @@ static int do_readahead(journal_t *journ
 			goto failed;
 		}
 
+		/* For declared mode: perform a raid synchronization for the
+		 * journal blocks; this will resync all of the journal blocks
+		 * read, which is more than strictly necessary.
+		 */
+
+		if (raid_sync)
+			resync_range(journal, blocknr, blocknr);
+
 		bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
 		if (!bh) {
 			err = -ENOMEM;
@@ -103,6 +147,7 @@ static int do_readahead(journal_t *journ
 
 		if (!buffer_uptodate(bh) && !buffer_locked(bh)) {
 			bufs[nbufs++] = bh;
+
 			if (nbufs == MAXBUF) {
 				ll_rw_block(READ, nbufs, bufs);
 				journal_brelse_array(bufs, nbufs);
@@ -130,7 +175,7 @@ failed:
  */
 
 static int jread(struct buffer_head **bhp, journal_t *journal, 
-		 unsigned int offset)
+		 unsigned int offset, int sync_raid)
 {
 	int err;
 	unsigned long blocknr;
@@ -159,7 +204,7 @@ static int jread(struct buffer_head **bh
 		/* If this is a brand new buffer, start readahead.
                    Otherwise, we assume we are already reading it.  */
 		if (!buffer_req(bh))
-			do_readahead(journal, offset);
+			do_readahead(journal, offset, sync_raid);
 		wait_on_buffer(bh);
 	}
 
@@ -257,6 +302,30 @@ int journal_recover(journal_t *journal)
 	jbd_debug(0, "JBD: Replayed %d and revoked %d/%d blocks\n", 
 		  info.nr_replays, info.nr_revoke_hits, info.nr_revokes);
 
+	if (!err && !info.resync_errors && JFS_HAS_INCOMPAT_FEATURE(journal,
+					JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS)) {
+		/* Successful declared mode resync: instruct the block device
+		 * to skip its resync */
+		struct inode *fake_inode;
+
+		jbd_debug(0, "JBD: Resynced %d declared blocks\n",
+			  info.nr_declared);
+
+		fake_inode = kmalloc(sizeof(*fake_inode), GFP_KERNEL);
+		if (fake_inode) {
+			fake_inode->i_bdev = journal->j_fs_dev;
+			jbd_debug(1, "Sending SKIP_RESYNC ioctl\n");
+
+			blkdev_driver_ioctl(fake_inode, NULL,
+					    journal->j_fs_dev->bd_disk,
+					    SKIP_RESYNC, 0);
+		}
+		kfree(fake_inode);
+	}
+
+	journal_clear_features(journal, 0, 0,
+			       JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS);
+
 	/* Restart the log at the next transaction ID, thus invalidating
 	 * any existing commit records in the log. */
 	journal->j_transaction_sequence = ++info.end_transaction;
@@ -329,7 +398,7 @@ static int calc_chksums(journal_t *journ
 	for (i = 0; i < num_blks; i++) {
 		io_block = (*next_log_block)++;
 		wrap(journal, *next_log_block);
-		err = jread(&obh, journal, io_block);
+		err = jread(&obh, journal, io_block, 0);
 		if (err) {
 			printk(KERN_ERR "JBD: IO error %d recovering block "
 				"%lu in log\n", err, io_block);
@@ -355,6 +424,7 @@ static int do_one_pass(journal_t *journa
 	unsigned int		sequence;
 	int			blocktype;
 	__u32			crc32_sum = ~0; /* Transactional Checksums */
+	int			raid_sync_journal = 0, raid_sync_data = 0;
 
 	/* Precompute the maximum metadata descriptors in a descriptor block */
 	int			MAX_BLOCKS_PER_DESC;
@@ -397,9 +467,30 @@ static int do_one_pass(journal_t *journa
 		 * check right now that we haven't gone past the end of
 		 * the log. */
 
-		if (pass != PASS_SCAN)
-			if (tid_geq(next_commit_ID, info->end_transaction))
-				break;
+		if (pass != PASS_SCAN) {
+			if (tid_geq(next_commit_ID, info->end_transaction)) {
+				/* For declared mode resync, move ahead past
+				 * the last commmitted transaction to deal with
+				 * raid sync for declare blocks and the head
+				 * of the journal.
+				 */
+				if (pass == PASS_REPLAY &&
+				    JFS_HAS_INCOMPAT_FEATURE(journal,
+					 JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS)) {
+					if (journal->j_fs_dev == journal->j_dev)
+						raid_sync_journal = 1;
+					if (!raid_sync_data)
+						jbd_debug(1, "Declared mode was used; "
+							  "performing raid sync %s\n",
+							  raid_sync_journal ?
+							  "of journal and data" :
+							  "of data");
+					raid_sync_data = 1;
+				}
+				else
+					break;
+			}
+		}
 
 		jbd_debug(2, "Scanning for sequence ID %u at %lu/%lu\n",
 			  next_commit_ID, next_log_block, journal->j_last);
@@ -409,7 +500,7 @@ static int do_one_pass(journal_t *journa
 		 * record. */
 
 		jbd_debug(3, "JBD: checking block %ld\n", next_log_block);
-		err = jread(&bh, journal, next_log_block);
+		err = jread(&bh, journal, next_log_block, raid_sync_journal);
 		if (err)
 			goto failed;
 
@@ -426,6 +517,12 @@ static int do_one_pass(journal_t *journa
 
 		if (tmp->h_magic != cpu_to_be32(JFS_MAGIC_NUMBER)) {
 			brelse(bh);
+
+			/* raid sync the head of the journal */
+			if (raid_sync_journal) {
+				if (journal_syncraid(journal, next_log_block))
+					info->resync_errors++;
+			}
 			break;
 		}
 
@@ -436,6 +533,12 @@ static int do_one_pass(journal_t *journa
 
 		if (sequence != next_commit_ID) {
 			brelse(bh);
+
+			/* raid sync the head of the journal */
+			if (raid_sync_journal) {
+				if (journal_syncraid(journal, next_log_block))
+					info->resync_errors++;
+			}
 			break;
 		}
 
@@ -485,7 +588,8 @@ static int do_one_pass(journal_t *journa
 
 				io_block = next_log_block++;
 				wrap(journal, next_log_block);
-				err = jread(&obh, journal, io_block);
+				err = jread(&obh, journal, io_block,
+					    raid_sync_journal);
 				if (err) {
 					/* Recover what we can, but
 					 * report failure at the end. */
@@ -668,6 +772,42 @@ static int do_one_pass(journal_t *journa
 				goto failed;
 			continue;
 
+		case JFS_DECLARE_BLOCK:
+			if (!raid_sync_data) {
+				brelse(bh);
+				continue;
+			}
+
+			/* this is a declare block for an uncommitted
+			 * transaction, so raid sync all of the blocks it
+			 * describes
+			 */
+
+			tagp = &bh->b_data[sizeof(journal_header_t)];
+			while ((tagp - bh->b_data +sizeof(journal_block_tag_t))
+			       <= journal->j_blocksize) {
+
+				unsigned long blocknr;
+
+				tag = (journal_block_tag_t *) tagp;
+				flags = be32_to_cpu(tag->t_flags);
+				blocknr = be32_to_cpu(tag->t_blocknr);
+
+				if (resync_range(journal, blocknr, blocknr))
+					++info->resync_errors;
+				++info->nr_declared;
+
+				tagp += sizeof(journal_block_tag_t);
+				if (!(flags & JFS_FLAG_SAME_UUID))
+					tagp += 16;
+
+				if (flags & JFS_FLAG_LAST_TAG)
+					break;
+			}
+
+			brelse(bh);
+			continue;
+
 		default:
 			jbd_debug(3, "Unrecognised magic %d, end of scan.\n",
 				  blocktype);
@@ -705,6 +845,38 @@ static int do_one_pass(journal_t *journa
 	return err;
 }
 
+/* RAID sync the next one quarter of the journal.  This is called once at the
+ * end of recovery if declare blocks are present since that part of the journal
+ * was likely undergoing writes before the crash.
+ */
+static int
+journal_syncraid(journal_t *journal, unsigned long next_log_block)
+{
+	int i, err;
+	unsigned long blocknr;
+
+	jbd_debug(2, "RAID resync of 1/4 of the journal starting at %lu\n",
+		  next_log_block);
+
+	for (i = 0; i < journal->j_maxlen / 4; i++) {
+		err = journal_bmap(journal, next_log_block, &blocknr);
+
+		if (err) {
+			printk(KERN_ERR "JBD: bad block at offset %lu\n",
+			       next_log_block);
+			return err;
+		}
+
+		err = resync_range(journal, blocknr, blocknr);
+		if (err)
+			return err;
+
+		next_log_block++;
+		wrap(journal, next_log_block);
+	}
+
+	return 0;
+}
 
 /* Scan a revoke record, marking all blocks mentioned as revoked. */
 
Index: linux-2.6.18-128.1.6/fs/jbd/transaction.c
===================================================================
--- linux-2.6.18-128.1.6.orig/fs/jbd/transaction.c
+++ linux-2.6.18-128.1.6/fs/jbd/transaction.c
@@ -58,6 +58,10 @@ get_transaction(journal_t *journal, tran
 	journal->j_commit_timer.expires = transaction->t_expires;
 	add_timer(&journal->j_commit_timer);
 
+	/* Initialize the declare radix tree */
+	INIT_RADIX_TREE(&transaction->t_declare_root, GFP_ATOMIC);
+	INIT_RADIX_TREE(&transaction->t_declare_done_root, GFP_ATOMIC);
+
 	J_ASSERT(journal->j_running_transaction == NULL);
 	journal->j_running_transaction = transaction;
 	transaction->t_max_wait = 0;
@@ -956,6 +960,7 @@ int journal_dirty_data(handle_t *handle,
 	journal_t *journal = handle->h_transaction->t_journal;
 	int need_brelse = 0;
 	struct journal_head *jh;
+	int jdatalist;
 
 	if (is_handle_aborted(handle))
 		return 0;
@@ -999,6 +1004,8 @@ int journal_dirty_data(handle_t *handle,
 		goto no_journal;
 	}
 
+	jdatalist = journal->j_flags & JFS_DECLARE ? BJ_Declare : BJ_SyncData;
+
 	if (jh->b_transaction) {
 		JBUFFER_TRACE(jh, "has transaction");
 		if (jh->b_transaction != handle->h_transaction) {
@@ -1041,6 +1048,8 @@ int journal_dirty_data(handle_t *handle,
 			 */
 			if (jh->b_jlist != BJ_None &&
 					jh->b_jlist != BJ_SyncData &&
+					jh->b_jlist != BJ_Declare &&
+					jh->b_jlist != BJ_DeclareDone &&
 					jh->b_jlist != BJ_Locked) {
 				JBUFFER_TRACE(jh, "Not stealing");
 				goto no_journal;
@@ -1088,18 +1097,19 @@ int journal_dirty_data(handle_t *handle,
 		 * committing transaction, so might still be left on that
 		 * transaction's metadata lists.
 		 */
-		if (jh->b_jlist != BJ_SyncData && jh->b_jlist != BJ_Locked) {
+		if (jh->b_jlist != BJ_SyncData && jh->b_jlist != BJ_Declare &&
+		    jh->b_jlist != BJ_DeclareDone && jh->b_jlist != BJ_Locked) {
 			JBUFFER_TRACE(jh, "not on correct data list: unfile");
 			J_ASSERT_JH(jh, jh->b_jlist != BJ_Shadow);
 			__journal_temp_unlink_buffer(jh);
 			jh->b_transaction = handle->h_transaction;
 			JBUFFER_TRACE(jh, "file as data");
 			__journal_file_buffer(jh, handle->h_transaction,
-						BJ_SyncData);
+						jdatalist);
 		}
 	} else {
 		JBUFFER_TRACE(jh, "not on a transaction");
-		__journal_file_buffer(jh, handle->h_transaction, BJ_SyncData);
+		__journal_file_buffer(jh, handle->h_transaction, jdatalist);
 	}
 no_journal:
 	spin_unlock(&journal->j_list_lock);
@@ -1578,6 +1588,7 @@ void __journal_temp_unlink_buffer(struct
 	struct journal_head **list = NULL;
 	transaction_t *transaction;
 	struct buffer_head *bh = jh2bh(jh);
+	struct radix_tree_root *root = NULL;
 
 	J_ASSERT_JH(jh, jbd_is_locked_bh_state(bh));
 	transaction = jh->b_transaction;
@@ -1617,9 +1628,25 @@ void __journal_temp_unlink_buffer(struct
 	case BJ_Locked:
 		list = &transaction->t_locked_list;
 		break;
+	case BJ_Declare:
+		root = &transaction->t_declare_root;
+		transaction->t_declare_count--;
+		break;
+	case BJ_DeclareDone:
+		root = &transaction->t_declare_done_root;
+		break;
+	}
+
+	if (jh->b_jlist == BJ_Declare || jh->b_jlist == BJ_DeclareDone) {
+		if ((radix_tree_delete(root, bh->b_blocknr)) != jh) {
+			printk(KERN_ERR
+				"jbd: ERROR radix tree delete block %8llu\n",
+				(unsigned long long)bh->b_blocknr);
+		}
 	}
+	else
+		__blist_del_buffer(list, jh);
 
-	__blist_del_buffer(list, jh);
 	jh->b_jlist = BJ_None;
 	if (test_clear_buffer_jbddirty(bh))
 		mark_buffer_dirty(bh);	/* Expose it to the VM */
@@ -1660,7 +1687,8 @@ __journal_try_to_free_buffer(journal_t *
 
 	spin_lock(&journal->j_list_lock);
 	if (jh->b_transaction != 0 && jh->b_cp_transaction == 0) {
-		if (jh->b_jlist == BJ_SyncData || jh->b_jlist == BJ_Locked) {
+		if (jh->b_jlist == BJ_SyncData || jh->b_jlist == BJ_Declare ||
+		    jh->b_jlist == BJ_DeclareDone || jh->b_jlist == BJ_Locked) {
 			/* A written-back ordered data buffer */
 			JBUFFER_TRACE(jh, "release data");
 			__journal_unfile_buffer(jh);
@@ -2072,6 +2100,8 @@ void __journal_file_buffer(struct journa
 	struct journal_head **list = NULL;
 	int was_dirty = 0;
 	struct buffer_head *bh = jh2bh(jh);
+	struct radix_tree_root *root = NULL;
+	int declare_per_block;
 
 	J_ASSERT_JH(jh, jbd_is_locked_bh_state(bh));
 	assert_spin_locked(&transaction->t_journal->j_list_lock);
@@ -2126,15 +2156,44 @@ void __journal_file_buffer(struct journa
 		list = &transaction->t_reserved_list;
 		break;
 	case BJ_Locked:
-		list =  &transaction->t_locked_list;
+		list = &transaction->t_locked_list;
+		break;
+	case BJ_Declare:
+		root = &transaction->t_declare_root;
+		transaction->t_declare_count++;
 		break;
+	case BJ_DeclareDone:
+		root = &transaction->t_declare_done_root;
+		break;
+	}
+
+	if (jlist == BJ_Declare || jlist == BJ_DeclareDone) {
+		if ((radix_tree_insert(root, bh->b_blocknr, jh)) != 0) {
+			printk(KERN_ERR
+				"jbd: ERROR radix tree insert block %8lu\n",
+				(long unsigned)bh->b_blocknr);
+		}
+	} else {
+		__blist_add_buffer(list, jh);
 	}
 
-	__blist_add_buffer(list, jh);
 	jh->b_jlist = jlist;
 
 	if (was_dirty)
 		set_buffer_jbddirty(bh);
+
+	declare_per_block = (bh->b_size - (sizeof(journal_header_t) + 32)) /
+		sizeof(journal_block_tag_t);
+
+	/* wake up the commit thread to perform early declarations */
+	assert_spin_locked(&transaction->t_journal->j_list_lock);
+	if (transaction->t_journal->j_flags & JFS_DECLARE &&
+			jlist == BJ_Declare &&
+			transaction->t_declare_count >= declare_per_block) {
+		transaction->t_declare_request = transaction->t_declare_count /
+			declare_per_block * declare_per_block;
+		wake_up(&transaction->t_journal->j_wait_commit);
+	}
 }
 
 void journal_file_buffer(struct journal_head *jh,
Index: linux-2.6.18-128.1.6/include/linux/jbd.h
===================================================================
--- linux-2.6.18-128.1.6.orig/include/linux/jbd.h
+++ linux-2.6.18-128.1.6/include/linux/jbd.h
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/buffer_head.h>
 #include <linux/journal-head.h>
+#include <linux/radix-tree.h>
 #include <linux/stddef.h>
 #include <linux/bit_spinlock.h>
 #include <linux/mutex.h>
@@ -137,6 +138,7 @@ typedef struct journal_s	journal_t;	/* J
 #define JFS_SUPERBLOCK_V1	3
 #define JFS_SUPERBLOCK_V2	4
 #define JFS_REVOKE_BLOCK	5
+#define JFS_DECLARE_BLOCK	6
 
 /*
  * Standard header for all descriptor blocks:
@@ -261,12 +263,14 @@ typedef struct journal_superblock_s
 
 #define JFS_FEATURE_INCOMPAT_REVOKE		0x00000001
 #define JFS_FEATURE_INCOMPAT_ASYNC_COMMIT    	0x00000004
+#define JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS    	0x00000008
 
 /* Features known to this kernel version: */
 #define JFS_KNOWN_COMPAT_FEATURES	JFS_FEATURE_COMPAT_CHECKSUM
 #define JFS_KNOWN_ROCOMPAT_FEATURES	0
 #define JFS_KNOWN_INCOMPAT_FEATURES	(JFS_FEATURE_INCOMPAT_REVOKE | \
-					JFS_FEATURE_INCOMPAT_ASYNC_COMMIT)
+					JFS_FEATURE_INCOMPAT_ASYNC_COMMIT | \
+					JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS)
 
 #ifdef __KERNEL__
 
@@ -559,6 +563,15 @@ struct transaction_s 
 	struct journal_head	*t_sync_datalist;
 
 	/*
+	 * Radix tree of all data buffers that must be declared before being
+	 * written, declare mode counters [j_list_lock]
+	 */
+	struct radix_tree_root	 t_declare_root;
+	struct radix_tree_root	 t_declare_done_root;
+	unsigned int		 t_declare_count;
+	unsigned int		 t_declare_request;
+
+	/*
 	 * Doubly-linked circular list of all forget buffers (superseded
 	 * buffers which we can un-checkpoint once this transaction commits)
 	 * [j_list_lock]
@@ -730,6 +743,7 @@ jbd_time_diff(unsigned int start, unsign
  * @j_wait_checkpoint:  Wait queue to trigger checkpointing
  * @j_wait_commit: Wait queue to trigger commit
  * @j_wait_updates: Wait queue to wait for updates to complete
+ * @j_wait_declare: Wait queue to wait for declarations to complete
  * @j_checkpoint_mutex: Mutex for locking against concurrent checkpoints
  * @j_head: Journal head - identifies the first unused block in the journal
  * @j_tail: Journal tail - identifies the oldest still-used block in the
@@ -768,6 +782,8 @@ jbd_time_diff(unsigned int start, unsign
  * @j_wbufsize: maximum number of buffer_heads allowed in j_wbuf, the
  *	number that will fit in j_blocksize
  * @j_last_sync_writer: most recent pid which did a synchronous write
+ * @j_declare_jhs: array of journal_heads for write_declare_blocks
+ * @j_declare_bhs: array of buffer_heads for write_declare_blocks
  * @j_private: An opaque pointer to fs-private information.
  */
 
@@ -841,6 +857,9 @@ struct journal_s
 	/* Wait queue to wait for updates to complete */
 	wait_queue_head_t	j_wait_updates;
 
+	/* Wait queue to wait for declarations to complete */
+	wait_queue_head_t	j_wait_declare;
+
 	/* Semaphore for locking against concurrent checkpoints */
 	struct mutex	 	j_checkpoint_mutex;
 
@@ -970,6 +989,13 @@ struct journal_s
 	struct transaction_stats_s j_stats;
 
 	/*
+	 * Arrays of jhs and bhs for write_declare_blocks, to avoid
+	 * having to allocate them each time.
+	 */
+	void			*j_declare_jhs[64];
+	struct buffer_head	*j_declare_bhs[64];
+
+	/*
 	 * An opaque pointer to fs-private information.  ext3 puts its
 	 * superblock pointer here
 	 */
@@ -985,6 +1011,7 @@ struct journal_s
 #define JFS_FLUSHED	0x008	/* The journal superblock has been flushed */
 #define JFS_LOADED	0x010	/* The journal superblock has been loaded */
 #define JFS_BARRIER	0x020	/* Use IDE barriers */
+#define JFS_DECLARE	0x040	/* Declare data blocks before writing */
 
 /* 
  * Function declarations for the journaling transaction and buffer
@@ -1100,6 +1127,7 @@ extern void	   journal_ack_err    (journ
 extern int	   journal_clear_err  (journal_t *);
 extern int	   journal_bmap(journal_t *, unsigned long, unsigned long *);
 extern int	   journal_force_commit(journal_t *);
+extern int	   journal_write_declare(journal_t *);
 
 /*
  * journal_head management
@@ -1244,7 +1272,9 @@ static inline int jbd_space_needed(journ
 #define BJ_LogCtl	6	/* Buffer contains log descriptors */
 #define BJ_Reserved	7	/* Buffer is reserved for access by journal */
 #define BJ_Locked	8	/* Locked for I/O during commit */
-#define BJ_Types	9
+#define BJ_Declare	9	/* Needs to be declared first */
+#define BJ_DeclareDone	10	/* Has been declared */
+#define BJ_Types	11
  
 extern int jbd_blocks_per_page(struct inode *inode);
 

-- 
