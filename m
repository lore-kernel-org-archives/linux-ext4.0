From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH 4/4] jbd: fix error handling for checkpoint io (rebased)
Date: Wed, 14 May 2008 09:16:22 -0400
Message-ID: <20080514131621.GB20256@unused.rdu.redhat.com>
References: <482A6E00.6080303@hitachi.com> <482A6FA3.9000104@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758918AbYENNcj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 May 2008 09:32:39 -0400
Content-Disposition: inline
In-Reply-To: <482A6FA3.9000104@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 14, 2008 at 01:50:43PM +0900, Hidehiro Kawai wrote:
> Subject: [PATCH 4/4] jbd: fix error handling for checkpoint io
> 
> When a checkpointing IO fails, current JBD code doesn't check the
> error and continue journaling.  This means latest metadata can be
> lost from both the journal and filesystem.
> 
> This patch leaves the failed metadata blocks in the journal space
> and aborts journaling in the case of log_do_checkpoint().
> To achieve this, we need to do:
> 
> 1. don't remove the failed buffer from the checkpoint list where in
>    the case of __try_to_free_cp_buf() because it may be released or
>    overwritten by a later transaction
> 2. log_do_checkpoint() is the last chance, remove the failed buffer
>    from the checkpoint list and abort journaling
> 3. when checkpointing fails, don't update the journal super block to
>    prevent the journalled contents from being cleaned
> 4. when checkpointing fails, don't clear the needs_recovery flag,
>    otherwise the journalled contents are ignored and cleaned in the
>    recovery phase
> 5. if the recovery fails, keep the needs_recovery flag
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> ---
>  fs/ext3/ioctl.c     |   12 ++++----
>  fs/ext3/super.c     |   13 +++++++--
>  fs/jbd/checkpoint.c |   59 ++++++++++++++++++++++++++++++++++--------
>  fs/jbd/journal.c    |   21 +++++++++-----
>  fs/jbd/recovery.c   |    7 +++-
>  include/linux/jbd.h |    7 ++++
>  6 files changed, 91 insertions(+), 28 deletions(-)
> 
> Index: linux-2.6.26-rc2/fs/jbd/checkpoint.c
> ===================================================================
> --- linux-2.6.26-rc2.orig/fs/jbd/checkpoint.c
> +++ linux-2.6.26-rc2/fs/jbd/checkpoint.c
> @@ -93,7 +93,8 @@ static int __try_to_free_cp_buf(struct j
>  	int ret = 0;
>  	struct buffer_head *bh = jh2bh(jh);
>  
> -	if (jh->b_jlist == BJ_None && !buffer_locked(bh) && !buffer_dirty(bh)) {
> +	if (jh->b_jlist == BJ_None && !buffer_locked(bh) &&
> +	    !buffer_dirty(bh) && buffer_uptodate(bh)) {
>  		JBUFFER_TRACE(jh, "remove from checkpoint list");
>  		ret = __journal_remove_checkpoint(jh) + 1;
>  		jbd_unlock_bh_state(bh);
> @@ -140,6 +141,25 @@ void __log_wait_for_space(journal_t *jou
>  }
>  
>  /*
> + * We couldn't write back some metadata buffers to the filesystem.
> + * To avoid unwritten-back metadata buffers from losing, set
> + * JFS_CP_ABORT flag and make sure that the journal space isn't
> + * cleaned.  This function also aborts journaling.
> + */
> +static void __journal_abort_checkpoint(journal_t *journal, int errno)
> +{
> +	if (is_checkpoint_aborted(journal))
> +		return;
> +
> +	spin_lock(&journal->j_state_lock);
> +	journal->j_flags |= JFS_CP_ABORT;
> +	spin_unlock(&journal->j_state_lock);
> +	printk(KERN_WARNING "JBD: Checkpointing failed.  Some metadata blocks "
> +	       "are still old.\n");
> +	journal_abort(journal, errno);
> +}
> +
> +/*
>   * We were unable to perform jbd_trylock_bh_state() inside j_list_lock.
>   * The caller must restart a list walk.  Wait for someone else to run
>   * jbd_unlock_bh_state().
> @@ -160,21 +180,25 @@ static void jbd_sync_bh(journal_t *journ
>   * buffers. Note that we take the buffers in the opposite ordering
>   * from the one in which they were submitted for IO.
>   *
> + * Return 0 on success, and return <0 if some buffers have failed
> + * to be written out.
> + *
>   * Called with j_list_lock held.
>   */
> -static void __wait_cp_io(journal_t *journal, transaction_t *transaction)
> +static int __wait_cp_io(journal_t *journal, transaction_t *transaction)
>  {
>  	struct journal_head *jh;
>  	struct buffer_head *bh;
>  	tid_t this_tid;
>  	int released = 0;
> +	int ret = 0;
>  
>  	this_tid = transaction->t_tid;
>  restart:
>  	/* Did somebody clean up the transaction in the meanwhile? */
>  	if (journal->j_checkpoint_transactions != transaction ||
>  			transaction->t_tid != this_tid)
> -		return;
> +		return ret;
>  	while (!released && transaction->t_checkpoint_io_list) {
>  		jh = transaction->t_checkpoint_io_list;
>  		bh = jh2bh(jh);
> @@ -194,6 +218,9 @@ restart:
>  			spin_lock(&journal->j_list_lock);
>  			goto restart;
>  		}
> +		if (unlikely(!buffer_uptodate(bh)))
> +			ret = -EIO;
> +
>  		/*
>  		 * Now in whatever state the buffer currently is, we know that
>  		 * it has been written out and so we can drop it from the list
> @@ -203,6 +230,8 @@ restart:
>  		journal_remove_journal_head(bh);
>  		__brelse(bh);
>  	}
> +
> +	return ret;
>  }
>  
>  #define NR_BATCH	64
> @@ -226,7 +255,8 @@ __flush_batch(journal_t *journal, struct
>   * Try to flush one buffer from the checkpoint list to disk.
>   *
>   * Return 1 if something happened which requires us to abort the current
> - * scan of the checkpoint list.
> + * scan of the checkpoint list.  Return <0 if the buffer has failed to
> + * be written out.
>   *
>   * Called with j_list_lock held and drops it if 1 is returned
>   * Called under jbd_lock_bh_state(jh2bh(jh)), and drops it
> @@ -256,6 +286,9 @@ static int __process_buffer(journal_t *j
>  		log_wait_commit(journal, tid);
>  		ret = 1;
>  	} else if (!buffer_dirty(bh)) {
> +		ret = 1;
> +		if (unlikely(!buffer_uptodate(bh)))
> +			ret = -EIO;
>  		J_ASSERT_JH(jh, !buffer_jbddirty(bh));
>  		BUFFER_TRACE(bh, "remove from checkpoint");
>  		__journal_remove_checkpoint(jh);
> @@ -263,7 +296,6 @@ static int __process_buffer(journal_t *j
>  		jbd_unlock_bh_state(bh);
>  		journal_remove_journal_head(bh);
>  		__brelse(bh);
> -		ret = 1;
>  	} else {
>  		/*
>  		 * Important: we are about to write the buffer, and
> @@ -318,6 +350,7 @@ int log_do_checkpoint(journal_t *journal
>  	 * OK, we need to start writing disk blocks.  Take one transaction
>  	 * and write it.
>  	 */
> +	result = 0;
>  	spin_lock(&journal->j_list_lock);
>  	if (!journal->j_checkpoint_transactions)
>  		goto out;
> @@ -334,7 +367,7 @@ restart:
>  		int batch_count = 0;
>  		struct buffer_head *bhs[NR_BATCH];
>  		struct journal_head *jh;
> -		int retry = 0;
> +		int retry = 0, err;
>  
>  		while (!retry && transaction->t_checkpoint_list) {
>  			struct buffer_head *bh;
> @@ -347,6 +380,8 @@ restart:
>  				break;
>  			}
>  			retry = __process_buffer(journal, jh, bhs,&batch_count);
> +			if (retry < 0)
> +				result = retry;
>  			if (!retry && (need_resched() ||
>  				spin_needbreak(&journal->j_list_lock))) {
>  				spin_unlock(&journal->j_list_lock);
> @@ -371,14 +406,18 @@ restart:
>  		 * Now we have cleaned up the first transaction's checkpoint
>  		 * list. Let's clean up the second one
>  		 */
> -		__wait_cp_io(journal, transaction);
> +		err = __wait_cp_io(journal, transaction);
> +		if (!result)
> +			result = err;
>  	}
>  out:
>  	spin_unlock(&journal->j_list_lock);
> -	result = cleanup_journal_tail(journal);
>  	if (result < 0)
> -		return result;
> -	return 0;
> +		__journal_abort_checkpoint(journal, result);
> +	else
> +		result = cleanup_journal_tail(journal);
> +
> +	return (result < 0) ? result : 0;
>  }
>  
>  /*
> Index: linux-2.6.26-rc2/include/linux/jbd.h
> ===================================================================
> --- linux-2.6.26-rc2.orig/include/linux/jbd.h
> +++ linux-2.6.26-rc2/include/linux/jbd.h
> @@ -816,6 +816,8 @@ struct journal_s
>  #define JFS_FLUSHED	0x008	/* The journal superblock has been flushed */
>  #define JFS_LOADED	0x010	/* The journal superblock has been loaded */
>  #define JFS_BARRIER	0x020	/* Use IDE barriers */
> +#define JFS_CP_ABORT	0x040	/* Checkpointing has failed.  We don't have to
> +				 * clean the journal space.  */
>  
>  /*
>   * Function declarations for the journaling transaction and buffer
> @@ -1004,6 +1006,11 @@ static inline int is_journal_aborted(jou
>  	return journal->j_flags & JFS_ABORT;
>  }
>  
> +static inline int is_checkpoint_aborted(journal_t *journal)
> +{
> +	return journal->j_flags & JFS_CP_ABORT;
> +}
> +
>  static inline int is_handle_aborted(handle_t *handle)
>  {
>  	if (handle->h_aborted)
> Index: linux-2.6.26-rc2/fs/ext3/ioctl.c
> ===================================================================
> --- linux-2.6.26-rc2.orig/fs/ext3/ioctl.c
> +++ linux-2.6.26-rc2/fs/ext3/ioctl.c
> @@ -239,7 +239,7 @@ setrsvsz_out:
>  	case EXT3_IOC_GROUP_EXTEND: {
>  		ext3_fsblk_t n_blocks_count;
>  		struct super_block *sb = inode->i_sb;
> -		int err;
> +		int err, err2;
>  
>  		if (!capable(CAP_SYS_RESOURCE))
>  			return -EPERM;
> @@ -254,16 +254,16 @@ setrsvsz_out:
>  		}
>  		err = ext3_group_extend(sb, EXT3_SB(sb)->s_es, n_blocks_count);
>  		journal_lock_updates(EXT3_SB(sb)->s_journal);
> -		journal_flush(EXT3_SB(sb)->s_journal);
> +		err2 = journal_flush(EXT3_SB(sb)->s_journal);
>  		journal_unlock_updates(EXT3_SB(sb)->s_journal);
>  group_extend_out:
>  		mnt_drop_write(filp->f_path.mnt);
> -		return err;
> +		return (err) ? err : err2;
>  	}
>  	case EXT3_IOC_GROUP_ADD: {
>  		struct ext3_new_group_data input;
>  		struct super_block *sb = inode->i_sb;
> -		int err;
> +		int err, err2;
>  
>  		if (!capable(CAP_SYS_RESOURCE))
>  			return -EPERM;
> @@ -280,11 +280,11 @@ group_extend_out:
>  
>  		err = ext3_group_add(sb, &input);
>  		journal_lock_updates(EXT3_SB(sb)->s_journal);
> -		journal_flush(EXT3_SB(sb)->s_journal);
> +		err2 = journal_flush(EXT3_SB(sb)->s_journal);
>  		journal_unlock_updates(EXT3_SB(sb)->s_journal);
>  group_add_out:
>  		mnt_drop_write(filp->f_path.mnt);
> -		return err;
> +		return (err) ? err : err2;
>  	}
>  
>  
> Index: linux-2.6.26-rc2/fs/ext3/super.c
> ===================================================================
> --- linux-2.6.26-rc2.orig/fs/ext3/super.c
> +++ linux-2.6.26-rc2/fs/ext3/super.c
> @@ -395,7 +395,10 @@ static void ext3_put_super (struct super
>  	ext3_xattr_put_super(sb);
>  	journal_destroy(sbi->s_journal);
>  	if (!(sb->s_flags & MS_RDONLY)) {
> -		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
> +		if (!is_checkpoint_aborted(sbi->s_journal)) {
> +			EXT3_CLEAR_INCOMPAT_FEATURE(sb,
> +				EXT3_FEATURE_INCOMPAT_RECOVER);
> +		}
>  		es->s_state = cpu_to_le16(sbi->s_mount_state);
>  		BUFFER_TRACE(sbi->s_sbh, "marking dirty");
>  		mark_buffer_dirty(sbi->s_sbh);

Is this bit here really needed?  If we abort the journal the fs will be mounted
read only and we should never get in here.  Is there a case where we could abort
the journal and not be flipped to being read-only?  If there is such a case I
would think that we should fix that by making the fs read-only, and not have
this check.

> @@ -2373,7 +2376,13 @@ static void ext3_write_super_lockfs(stru
>  
>  		/* Now we set up the journal barrier. */
>  		journal_lock_updates(journal);
> -		journal_flush(journal);
> +
> +		/*
> +		 * We don't want to clear needs_recovery flag when we failed
> +		 * to flush the journal.
> +		 */
> +		if (journal_flush(journal) < 0)
> +			return;
>  
>  		/* Journal blocked and flushed, clear needs_recovery flag. */
>  		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
> Index: linux-2.6.26-rc2/fs/jbd/journal.c
> ===================================================================
> --- linux-2.6.26-rc2.orig/fs/jbd/journal.c
> +++ linux-2.6.26-rc2/fs/jbd/journal.c
> @@ -674,7 +674,7 @@ static journal_t * journal_init_common (
>  	journal->j_commit_interval = (HZ * JBD_DEFAULT_MAX_COMMIT_AGE);
>  
>  	/* The journal is marked for error until we succeed with recovery! */
> -	journal->j_flags = JFS_ABORT;
> +	journal->j_flags = JFS_ABORT | JFS_CP_ABORT;
>  
>  	/* Set up a default-sized revoke table for the new mount. */
>  	err = journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
> @@ -1107,7 +1107,7 @@ int journal_load(journal_t *journal)
>  	if (journal_reset(journal))
>  		goto recovery_error;
>  
> -	journal->j_flags &= ~JFS_ABORT;
> +	journal->j_flags &= ~(JFS_ABORT | JFS_CP_ABORT);
>  	journal->j_flags |= JFS_LOADED;
>  	return 0;
>  
> @@ -1151,7 +1151,8 @@ void journal_destroy(journal_t *journal)
>  	journal->j_tail = 0;
>  	journal->j_tail_sequence = ++journal->j_transaction_sequence;
>  	if (journal->j_sb_buffer) {
> -		journal_update_superblock(journal, 1);
> +		if (!is_checkpoint_aborted(journal))
> +			journal_update_superblock(journal, 1);
>  		brelse(journal->j_sb_buffer);
>  	}
>  
> @@ -1333,7 +1334,6 @@ static int journal_convert_superblock_v1
>  
>  int journal_flush(journal_t *journal)
>  {
> -	int err = 0;
>  	transaction_t *transaction = NULL;
>  	unsigned long old_tail;
>  
> @@ -1356,14 +1356,19 @@ int journal_flush(journal_t *journal)
>  		spin_unlock(&journal->j_state_lock);
>  	}
>  
> -	/* ...and flush everything in the log out to disk. */
> +	/* ...and flush everything in the log out to disk.
> +	 * Even if an error occurs, we don't stop this loop.
> +	 * We do checkpoint as much as possible.  */
>  	spin_lock(&journal->j_list_lock);
> -	while (!err && journal->j_checkpoint_transactions != NULL) {
> +	while (journal->j_checkpoint_transactions != NULL) {
>  		spin_unlock(&journal->j_list_lock);
> -		err = log_do_checkpoint(journal);
> +		log_do_checkpoint(journal);
>  		spin_lock(&journal->j_list_lock);
>  	}
>  	spin_unlock(&journal->j_list_lock);
> +	if (is_checkpoint_aborted(journal))
> +		return -EIO;
> +
>  	cleanup_journal_tail(journal);
>  
>  	/* Finally, mark the journal as really needing no recovery.
> @@ -1385,7 +1390,7 @@ int journal_flush(journal_t *journal)
>  	J_ASSERT(journal->j_head == journal->j_tail);
>  	J_ASSERT(journal->j_tail_sequence == journal->j_transaction_sequence);
>  	spin_unlock(&journal->j_state_lock);
> -	return err;
> +	return 0;
>  }
>  
>  /**
> Index: linux-2.6.26-rc2/fs/jbd/recovery.c
> ===================================================================
> --- linux-2.6.26-rc2.orig/fs/jbd/recovery.c
> +++ linux-2.6.26-rc2/fs/jbd/recovery.c
> @@ -223,7 +223,7 @@ do {									\
>   */
>  int journal_recover(journal_t *journal)
>  {
> -	int			err;
> +	int			err, err2;
>  	journal_superblock_t *	sb;
>  
>  	struct recovery_info	info;
> @@ -261,7 +261,10 @@ int journal_recover(journal_t *journal)
>  	journal->j_transaction_sequence = ++info.end_transaction;
>  
>  	journal_clear_revoke(journal);
> -	sync_blockdev(journal->j_fs_dev);
> +	err2 = sync_blockdev(journal->j_fs_dev);
> +	if (!err)
> +		err = err2;
> +
>  	return err;
>  }
>  
> 
>

Other than that one question it looks good to me.  Thanks much,

Josef 
