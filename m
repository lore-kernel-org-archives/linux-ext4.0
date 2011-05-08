From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH v2] Adding support to freeze and unfreeze a journal
Date: Sun, 08 May 2011 10:24:25 +0200
Message-ID: <4DC65339.7020608@gmail.com>
References: <AA6B40F6-33A1-4C0B-8F80-71509FFF106E@dilger.ca> <1304798662-3884-1-git-send-email-surbhi.palande@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: adilger.kernel@dilger.ca, jack@suse.cz,
	toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1304798662-3884-1-git-send-email-surbhi.palande@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Il 07/05/2011 22:04, Surbhi Palande ha scritto:
> On freezing the F.S, the journal should be frozen as well. This implies not
> being able to start any new transactions on a frozen journal. Similarly,
> thawing a F.S should thaw a journal and this should conversely start accepting
> new transactions. While the F.S is frozen any request to start a new
> handle should end up on a wait queue till the F.S is thawed back again.
>
> Adding support to freeze and thaw a journal and leveraging this support in
> freezing and thawing ext4.
>
> Signed-off-by: Surbhi Palande<surbhi.palande@canonical.com>
> ---
> Changes since v1:
> * Check for the j_flag and if frozen release the j_state_lock before sleeping
>     on wait queue
> * Export the freeze, thaw routines
> * Added a barrier after setting the j_flags = JBD2_FROZEN
>
>   fs/ext4/super.c       |   20 ++++++--------------
>   fs/jbd2/journal.c     |    1 +
>   fs/jbd2/transaction.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>   include/linux/jbd2.h  |    9 +++++++++
>   4 files changed, 59 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8553dfb..796aa4c 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4179,23 +4179,15 @@ static int ext4_freeze(struct super_block *sb)
>
>   	journal = EXT4_SB(sb)->s_journal;
>
> -	/* Now we set up the journal barrier. */
> -	jbd2_journal_lock_updates(journal);
> -
> +	error = jbd2_journal_freeze(journal);
>   	/*
> -	 * Don't clear the needs_recovery flag if we failed to flush
> +	 * Don't clear the needs_recovery flag if we failed to freeze
>   	 * the journal.
>   	 */
> -	error = jbd2_journal_flush(journal);
> -	if (error<  0)
> -		goto out;
> -
> -	/* Journal blocked and flushed, clear needs_recovery flag. */
> -	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> -	error = ext4_commit_super(sb, 1);
> -out:
> -	/* we rely on s_frozen to stop further updates */
> -	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
> +	if (error>= 0) {
> +		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> +		error = ext4_commit_super(sb, 1);
> +	}
>   	return error;
>   }
>
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index e0ec3db..5e46333 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -842,6 +842,7 @@ static journal_t * journal_init_common (void)
>   	init_waitqueue_head(&journal->j_wait_checkpoint);
>   	init_waitqueue_head(&journal->j_wait_commit);
>   	init_waitqueue_head(&journal->j_wait_updates);
> +	init_waitqueue_head(&journal->j_wait_frozen);
>   	mutex_init(&journal->j_barrier);
>   	mutex_init(&journal->j_checkpoint_mutex);
>   	spin_lock_init(&journal->j_revoke_lock);
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 05fa77a..3283c77 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -171,6 +171,17 @@ repeat:
>   				journal->j_barrier_count == 0);
>   		goto repeat;
>   	}
> +	/* dont let a new handle start when a journal is frozen.
> +	 * jbd2_journal_freeze calls jbd2_journal_unlock_updates() only after
> +	 * the jflags indicate that the journal is frozen. So if the
> +	 * j_barrier_count is 0, then check if this was made 0 by the freezing
> +	 * process
> +	 */
> +	if (journal->j_flags&  JBD2_FROZEN) {
> +		read_unlock(&journal->j_state_lock);
> +		jbd2_check_frozen(journal);
> +		goto repeat;
> +	}
>
>   	if (!journal->j_running_transaction) {
>   		read_unlock(&journal->j_state_lock);
> @@ -489,6 +500,38 @@ int jbd2_journal_restart(handle_t *handle, int nblocks)
>   }
>   EXPORT_SYMBOL(jbd2_journal_restart);
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
> +	if (error>= 0) {
> +		write_lock(&journal->j_state_lock);
> +		journal->j_flags = journal->j_flags | JBD2_FROZEN;

Better journal->j_flags |= JBD2_FROZEN;

> +		write_unlock(&journal->j_state_lock);
> +	}
> +	jbd2_journal_unlock_updates(journal);
> +	return error;
> +}
> +EXPORT_SYMBOL(jbd2_journal_freeze);
> +
> +void jbd2_journal_thaw(journal_t * journal)
> +{
> +	write_lock(&journal->j_state_lock);
> +	journal->j_flags = journal->j_flags&= ~JBD2_FROZEN;

What? Maybe journal->j_flags &= ~JBD2_FROZEN;

> +	write_unlock(&journal->j_state_lock);
> +	smp_wmb();

It'd be better to add a comment here for this barrier.

> +	wake_up(&journal->j_wait_frozen);
> +}
> +EXPORT_SYMBOL(jbd2_journal_thaw);
> +
> +

Marco
