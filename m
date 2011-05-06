From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] Adding support to freeze and unfreeze a journal
Date: Fri, 6 May 2011 14:56:42 -0600
Message-ID: <AA6B40F6-33A1-4C0B-8F80-71509FFF106E@dilger.ca>
References: <20110504192436.GC6968@quack.suse.cz> <1304695231-11335-2-git-send-email-surbhi.palande@canonical.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: jack@suse.cz, toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:9733 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1EFU4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 May 2011 16:56:45 -0400
In-Reply-To: <1304695231-11335-2-git-send-email-surbhi.palande@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 6, 2011, at 09:20, Surbhi Palande wrote:
> The journal should be frozen when a F.S freezes. What this means is that till
> the F.S is thawed again, no new transactions should be accepted by the
> journal. When the F.S thaws, inturn it should thaw the journal and this should
> allow the journal to resume accepting new transactions.
> While the F.S has frozen the journal, the clients of journal on calling
> jbd2_journal_start() will sleep on a wait queue. Thawing the journal will wake
> up the sleeping clients and journalling can progress normally.
> 
> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>

I think this is not a good patch as-is, see below.

> ---
> fs/ext4/super.c       |   20 ++++++--------------
> fs/jbd2/journal.c     |    1 +
> fs/jbd2/transaction.c |   36 ++++++++++++++++++++++++++++++++++++
> include/linux/jbd2.h  |    9 +++++++++
> 4 files changed, 52 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8553dfb..796aa4c 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4179,23 +4179,15 @@ static int ext4_freeze(struct super_block *sb)
> 
> 	journal = EXT4_SB(sb)->s_journal;
> 
> -	/* Now we set up the journal barrier. */
> -	jbd2_journal_lock_updates(journal);
> -
> +	error = jbd2_journal_freeze(journal);
> 	/*
> -	 * Don't clear the needs_recovery flag if we failed to flush
> +	 * Don't clear the needs_recovery flag if we failed to freeze
> 	 * the journal.
> 	 */
> -	error = jbd2_journal_flush(journal);
> -	if (error < 0)
> -		goto out;
> -
> -	/* Journal blocked and flushed, clear needs_recovery flag. */
> -	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> -	error = ext4_commit_super(sb, 1);
> -out:
> -	/* we rely on s_frozen to stop further updates */
> -	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
> +	if (error >= 0) {
> +		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> +		error = ext4_commit_super(sb, 1);
> +	}
> 	return error;
> }
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index e0ec3db..5e46333 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -842,6 +842,7 @@ static journal_t * journal_init_common (void)
> 	init_waitqueue_head(&journal->j_wait_checkpoint);
> 	init_waitqueue_head(&journal->j_wait_commit);
> 	init_waitqueue_head(&journal->j_wait_updates);
> +	init_waitqueue_head(&journal->j_wait_frozen);
> 	mutex_init(&journal->j_barrier);
> 	mutex_init(&journal->j_checkpoint_mutex);
> 	spin_lock_init(&journal->j_revoke_lock);
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 05fa77a..ad5a5df 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -171,6 +171,13 @@ repeat:
> 				journal->j_barrier_count == 0);
> 		goto repeat;
> 	}
> +	/* dont let a new handle start when a journal is frozen.
> +	 * jbd2_journal_freeze calls jbd2_journal_unlock_updates() only after
> +	 * the jflags indicate that the journal is frozen. So if the
> +	 * j_barrier_count is 0, then check if this was made 0 by the freezing
> +	 * process
> +	 */
> +	jbd2_check_frozen(journal);

This is called with read_lock(&journal->j_state_lock) held, so it seems that
the thread entering start_this_handle() will hold the j_state_lock the entire
time the journal is frozen.  But, see below in jbd2_journal_thaw()...

> 	if (!journal->j_running_transaction) {
> 		read_unlock(&journal->j_state_lock);
> @@ -489,6 +496,35 @@ int jbd2_journal_restart(handle_t *handle, int nblocks)
> }
> EXPORT_SYMBOL(jbd2_journal_restart);
> 
> +int jbd2_journal_freeze(journal_t *journal)
> +{
> +	int error = 0;
> +	/* Now we set up the journal barrier. */
> +	jbd2_journal_lock_updates(journal);
> +
> +	/*
> +	 * Don't clear the needs_recovery flag if we failed to flush
> +	 * the journal.
> +	 */
> +	error = jbd2_journal_flush(journal);
> +	if (error >= 0) {
> +		write_lock(&journal->j_state_lock);
> +		journal->j_flags = journal->j_flags | JBD2_FROZEN;
> +		write_unlock(&journal->j_state_lock);
> +	}
> +	jbd2_journal_unlock_updates(journal);
> +	return error;
> +}
> +
> +void jbd2_journal_thaw(journal_t * journal)
> +{
> +	write_lock(&journal->j_state_lock);
> +	journal->j_flags = journal->j_flags &= ~JBD2_FROZEN;
> +	write_unlock(&journal->j_state_lock);

... this code needs to get a write lock j_state_lock in order to unfreeze the
journal.  It seems that this would deadlock as soon as you actually had some
situation where a transaction is being started while the journal is frozen?

> +	wake_up(&journal->j_wait_frozen);
> +}
> +
> +
> /**
>  * void jbd2_journal_lock_updates () - establish a transaction barrier.
>  * @journal:  Journal to establish a barrier on.
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index a32dcae..31d6c23 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -835,6 +835,9 @@ struct journal_s
> 	/* Wait queue to wait for updates to complete */
> 	wait_queue_head_t	j_wait_updates;
> 
> +	/* Wait queue to wait for journal to thaw*/
> +	wait_queue_head_t	j_wait_frozen;
> +
> 	/* Semaphore for locking against concurrent checkpoints */
> 	struct mutex		j_checkpoint_mutex;
> 
> @@ -1013,7 +1016,11 @@ struct journal_s
> #define JBD2_ABORT_ON_SYNCDATA_ERR	0x040	/* Abort the journal on file
> 						 * data write error in ordered
> 						 * mode */
> +#define JBD2_FROZEN	0x080   /* Journal thread is frozen as the filesystem is frozen */
> +
> 
> +#define jbd2_check_frozen(journal)	\
> +		wait_event(journal->j_wait_frozen, ((journal->j_flags & JBD2_FROZEN) != JBD2_FROZEN))

It seems that what is needed here is to check the JBD2_FROZEN state under
lock (so that it is not racing with the flag being set) but drop the lock,
wait, and retry if the journal was actually frozen.  Since "goto label" is
ugly from within a macro, this probably needs to be open-coded at the caller in start_this_handle(), something like:

	if (journal->j_flags & JBD2_FROZEN) {
		read_unlock(&journal->j_state_lock);
		wait_event(journal->j_wait_frozen, journal->j_flags&JBD2_FROZEN);
		goto repeat;
	}

This opens the question of whether it is SMP safe to check j_flags without any kind of barrier or lock held?  I think in this case we are fine, since the above code jumps back to "repeat" to re-verify j_flags under j_state_lock, so there is no race on the state.

>  * Function declarations for the journaling transaction and buffer
>  * management
> @@ -1121,6 +1128,8 @@ extern void	 jbd2_journal_invalidatepage(journal_t *,
> 				struct page *, unsigned long);
> extern int	 jbd2_journal_try_to_free_buffers(journal_t *, struct page *, gfp_t);
> extern int	 jbd2_journal_stop(handle_t *);
> +extern int	 jbd2_journal_freeze(journal_t *);
> +extern void	 jbd2_journal_thaw(journal_t *);
> extern int	 jbd2_journal_flush (journal_t *);
> extern void	 jbd2_journal_lock_updates (journal_t *);
> extern void	 jbd2_journal_unlock_updates (journal_t *);
> -- 
> 1.7.1
> 


Cheers, Andreas





