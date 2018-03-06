From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/7] ext4: pass -ESHUTDOWN code to jbd2 layer
Date: Tue, 6 Mar 2018 18:10:41 +0100
Message-ID: <20180306171041.mz7qlpeikih6mtlg@quack2.suse.cz>
References: <20180220023038.19883-1-tytso@mit.edu>
 <20180220023038.19883-6-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180220023038.19883-6-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 19-02-18 21:30:36, Theodore Ts'o wrote:
> Previously the jbd2 layer assumed that a file system check would be
> required after a journal abort.  In the case of the deliberate file
> system shutdown, this should not be necessary.  Allow the jbd2 layer
> to distinguish between these two cases by using the ESHUTDOWN errno.
> 
> Also add proper locking to __journal_abort_soft().
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---

Maybe a cleaner api would be to have a separate JBD2 function like
jbd2_journal_abort_clean() that would just abort the journal without
setting an error to it.

> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 3fbf48ec2188..efa0c72a0b9f 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2105,12 +2108,22 @@ void __jbd2_journal_abort_hard(journal_t *journal)
>   * but don't do any other IO. */
>  static void __journal_abort_soft (journal_t *journal, int errno)
>  {
> -	if (journal->j_flags & JBD2_ABORT)
> -		return;
> +	int old_errno;
>  
> -	if (!journal->j_errno)
> +	write_lock(&journal->j_state_lock);
> +	old_errno = journal->j_errno;
> +	if (!journal->j_errno || errno == -ESHUTDOWN)
>  		journal->j_errno = errno;
>  
> +	if (journal->j_flags & JBD2_ABORT) {
> +		write_unlock(&journal->j_state_lock);
> +		if (!old_errno && old_errno != -ESHUTDOWN &&
> +		    errno == -ESHUTDOWN)
> +			jbd2_journal_update_sb_errno(journal);
> +		return;
> +	}
> +	write_unlock(&journal->j_state_lock);
> +

Is it really correct that once the filesystem gets shutdown you clear the
previous error from the journal? Because if we hit some real fs corruption,
the journal gets aborted, and then someone calls ext4_shutdown(), we'd
clear that error which looks like a bug to me because that shutdown hardly
fixes the fs corruption...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
