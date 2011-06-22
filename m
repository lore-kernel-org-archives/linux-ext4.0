From: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Subject: Re: Help required for Debugging JBD
Date: Wed, 22 Jun 2011 23:57:58 +0530
Message-ID: <4E02342E.4060203@gmail.com>
References: <4E00CC36.80707@gmail.com> <BANLkTimhig+_Lb52KMcRyk5S4YQcdYozVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080207040903020202060909"
Cc: linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47187 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab1FVSac (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2011 14:30:32 -0400
Received: by pwj7 with SMTP id 7so763277pwj.19
        for <linux-ext4@vger.kernel.org>; Wed, 22 Jun 2011 11:30:31 -0700 (PDT)
In-Reply-To: <BANLkTimhig+_Lb52KMcRyk5S4YQcdYozVg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080207040903020202060909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
      Thanks for that SysRq tip. Now I am able to get some logs.

 From OOPS message, it showed an assertion failure on
     J_ASSERT_JH(jh, jh->b_transaction == 
journal->j_committing_transaction);

In my code, I've modified journal_commit_transaction such that it 
collects all buffer_head in a linked list, with their corresponding
buffer numbers in other list.
      I collect all buffers (data + metadata ) and push them all 
simultaneously and pass list of block numbers through a special ioctl call.

The problem that I see in my code is that all buffers are handled in 
same way as all data buffers in original code. ie metadata buffers are
getting unfiled instead of refiling.

I am attaching my patch. Please can you see and check if that indeed is 
problem here?

Also what can be possible solution to it? separation of buffers in 2 
list (data, metadata) and handling them separately?

(Being a kernel noob, my coding does not conform to any standard. So 
please point out any blunders I've committed in my patch)

Thank You
Niraj

--------------080207040903020202060909
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch"

diff -ur ./commit.c /home/srimugunthan/niraj/linux_kernel/linux-2.6.38.6/fs/jbd/commit.c
--- ./commit.c	2011-05-10 03:46:23.000000000 +0530
+++ /home/srimugunthan/niraj/linux_kernel/linux-2.6.38.6/fs/jbd/commit.c	2011-06-22 22:53:39.641366902 +0530
@@ -21,6 +21,17 @@
 #include <linux/pagemap.h>
 #include <linux/bio.h>
 
+#include <linux/mtd/blktrans.h>
+#ifdef TXFLASH
+#include <linux/genhd.h>
+#include <linux/blkdev.h>
+#endif
+
+struct BLK_CHAIN{
+	struct list_head list;
+	struct buffer_head *bh;
+};
+static struct BLK_CHAIN blk_chain;
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
  */
@@ -152,11 +163,10 @@
 				   int write_op)
 {
 	int i;
 	for (i = 0; i < bufs; i++) {
 		wbuf[i]->b_end_io = end_buffer_write_sync;
 		/* We use-up our safety reference in submit_bh() */
-		submit_bh(write_op, wbuf[i]);
+		//submit_bh(write_op, wbuf[i]);
 	}
 }
 
@@ -165,7 +175,12 @@
  */
 static int journal_submit_data_buffers(journal_t *journal,
 				       transaction_t *commit_transaction,
-				       int write_op)
+				       int write_op
+#ifdef TXFLASH
+				       ,struct mtd_flash_txn *mytxn,int *data_cnt
+#endif				       
+				       )
+				       
 {
 	struct journal_head *jh;
 	struct buffer_head *bh;
@@ -173,6 +188,10 @@
 	int bufs = 0;
 	struct buffer_head **wbuf = journal->j_wbuf;
 	int err = 0;
+#ifdef TXFLASH	
+	struct mtd_txn_blk *new_entry=NULL;
+	struct BLK_CHAIN *new_blk_entry=NULL;
+#endif				       	
 
 	/*
 	 * Whenever we unlock the journal and sleep, things can get added
@@ -200,11 +220,24 @@
 		 * blocking lock_buffer().
 		 */
 		if (buffer_dirty(bh)) {
-			if (!trylock_buffer(bh)) {
+#ifdef TXFLASH			
+			{ 
+				BUFFER_TRACE(bh, "needs blocking lock");
+				spin_unlock(&journal->j_list_lock);
+				/* Write out all data to prevent deadlocks */
+				if(bufs>0)
+					journal_do_submit_data(wbuf, bufs, write_op);
+				if(!new_entry)
+					new_entry=(struct mtd_txn_blk *)kzalloc(sizeof(struct mtd_txn_blk),GFP_KERNEL);
+				if(!new_blk_entry)
+					new_blk_entry=(struct BLK_CHAIN *)kzalloc(sizeof(struct BLK_CHAIN),GFP_KERNEL);
+#else		
+			if (!trylock_buffer(bh)) { 
 				BUFFER_TRACE(bh, "needs blocking lock");
 				spin_unlock(&journal->j_list_lock);
 				/* Write out all data to prevent deadlocks */
 				journal_do_submit_data(wbuf, bufs, write_op);
+#endif			
 				bufs = 0;
 				lock_buffer(bh);
 				spin_lock(&journal->j_list_lock);
@@ -230,6 +263,21 @@
 		if (locked && test_clear_buffer_dirty(bh)) {
 			BUFFER_TRACE(bh, "needs writeout, adding to array");
 			wbuf[bufs++] = bh;
+#ifdef TXFLASH
+			(*data_cnt)++;
+			if(new_entry){
+				new_entry->blk_no=bh->b_blocknr;
+				list_add_tail(&(new_entry->list),&(mytxn->blks));
+				new_entry=NULL;
+				jbd_debug(3, "JBD submit data buffer at insertion point %lX of size %lX\n",bh->b_blocknr,bh->b_size);
+			}
+			if(new_blk_entry)
+			{
+				new_blk_entry->bh=bh;
+				list_add_tail(&(new_blk_entry->list),&(blk_chain.list));
+				new_blk_entry=NULL;
+			}
+#endif			
 			__journal_file_buffer(jh, commit_transaction,
 						BJ_Locked);
 			jbd_unlock_bh_state(bh);
@@ -265,11 +313,14 @@
 		}
 	}
 	spin_unlock(&journal->j_list_lock);
 	journal_do_submit_data(wbuf, bufs, write_op);
 
 	return err;
 }
 
+
+#ifndef TXFLASH
 /*
  * journal_commit_transaction
  *
@ -952,3 +1006,786 @@
 
 	wake_up(&journal->j_wait_done_commit);
 }
+#else
+/*
+ * Transactional Version
+ */
+void journal_commit_transaction(journal_t *journal)
+{
+	transaction_t *commit_transaction;
+	struct journal_head *jh, *new_jh, *descriptor;
+	struct buffer_head **wbuf = journal->j_wbuf;
+	int bufs;
+	int flags;
+	int err;
+	unsigned int blocknr;
+	ktime_t start_time;
+	u64 commit_time;
+	char *tagp = NULL;
+	journal_header_t *header;
+	journal_block_tag_t *tag = NULL;
+	int space_left = 0;
+	int first_tag = 0;
+	int tag_flag;
+	int i;
+	int write_op = WRITE_SYNC;
+
+	struct mtd_flash_txn *mytxn;
+	struct mtd_txn_blk *pos,*tmp_pos;
+	struct BLK_CHAIN *new_blk_pos,*tmp_blk_pos;
+	int descriptor_counter,data_counter,meta_counter;
+	struct buffer_head *my_desc_buf=NULL;
+	/*
+	 * First job: lock down the current transaction and wait for
+	 * all outstanding updates to complete.
+	 */
+	 
+	descriptor_counter=0;
+	data_counter=0;
+	meta_counter=0;
+#ifdef COMMIT_STATS
+	spin_lock(&journal->j_list_lock);
+	summarise_journal_usage(journal);
+	spin_unlock(&journal->j_list_lock);
+#endif
+
+	/* Do we need to erase the effects of a prior journal_flush? */
+	if (journal->j_flags & JFS_FLUSHED) {
+		jbd_debug(3, "super block updated\n");
+		journal_update_superblock(journal, 1);
+	} else {
+		jbd_debug(3, "superblock not updated\n");
+	}
+
+	J_ASSERT(journal->j_running_transaction != NULL);
+	J_ASSERT(journal->j_committing_transaction == NULL);
+
+	commit_transaction = journal->j_running_transaction;
+	J_ASSERT(commit_transaction->t_state == T_RUNNING);
+
+	jbd_debug(1, "JBD: starting commit of transaction %d\n",
+			commit_transaction->t_tid);
+
+	mytxn=(struct mtd_flash_txn*)kmalloc(sizeof(struct mtd_flash_txn),GFP_KERNEL);
+	INIT_LIST_HEAD(&(mytxn->blks));		
+	mytxn->txn_number=commit_transaction->t_tid;
+	mytxn->bh_size=0;
+	
+	INIT_LIST_HEAD(&(blk_chain.list));		
+	blk_chain.bh=0;
+	
+	
+	spin_lock(&journal->j_state_lock);
+	commit_transaction->t_state = T_LOCKED;
+
+	/*
+	 * Use plugged writes here, since we want to submit several before
+	 * we unplug the device. We don't do explicit unplugging in here,
+	 * instead we rely on sync_buffer() doing the unplug for us.
+	 */
+	if (commit_transaction->t_synchronous_commit)
+		write_op = WRITE_SYNC_PLUG;
+	spin_lock(&commit_transaction->t_handle_lock);
+	while (commit_transaction->t_updates) {
+		DEFINE_WAIT(wait);
+
+		prepare_to_wait(&journal->j_wait_updates, &wait,
+					TASK_UNINTERRUPTIBLE);
+		if (commit_transaction->t_updates) {
+			spin_unlock(&commit_transaction->t_handle_lock);
+			spin_unlock(&journal->j_state_lock);
+			schedule();
+			spin_lock(&journal->j_state_lock);
+			spin_lock(&commit_transaction->t_handle_lock);
+		}
+		finish_wait(&journal->j_wait_updates, &wait);
+	}
+	spin_unlock(&commit_transaction->t_handle_lock);
+
+	J_ASSERT (commit_transaction->t_outstanding_credits <=
+			journal->j_max_transaction_buffers);
+
+	/*
+	 * First thing we are allowed to do is to discard any remaining
+	 * BJ_Reserved buffers.  Note, it is _not_ permissible to assume
+	 * that there are no such buffers: if a large filesystem
+	 * operation like a truncate needs to split itself over multiple
+	 * transactions, then it may try to do a journal_restart() while
+	 * there are still BJ_Reserved buffers outstanding.  These must
+	 * be released cleanly from the current transaction.
+	 *
+	 * In this case, the filesystem must still reserve write access
+	 * again before modifying the buffer in the new transaction, but
+	 * we do not require it to remember exactly which old buffers it
+	 * has reserved.  This is consistent with the existing behaviour
+	 * that multiple journal_get_write_access() calls to the same
+	 * buffer are perfectly permissable.
+	 */
+	while (commit_transaction->t_reserved_list) {
+		jh = commit_transaction->t_reserved_list;
+		JBUFFER_TRACE(jh, "reserved, unused: refile");
+		/*
+		 * A journal_get_undo_access()+journal_release_buffer() may
+		 * leave undo-committed data.
+		 */
+		if (jh->b_committed_data) {
+			struct buffer_head *bh = jh2bh(jh);
+
+			jbd_lock_bh_state(bh);
+			jbd_free(jh->b_committed_data, bh->b_size);
+			jh->b_committed_data = NULL;
+			jbd_unlock_bh_state(bh);
+		}
+		journal_refile_buffer(journal, jh);
+	}
+
+	/*
+	 * Now try to drop any written-back buffers from the journal's
+	 * checkpoint lists.  We do this *before* commit because it potentially
+	 * frees some memory
+	 */
+	spin_lock(&journal->j_list_lock);
+	__journal_clean_checkpoint_list(journal);
+	spin_unlock(&journal->j_list_lock);
+
+	jbd_debug (3, "JBD: commit phase 1\n");
+
+	/*
+	 * Switch to a new revoke table.
+	 */
+	journal_switch_revoke_table(journal);
+
+	commit_transaction->t_state = T_FLUSH;
+	journal->j_committing_transaction = commit_transaction;
+	journal->j_running_transaction = NULL;
+	start_time = ktime_get();
+	commit_transaction->t_log_start = journal->j_head;
+	wake_up(&journal->j_wait_transaction_locked);
+	spin_unlock(&journal->j_state_lock);
+
+
+	
+
+	jbd_debug (3, "JBD: commit phase 2\n");
+
+	/*
+	 * Now start flushing things to disk, in the order they appear
+	 * on the transaction lists.  Data blocks go first.
+	 */
+	err = journal_submit_data_buffers(journal, commit_transaction,
+					  write_op,mytxn,&data_counter);
+
+	/*list_for_each_entry(pos,&mytxn.blks,list)
+	{
+		jbd_debug(3,"in jrnl commit blk no %lX",pos->blk_no);
+			
+	}*/
+	//journal->j_dev->bd_disk->fops->ioctl(journal->j_dev,0777,CYCLIC_COMMIT,(unsigned long )&mytxn);
+	
+#if 0	
+	journal_write_revoke_records(journal, commit_transaction, write_op);
+#endif
+	/*
+	 * Wait for all previously submitted IO to complete.
+	 */
+	 
+
+	jbd_debug (3, "JBD: commit phase 3\n");
+
+	/*
+	 * Way to go: we have now written out all of the data for a
+	 * transaction!  Now comes the tricky part: we need to write out
+	 * metadata.  Loop over the transaction's entire buffer list:
+	 */
+	spin_lock(&journal->j_state_lock);
+	commit_transaction->t_state = T_COMMIT;
+	spin_unlock(&journal->j_state_lock);
+
+	J_ASSERT(commit_transaction->t_nr_buffers <=
+		 commit_transaction->t_outstanding_credits);
+
+	descriptor = NULL;
+	bufs = 0;
+	pos=NULL;
+	new_blk_pos=NULL;
+	while (commit_transaction->t_buffers) {
+
+		/* Find the next buffer to be journaled... */
+
+		jh = commit_transaction->t_buffers;
+
+		if(!pos)
+			pos=(struct mtd_txn_blk*)kzalloc(sizeof(struct mtd_txn_blk),GFP_KERNEL);
+		if(!new_blk_pos)
+			new_blk_pos=(struct BLK_CHAIN *)kzalloc(sizeof(struct BLK_CHAIN),GFP_KERNEL);
+
+		/* If we're in abort mode, we just un-journal the buffer and
+		   release it. */
+
+		if (is_journal_aborted(journal)) {
+			clear_buffer_jbddirty(jh2bh(jh));
+			JBUFFER_TRACE(jh, "journal is aborting: refile");
+			journal_refile_buffer(journal, jh);
+			/* If that was the last one, we need to clean up
+			 * any descriptor buffers which may have been
+			 * already allocated, even if we are now
+			 * aborting. */
+			if (!commit_transaction->t_buffers)
+				goto start_journal_io;
+			continue;
+		}
+
+		/* Make sure we have a descriptor block in which to
+		   record the metadata buffer. */
+			/*Obselete for TXFLASH */
+#if 0
+		if (!descriptor) {
+			struct buffer_head *bh;
+
+			J_ASSERT (bufs == 0);
+
+			jbd_debug(4, "JBD: get descriptor\n");
+
+			descriptor = journal_get_descriptor_buffer(journal);
+			if (!descriptor) {
+				journal_abort(journal, -EIO);
+				continue;
+			}
+
+			bh = jh2bh(descriptor);
+			jbd_debug(4, "JBD: got buffer %llu %llX (%p)\n",
+				(unsigned long long)bh->b_blocknr,
+				(unsigned long long)bh->b_blocknr, bh->b_data);
+			header = (journal_header_t *)&bh->b_data[0];
+			header->h_magic     = cpu_to_be32(JFS_MAGIC_NUMBER);
+			header->h_blocktype = cpu_to_be32(JFS_DESCRIPTOR_BLOCK);
+			header->h_sequence  = cpu_to_be32(commit_transaction->t_tid);
+
+			tagp = &bh->b_data[sizeof(journal_header_t)];
+			space_left = bh->b_size - sizeof(journal_header_t);
+			first_tag = 1;
+			set_buffer_jwrite(bh);
+			set_buffer_dirty(bh);
+			wbuf[bufs++] = bh;
+			my_desc_buf=bh;
+			
+			descriptor_counter++;
+			/* Record it so that we can wait for IO
+                           completion later */
+			BUFFER_TRACE(bh, "ph3: file as descriptor");
+			journal_file_buffer(descriptor, commit_transaction,
+					BJ_LogCtl);
+		}
+#endif
+		/* Where is the buffer to be written? */
+#if 0
+		err = journal_next_log_block(journal, &blocknr);
+		/* If the block mapping failed, just abandon the buffer
+		   and repeat this loop: we'll fall into the
+		   refile-on-abort condition above. */
+		if (err) {
+			journal_abort(journal, err);
+			continue;
+		}
+#endif
+		/*
+		 * start_this_handle() uses t_outstanding_credits to determine
+		 * the free space in the log, but this counter is changed
+		 * by journal_next_log_block() also.
+		 */
+		commit_transaction->t_outstanding_credits--;
+
+		/* Bump b_count to prevent truncate from stumbling over
+                   the shadowed buffer!  @@@ This can go if we ever get
+                   rid of the BJ_IO/BJ_Shadow pairing of buffers. */
+		get_bh(jh2bh(jh));
+
+		/* Make a temporary IO buffer with which to write it out
+                   (this will requeue both the metadata buffer and the
+                   temporary IO buffer). new_bh goes on BJ_IO*/
+
+		set_buffer_jwrite(jh2bh(jh));
+		/*
+		 * akpm: journal_write_metadata_buffer() sets
+		 * new_bh->b_transaction to commit_transaction.
+		 * We need to clean this up before we release new_bh
+		 * (which is of type BJ_IO)
+		 */
+		JBUFFER_TRACE(jh, "ph3: write metadata");
+#if 0		
+		flags = journal_write_metadata_buffer(commit_transaction,
+						      jh, &new_jh, blocknr);
+#endif						      
+		journal_file_buffer(jh,commit_transaction,BJ_Locked);
+		set_buffer_jwrite(jh2bh(jh));
+		wbuf[bufs++] = jh2bh(jh);
+		meta_counter++;
+		
+		if(!mytxn->bh_size)
+		{
+				mytxn->bh_size=(jh2bh(jh))->b_size;
+		}
+		
+		if(pos){
+             pos->blk_no=(jh2bh(jh))->b_blocknr;
+             list_add_tail(&(pos->list),&(mytxn->blks));
+             pos=NULL;
+             jbd_debug(3, "JBD submit metadata buffer at insertion point %lX of size %lX\n",(jh2bh(jh))->b_blocknr,(jh2bh(jh))->b_size);
+         }
+         if(new_blk_pos)
+         {
+			 new_blk_pos->bh=(jh2bh(jh));
+			 list_add_tail(&(new_blk_pos->list),&(blk_chain.list));
+			 new_blk_pos=NULL;
+		 }
+
+
+		/* Record the new block's tag in the current descriptor
+                   buffer */
+
+#if 0		
+		tag_flag = 0;
+		if (flags & 1)
+			tag_flag |= JFS_FLAG_ESCAPE;
+		if (!first_tag)
+			tag_flag |= JFS_FLAG_SAME_UUID;
+
+		tag = (journal_block_tag_t *) tagp;
+		tag->t_blocknr = cpu_to_be32(jh2bh(jh)->b_blocknr);
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
+#endif		
+		/* If there's no more to do, or if the descriptor is full,
+		   let the IO rip! */
+
+		if (bufs == journal->j_wbufsize ||
+		    commit_transaction->t_buffers == NULL 
+#if 0		    
+		    /*||
+		    space_left < sizeof(journal_block_tag_t) + 16*/
+#endif		    
+		    ) {
+
+			jbd_debug(4, "JBD: Submit %d IOs\n", bufs);
+
+			/* Write an end-of-descriptor marker before
+                           submitting the IOs.  "tag" still points to
+                           the last tag we set up. */
+#if 0
+			tag->t_flags |= cpu_to_be32(JFS_FLAG_LAST_TAG);
+#endif			
+			/* nk : Submit descriptor buffer now only since not recorded in blk chain*/
+			
+			
+start_journal_io:
+			for (i = 0; i < bufs; i++) {
+				struct buffer_head *bh = wbuf[i];
+				lock_buffer(bh);
+				clear_buffer_dirty(bh);
+				set_buffer_uptodate(bh);
+				bh->b_end_io = journal_end_buffer_io_sync;
+				jbd_debug(3, "JBD: submitting metadata buffer %lX of size %lX",bh->b_blocknr,bh->b_size);
+#if 0
+				submit_bh(write_op, bh);
+#endif
+			}
+#if 0			
+			submit_bh(write_op, my_desc_buf);
+#endif			
+			cond_resched();
+
+			/* Force a new descriptor to be generated next
+                           time round the loop. */
+			descriptor = NULL;
+			bufs = 0;
+		}
+	}
+	/* nk : Send txn first and then buffer */
+	jbd_debug(1, "JBD: submitting TXFLASH\n");
+	journal->j_dev->bd_disk->fops->ioctl(journal->j_dev,0777,CYCLIC_COMMIT,(unsigned long )mytxn);
+	list_for_each_entry_safe(new_blk_pos,tmp_blk_pos,&(blk_chain.list),list)
+	{
+		submit_bh(write_op,new_blk_pos->bh);
+		list_del(&(new_blk_pos->list));
+		kfree(new_blk_pos);
+			
+	}
+	jbd_debug(3, "JBD: submitted %d descriptors %d data and %d metadata totalling %d and 1 commit record\n", descriptor_counter
+				,data_counter,meta_counter,descriptor_counter+data_counter+meta_counter);
+	/* Lo and behold: we have just managed to send a transaction to
+           the log.  Before we can commit it, wait for the IO so far to
+           complete.  Control buffers being written are on the
+           transaction's t_log_list queue, and metadata buffers are on
+           the t_iobuf_list queue.
+
+	   Wait for the buffers in reverse order.  That way we are
+	   less likely to be woken up until all IOs have completed, and
+	   so we incur less scheduling load.
+	*/
+/*****************************************************************************************/
+	spin_lock(&journal->j_list_lock);
+	while (commit_transaction->t_locked_list) {
+		struct buffer_head *bh;
+
+		jh = commit_transaction->t_locked_list->b_tprev;
+		bh = jh2bh(jh);
+		get_bh(bh);
+		if (buffer_locked(bh)) {
+			spin_unlock(&journal->j_list_lock);
+			wait_on_buffer(bh);
+			spin_lock(&journal->j_list_lock);
+		}
+		if (unlikely(!buffer_uptodate(bh))) {
+			if (!trylock_page(bh->b_page)) {
+				spin_unlock(&journal->j_list_lock);
+				lock_page(bh->b_page);
+				spin_lock(&journal->j_list_lock);
+			}
+			if (bh->b_page->mapping)
+				set_bit(AS_EIO, &bh->b_page->mapping->flags);
+
+			unlock_page(bh->b_page);
+			SetPageError(bh->b_page);
+			err = -EIO;
+		}
+		if (!inverted_lock(journal, bh)) {
+			put_bh(bh);
+			spin_lock(&journal->j_list_lock);
+			continue;
+		}
+		if (buffer_jbd(bh) && bh2jh(bh) == jh &&
+		    jh->b_transaction == commit_transaction &&
+		    jh->b_jlist == BJ_Locked) {
+			__journal_unfile_buffer(jh);
+			jbd_unlock_bh_state(bh);
+			journal_remove_journal_head(bh);
+			put_bh(bh);
+		} else {
+			jbd_unlock_bh_state(bh);
+		}
+		release_data_buffer(bh);
+		cond_resched_lock(&journal->j_list_lock);
+	}
+	spin_unlock(&journal->j_list_lock);
+
+	if (err) {
+		char b[BDEVNAME_SIZE];
+
+		printk(KERN_WARNING
+			"JBD: Detected IO errors while flushing file data "
+			"on %s\n", bdevname(journal->j_fs_dev, b));
+		if (journal->j_flags & JFS_ABORT_ON_SYNCDATA_ERR)
+			journal_abort(journal, err);
+		err = 0;
+	}
+
+	
+
+	/*
+	 * If we found any dirty or locked buffers, then we should have
+	 * looped back up to the write_out_data label.  If there weren't
+	 * any then journal_clean_data_list should have wiped the list
+	 * clean by now, so check that it is in fact empty.
+	 */
+	J_ASSERT (commit_transaction->t_sync_datalist == NULL);
+/**************************************************************************************** */
+	
+
+	jbd_debug(3, "JBD: commit phase 4\n");
+
+	/*
+	 * akpm: these are BJ_IO, and j_list_lock is not needed.
+	 * See __journal_try_to_free_buffer.
+	 */
+#if 0	 
+wait_for_iobuf:
+	while (commit_transaction->t_iobuf_list != NULL) {
+		struct buffer_head *bh;
+
+		jh = commit_transaction->t_iobuf_list->b_tprev;
+		bh = jh2bh(jh);
+		if (buffer_locked(bh)) {
+			wait_on_buffer(bh);
+			goto wait_for_iobuf;
+		}
+		if (cond_resched())
+			goto wait_for_iobuf;
+
+		if (unlikely(!buffer_uptodate(bh)))
+			err = -EIO;
+
+		clear_buffer_jwrite(bh);
+
+		JBUFFER_TRACE(jh, "ph4: unfile after journal write");
+		journal_unfile_buffer(journal, jh);
+
+		/*
+		 * ->t_iobuf_list should contain only dummy buffer_heads
+		 * which were created by journal_write_metadata_buffer().
+		 */
+		BUFFER_TRACE(bh, "dumping temporary bh");
+		journal_put_journal_head(jh);
+		__brelse(bh);
+		J_ASSERT_BH(bh, atomic_read(&bh->b_count) == 0);
+		free_buffer_head(bh);
+
+		/* We also have to unlock and free the corresponding
+                   shadowed buffer */
+		jh = commit_transaction->t_shadow_list->b_tprev;
+		bh = jh2bh(jh);
+		clear_buffer_jwrite(bh);
+		J_ASSERT_BH(bh, buffer_jbddirty(bh));
+
+		/* The metadata is now released for reuse, but we need
+                   to remember it against this transaction so that when
+                   we finally commit, we can do any checkpointing
+                   required. */
+		JBUFFER_TRACE(jh, "file as BJ_Forget");
+		journal_file_buffer(jh, commit_transaction, BJ_Forget);
+		/* Wake up any transactions which were waiting for this
+		   IO to complete */
+		wake_up_bit(&bh->b_state, BH_Unshadow);
+		JBUFFER_TRACE(jh, "brelse shadowed buffer");
+		__brelse(bh);
+	}
+#endif	
+
+	J_ASSERT (commit_transaction->t_shadow_list == NULL);
+
+	jbd_debug(3, "JBD: commit phase 5\n");
+
+	/* Here we wait for the revoke record and descriptor record buffers */
+#if 0	
+ wait_for_ctlbuf:
+	while (commit_transaction->t_log_list != NULL) {
+		struct buffer_head *bh;
+
+		jh = commit_transaction->t_log_list->b_tprev;
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
+		/* AKPM: bforget here */
+	}
+
+	if (err)
+		journal_abort(journal, err);
+#endif
+
+	jbd_debug(3, "JBD: commit phase 6\n");
+
+	/* All metadata is written, now write commit record and do cleanup */
+	spin_lock(&journal->j_state_lock);
+	J_ASSERT(commit_transaction->t_state == T_COMMIT);
+	commit_transaction->t_state = T_COMMIT_RECORD;
+	spin_unlock(&journal->j_state_lock);
+
+#if 0
+	if (journal_write_commit_record(journal, commit_transaction))
+		err = -EIO;
+
+	if (err)
+		journal_abort(journal, err);
+#endif
+	/* End of a transaction!  Finally, we can do checkpoint
+           processing: any buffers committed as a result of this
+           transaction can be removed from any checkpoint list it was on
+           before. */
+
+	jbd_debug(3, "JBD: commit phase 7\n");
+
+	J_ASSERT(commit_transaction->t_sync_datalist == NULL);
+	J_ASSERT(commit_transaction->t_buffers == NULL);
+	J_ASSERT(commit_transaction->t_checkpoint_list == NULL);
+	J_ASSERT(commit_transaction->t_iobuf_list == NULL);
+	J_ASSERT(commit_transaction->t_shadow_list == NULL);
+	J_ASSERT(commit_transaction->t_log_list == NULL);
+
+restart_loop:
+	/*
+	 * As there are other places (journal_unmap_buffer()) adding buffers
+	 * to this list we have to be careful and hold the j_list_lock.
+	 */
+	spin_lock(&journal->j_list_lock);
+	while (commit_transaction->t_forget) {
+		transaction_t *cp_transaction;
+		struct buffer_head *bh;
+
+		jh = commit_transaction->t_forget;
+		spin_unlock(&journal->j_list_lock);
+		bh = jh2bh(jh);
+		jbd_lock_bh_state(bh);
+		J_ASSERT_JH(jh,	jh->b_transaction == commit_transaction ||
+			jh->b_transaction == journal->j_running_transaction);
+
+		/*
+		 * If there is undo-protected committed data against
+		 * this buffer, then we can remove it now.  If it is a
+		 * buffer needing such protection, the old frozen_data
+		 * field now points to a committed version of the
+		 * buffer, so rotate that field to the new committed
+		 * data.
+		 *
+		 * Otherwise, we can just throw away the frozen data now.
+		 */
+		if (jh->b_committed_data) {
+			jbd_free(jh->b_committed_data, bh->b_size);
+			jh->b_committed_data = NULL;
+			if (jh->b_frozen_data) {
+				jh->b_committed_data = jh->b_frozen_data;
+				jh->b_frozen_data = NULL;
+			}
+		} else if (jh->b_frozen_data) {
+			jbd_free(jh->b_frozen_data, bh->b_size);
+			jh->b_frozen_data = NULL;
+		}
+
+		spin_lock(&journal->j_list_lock);
+		cp_transaction = jh->b_cp_transaction;
+		if (cp_transaction) {
+			JBUFFER_TRACE(jh, "remove from old cp transaction");
+			__journal_remove_checkpoint(jh);
+		}
+
+		/* Only re-checkpoint the buffer_head if it is marked
+		 * dirty.  If the buffer was added to the BJ_Forget list
+		 * by journal_forget, it may no longer be dirty and
+		 * there's no point in keeping a checkpoint record for
+		 * it. */
+
+		/* A buffer which has been freed while still being
+		 * journaled by a previous transaction may end up still
+		 * being dirty here, but we want to avoid writing back
+		 * that buffer in the future after the "add to orphan"
+		 * operation been committed,  That's not only a performance
+		 * gain, it also stops aliasing problems if the buffer is
+		 * left behind for writeback and gets reallocated for another
+		 * use in a different page. */
+		if (buffer_freed(bh) && !jh->b_next_transaction) {
+			clear_buffer_freed(bh);
+			clear_buffer_jbddirty(bh);
+		}
+
+		if (buffer_jbddirty(bh)) {
+			JBUFFER_TRACE(jh, "add to new checkpointing trans");
+			__journal_insert_checkpoint(jh, commit_transaction);
+			if (is_journal_aborted(journal))
+				clear_buffer_jbddirty(bh);
+			JBUFFER_TRACE(jh, "refile for checkpoint writeback");
+			__journal_refile_buffer(jh);
+			jbd_unlock_bh_state(bh);
+		} else {
+			J_ASSERT_BH(bh, !buffer_dirty(bh));
+			/* The buffer on BJ_Forget list and not jbddirty means
+			 * it has been freed by this transaction and hence it
+			 * could not have been reallocated until this
+			 * transaction has committed. *BUT* it could be
+			 * reallocated once we have written all the data to
+			 * disk and before we process the buffer on BJ_Forget
+			 * list. */
+			JBUFFER_TRACE(jh, "refile or unfile freed buffer");
+			__journal_refile_buffer(jh);
+			if (!jh->b_transaction) {
+				jbd_unlock_bh_state(bh);
+				 /* needs a brelse */
+				journal_remove_journal_head(bh);
+				release_buffer_page(bh);
+			} else
+				jbd_unlock_bh_state(bh);
+		}
+		cond_resched_lock(&journal->j_list_lock);
+	}
+	spin_unlock(&journal->j_list_lock);
+	/*
+	 * This is a bit sleazy.  We use j_list_lock to protect transition
+	 * of a transaction into T_FINISHED state and calling
+	 * __journal_drop_transaction(). Otherwise we could race with
+	 * other checkpointing code processing the transaction...
+	 */
+	spin_lock(&journal->j_state_lock);
+	spin_lock(&journal->j_list_lock);
+	/*
+	 * Now recheck if some buffers did not get attached to the transaction
+	 * while the lock was dropped...
+	 */
+	if (commit_transaction->t_forget) {
+		spin_unlock(&journal->j_list_lock);
+		spin_unlock(&journal->j_state_lock);
+		goto restart_loop;
+	}
+
+	/* Done with this transaction! */
+
+	jbd_debug(3, "JBD: commit phase 8\n");
+
+	J_ASSERT(commit_transaction->t_state == T_COMMIT_RECORD);
+
+	commit_transaction->t_state = T_FINISHED;
+	J_ASSERT(commit_transaction == journal->j_committing_transaction);
+	journal->j_commit_sequence = commit_transaction->t_tid;
+	journal->j_committing_transaction = NULL;
+	commit_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
+
+	/*
+	 * weight the commit time higher than the average time so we don't
+	 * react too strongly to vast changes in commit time
+	 */
+	if (likely(journal->j_average_commit_time))
+		journal->j_average_commit_time = (commit_time*3 +
+				journal->j_average_commit_time) / 4;
+	else
+		journal->j_average_commit_time = commit_time;
+
+	spin_unlock(&journal->j_state_lock);
+
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
+		__journal_drop_transaction(journal, commit_transaction);
+	} else {
+		if (journal->j_checkpoint_transactions == NULL) {
+			journal->j_checkpoint_transactions = commit_transaction;
+			commit_transaction->t_cpnext = commit_transaction;
+			commit_transaction->t_cpprev = commit_transaction;
+		} else {
+			commit_transaction->t_cpnext =
+				journal->j_checkpoint_transactions;
+			commit_transaction->t_cpprev =
+				commit_transaction->t_cpnext->t_cpprev;
+			commit_transaction->t_cpnext->t_cpprev =
+				commit_transaction;
+			commit_transaction->t_cpprev->t_cpnext =
+				commit_transaction;
+		}
+	}
+	spin_unlock(&journal->j_list_lock);
+
+	jbd_debug(1, "JBD: commit %d complete, head %d\n",
+		  journal->j_commit_sequence, journal->j_tail_sequence);
+
+	wake_up(&journal->j_wait_done_commit);
+}
+
+#endif
diff -ur ./journal.c /home/srimugunthan/niraj/linux_kernel/linux-2.6.38.6/fs/jbd/journal.c
--- ./journal.c	2011-05-10 03:46:23.000000000 +0530
+++ /home/srimugunthan/niraj/linux_kernel/linux-2.6.38.6/fs/jbd/journal.c	2011-06-22 14:24:21.551958448 +0530
@@ -40,6 +40,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
+#include <linux/mtd/blktrans.h>
 
 EXPORT_SYMBOL(journal_start);
 EXPORT_SYMBOL(journal_restart);
@@ -329,11 +330,13 @@
 	/*
 	 * Check for escaping
 	 */
+#ifndef	 TXFLASH
 	if (*((__be32 *)(mapped_data + new_offset)) ==
 				cpu_to_be32(JFS_MAGIC_NUMBER)) {
 		need_copy_out = 1;
 		do_escape = 1;
 	}
+#endif	
 	kunmap_atomic(mapped_data, KM_USER0);
 
 	/*
diff -ur ./recovery.c /home/srimugunthan/niraj/linux_kernel/linux-2.6.38.6/fs/jbd/recovery.c
--- ./recovery.c	2011-05-10 03:46:23.000000000 +0530
+++ /home/srimugunthan/niraj/linux_kernel/linux-2.6.38.6/fs/jbd/recovery.c	2011-06-22 14:24:21.571958448 +0530
@@ -22,6 +22,12 @@
 #include <linux/errno.h>
 #endif
 
+#include <linux/mtd/blktrans.h>
+#ifdef TXFLASH
+#include <linux/genhd.h>
+#include <linux/blkdev.h>
+#endif
+
 /*
  * Maintain information about the progress of the recovery job, so that
  * the different passes can carry information between them.
@@ -226,7 +232,7 @@
 	journal_superblock_t *	sb;
 
 	struct recovery_info	info;
+#ifndef TXFLASH
 	memset(&info, 0, sizeof(info));
 	sb = journal->j_superblock;
 
@@ -265,6 +271,9 @@
 		err = err2;
 
 	return err;
+#else
+	return journal->j_dev->bd_disk->fops->ioctl(journal->j_dev,0777,RECOVER,0);
+#endif	
 }
 
 /**
diff -ur ./revoke.c /home/srimugunthan/niraj/linux_kernel/linux-2.6.38.6/fs/jbd/revoke.c
--- ./revoke.c	2011-05-10 03:46:23.000000000 +0530
+++ /home/srimugunthan/niraj/linux_kernel/linux-2.6.38.6/fs/jbd/revoke.c	2011-06-22 17:43:20.229114134 +0530
@@ -89,6 +89,7 @@
 #include <linux/bio.h>
 #endif
 #include <linux/log2.h>
+#include <linux/mtd/blktrans.h>
 
 static struct kmem_cache *revoke_record_cache;
 static struct kmem_cache *revoke_table_cache;
@@ -119,7 +120,11 @@
 #ifdef __KERNEL__
 static void write_one_revoke_record(journal_t *, transaction_t *,
 				    struct journal_head **, int *,
-				    struct jbd_revoke_record_s *, int);
+				    struct jbd_revoke_record_s *, int
+				    ,int*
+				    );
 static void flush_descriptor(journal_t *, struct journal_head *, int, int);
 #endif
 
@@ -508,11 +513,12 @@
 	struct jbd_revoke_table_s *revoke;
 	struct list_head *hash_list;
 	int i, offset, count;
+	int meta_cnt;
 	descriptor = NULL;
 	offset = 0;
 	count = 0;
+	meta_cnt=0;
 	/* select revoke table for committing transaction */
 	revoke = journal->j_revoke == journal->j_revoke_table[0] ?
 		journal->j_revoke_table[1] : journal->j_revoke_table[0];
@@ -525,14 +531,25 @@
 				hash_list->next;
 			write_one_revoke_record(journal, transaction,
 						&descriptor, &offset,
-						record, write_op);
+						record, write_op
+						,&meta_cnt
+						);
 			count++;
 			list_del(&record->hash);
 			kmem_cache_free(revoke_record_cache, record);
 		}
 	}
 	if (descriptor)
+	{
+		meta_cnt++;
+		jbd_debug(1, "my_descriptor record count %d\n", meta_cnt);
 		flush_descriptor(journal, descriptor, offset, write_op);
+	}
 	jbd_debug(1, "Wrote %d revoke records\n", count);
 }
 
@@ -546,7 +563,11 @@
 				    struct journal_head **descriptorp,
 				    int *offsetp,
 				    struct jbd_revoke_record_s *record,
-				    int write_op)
+				    int write_op
+					,int *meta_cnt
+				    )
 {
 	struct journal_head *descriptor;
 	int offset;
@@ -565,6 +586,9 @@
 	/* Make sure we have a descriptor with space left for the record */
 	if (descriptor) {
 		if (offset == journal->j_blocksize) {
+			(*meta_cnt)++;
 			flush_descriptor(journal, descriptor, offset, write_op);
 			descriptor = NULL;
 		}
diff -ur ./transaction.c /home/srimugunthan/niraj/linux_kernel/linux-2.6.38.6/fs/jbd/transaction.c
--- ./transaction.c	2011-05-10 03:46:23.000000000 +0530
+++ /home/srimugunthan/niraj/linux_kernel/linux-2.6.38.6/fs/jbd/transaction.c	2011-06-22 14:24:21.501958448 +0530
@@ -26,6 +26,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/hrtimer.h>
+#include <linux/mtd/blktrans.h>
 
 static void __journal_temp_unlink_buffer(struct journal_head *jh);
 


--------------080207040903020202060909--
