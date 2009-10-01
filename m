From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 3/4] [jbd] Add support for journal guided resync.
Date: Thu, 1 Oct 2009 16:39:31 -0700
Message-ID: <20091001163931.6959c453.akpm@linux-foundation.org>
References: <20091001223929.120106893@sun.com>
	<20091001224018.740641147@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, adilger@sun.com
To: scjody@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755148AbZJAXkD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 19:40:03 -0400
In-Reply-To: <20091001224018.740641147@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 01 Oct 2009 18:39:32 -0400
scjody@sun.com wrote:

> Adds support for declare blocks, used by ext3's journal guided resync (declared
> mode.)  A declare block is added to the journal to list blocks to be written
> during the current transaction.  During journal replay, we perform a RAID
> resync of only these blocks and skip the rest of the resync.
> 
> ...
>  
> +int wait_for_descriptors(journal_t *journal, transaction_t *trans) {

Opening brace goes on the next line, please.  Several instances.

> +	struct journal_head *jh;
> +	struct buffer_head *bh;
> +	int err = 0;
> +
> +wait_for_ctlbuf:
> +
> +	while (trans->t_log_list != NULL) {
> +
> +		jh = trans->t_log_list->b_tprev;
> +		bh = jh2bh(jh);
> +		if (buffer_locked(bh)) {
> +			wait_on_buffer(bh);
> +			goto wait_for_ctlbuf;
> +		}
> +		if (cond_resched())
> +			goto wait_for_ctlbuf;
> +
> +		if (unlikely(!buffer_uptodate(bh)))
> +			err = -EIO;
> +
> +		BUFFER_TRACE(bh, "ph5: control buffer writeout done: unfile");
> +		clear_buffer_jwrite(bh);
> +		journal_unfile_buffer(journal, jh);
> +		journal_put_journal_head(jh);
> +		__brelse(bh);		/* One for getblk */
> +	}
> +
> +	return err;
> +}
> +
> +struct journal_head *get_descriptor(journal_t *journal, transaction_t *trans,
> +				    int blocktype, char **tagp, int *space_left) {

Did all these functions need global scope?  Some do, but I didn't check
them all.

Those which cannot be made static should be given appropriate names,
such as jbd_get_descriptor().

> +	struct journal_head *descriptor;
> +	struct buffer_head *dbh;
> +	journal_header_t *header;
> +
> +	jbd_debug(4, "JBD: get descriptor\n");
> +
> +	descriptor = journal_get_descriptor_buffer(journal);
> +	if (!descriptor)
> +		return NULL;
> +
> +	dbh = jh2bh(descriptor);
> +	jbd_debug(4, "JBD: got buffer %llu (%p)\n",
> +	    (unsigned long long)dbh->b_blocknr, dbh->b_data);
> +	header = (journal_header_t *)&dbh->b_data[0];
> +	header->h_magic     = cpu_to_be32(JFS_MAGIC_NUMBER);
> +	header->h_blocktype = cpu_to_be32(blocktype);
> +	header->h_sequence  = cpu_to_be32(trans->t_tid);
> +
> +	*tagp = &dbh->b_data[sizeof(journal_header_t)];
> +	*space_left = dbh->b_size - sizeof(journal_header_t);
> +
> +	set_buffer_jwrite(dbh);
> +	set_buffer_dirty(dbh);
> +
> +	/* Record it so that we can wait for it later */
> +	BUFFER_TRACE(dbh, "ph3: file as descriptor");
> +	journal_file_buffer(descriptor, trans, BJ_LogCtl);
> +
> +	return descriptor;
> +}
> +
>
> ...
>
> +void write_declare_blocks(journal_t *journal, transaction_t *transaction,
> +			  int committing)
> +{
> +	struct journal_head *jh, *descriptor = NULL;
> +	struct buffer_head *bh;
> +	int i, bufs = 0, err;
> +	unsigned int n, count = 0, to_write;
> +	unsigned long nextblock = 0;
> +	char *tagp = NULL;
> +	journal_block_tag_t *tag = NULL;
> +	int space_left = 0, first_tag = 0, tag_flag;
> +	struct radix_tree_root *root;
> +
> +	root = &transaction->t_declare_root;
> +
> +	spin_lock(&journal->j_list_lock);
> +	to_write = transaction->t_declare_request;
> +	transaction->t_declare_request = 0;
> +	spin_unlock(&journal->j_list_lock);
> +
> +	if (to_write == UINT_MAX)
> +		jbd_debug (1, "jbd: tid %d write declare request for ALL "
> +			   "blocks\n", transaction->t_tid);
> +	else
> +		jbd_debug (1, "jbd: tid %d write declare request for %u "
> +			   "blocks\n", transaction->t_tid, to_write);
> +write_declare:
> +	cond_resched();
> +	spin_lock(&journal->j_list_lock);
> +
> +	n = radix_tree_gang_lookup(root, journal->j_declare_jhs, nextblock, 1);
> +	while (n) {
> +		if (!descriptor) {
> +			J_ASSERT(bufs == 0);
> +
> +			spin_unlock(&journal->j_list_lock);
> +
> +			descriptor = get_descriptor(journal, transaction,
> +						    JFS_DECLARE_BLOCK,
> +						    &tagp, &space_left);
> +
> +			if (!descriptor) {
> +				journal_abort(journal, -EIO);
> +				return;
> +			}
> +
> +			first_tag = 1;
> +			journal->j_declare_bhs[bufs++] = jh2bh(descriptor);
> +
> +			goto write_declare;
> +		}
> +
> +		jh = (struct journal_head *)journal->j_declare_jhs[0];
> +		bh = jh2bh(jh);
> +
> +		/* refile the buffer as having been declared */
> +		if (!inverted_lock(journal, bh))
> +			goto write_declare;
> +		__journal_unfile_buffer(jh);
> +		__journal_file_buffer(jh, transaction, BJ_DeclareDone);
> +
> +		jbd_unlock_bh_state(bh);
> +
> +		/* record the block's tag in the current descriptor buffer */
> +		tag_flag = 0;
> +		if (!first_tag)
> +			tag_flag |= JFS_FLAG_SAME_UUID;
> +
> +		tag = (journal_block_tag_t *)tagp;
> +		tag->t_blocknr = cpu_to_be32(bh->b_blocknr);
> +		tag->t_flags = cpu_to_be32(tag_flag);
> +		tagp += sizeof(journal_block_tag_t);
> +		space_left -= sizeof(journal_block_tag_t);
> +
> +		if (first_tag) {
> +			memcpy (tagp, journal->j_uuid, 16);

Please pass the patches through scripts/checkpatch.pl and review the
result.

> +			tagp += 16;
> +			space_left -= 16;
> +			first_tag = 0;
> +		}
> +
> +		count++;
> +
> +		/* advance to the next journal head and buffer */
> +		nextblock = bh->b_blocknr + 1;
> +		n = radix_tree_gang_lookup(root, journal->j_declare_jhs,
> +					   nextblock, 1);
> +
> +		/* If there's no more to do, or if the descriptor is full,
> +		   let the IO rip! */
> +
> +		if (bufs == ARRAY_SIZE(journal->j_declare_bhs) || n == 0 ||
> +		    count == to_write ||
> +		    space_left < sizeof(journal_block_tag_t) + 16) {
> +
> +			jbd_debug(4, "JBD: Submit %d IOs\n", bufs);
> +
> +			/* Write an end-of-descriptor marker before
> +			 * submitting the IOs.  "tag" still points to
> +                         * the last tag we set up.
> +			 */
> +
> +			tag->t_flags |= cpu_to_be32(JFS_FLAG_LAST_TAG);
> +
>
> ...
>
> +int journal_write_declare(journal_t *journal)
> +{
> +	transaction_t *transaction = journal->j_running_transaction;
> +	DEFINE_WAIT(wait);
> +
> +	if (transaction == NULL)
> +		return 0;
> +
> +	spin_lock(&journal->j_list_lock);
> +
> +	if (transaction->t_declare_root.rnode == NULL) {
> +		spin_unlock(&journal->j_list_lock);
> +		return 0;
> +	}
> +
> +	transaction->t_declare_request = UINT_MAX;
> +
> +	jbd_debug(1, "waking commit thread for fsync declare\n");
> +	wake_up(&journal->j_wait_commit);
> +
> +	prepare_to_wait(&journal->j_wait_declare, &wait, TASK_INTERRUPTIBLE);
> +	spin_unlock(&journal->j_list_lock);
> +	schedule();
> +	finish_wait(&journal->j_wait_declare, &wait);

If this function is only ever called by a kernel thread then
TASK_INTERRUPTIBLE is OK.

If this function can be called by a userspace process then
TASK_INTERRUPTIBLE is buggy - a signal_pending() state will cause the
schedule() to fall straight through.

> +	return 0;
> +}
> +
>
> ...
>
> +static int resync_range(journal_t *j, unsigned long start,
> +			unsigned long end)
> +{
> +	int err;
> +	struct inode *fake_inode = kmalloc(sizeof(*fake_inode), GFP_KERNEL);
> +	mdu_range_t range;
> +	sector_t sectors_per_block = j->j_blocksize >> 9;
> +	mm_segment_t old_fs;
> +
> +	if (fake_inode == NULL) {
> +		printk(KERN_ERR "JBD: Out of memory during recovery.\n");
> +		return -ENOMEM;
> +	}
> +
> +	fake_inode->i_bdev = j->j_fs_dev;
> +	range.start = start * sectors_per_block;
> +	range.end = end * sectors_per_block + sectors_per_block - 1;
> +
> +	old_fs = get_fs();
> +	set_fs(KERNEL_DS);
> +	err = blkdev_driver_ioctl(fake_inode, NULL, j->j_fs_dev->bd_disk,
> +				  RESYNC_RANGE, (long)&range);
> +	set_fs(old_fs);

erk, what's happening here.

I can't find the blkdev_driver_ioctl() definition.  If I could, I'd be
asking if it can be refactored so we can call a regular kernel function
and avoid the nasty set_fs(), and do away with the nasty fake_inode.


> +	jbd_debug(3, "RESYNC_RANGE of sectors %llu - %llu returned %d\n",
> +		  range.start, range.end, err);
> +
> +	kfree(fake_inode);
> +
> +	return err;
> +}
>  
>
> ...
>

