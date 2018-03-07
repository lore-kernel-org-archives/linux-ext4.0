From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/7] jbd2: if the journal is aborted then don't allow
 update of the log tail
Date: Wed, 7 Mar 2018 09:55:00 +0100
Message-ID: <20180307085500.prkmuiylpjwaptha@quack2.suse.cz>
References: <20180220023038.19883-1-tytso@mit.edu>
 <20180220023038.19883-7-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180220023038.19883-7-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 19-02-18 21:30:37, Theodore Ts'o wrote:
> This updates the jbd2 superblock unnecessarily, and on an abort we
> shouldn't truncate the log.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/journal.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index efa0c72a0b9f..dfb057900e79 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -974,7 +974,7 @@ int __jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
>  }
>  
>  /*
> - * This is a variaon of __jbd2_update_log_tail which checks for validity of
> + * This is a variation of __jbd2_update_log_tail which checks for validity of
>   * provided log tail and locks j_checkpoint_mutex. So it is safe against races
>   * with other threads updating log tail.
>   */
> @@ -1417,6 +1417,9 @@ int jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
>  	journal_superblock_t *sb = journal->j_superblock;
>  	int ret;
>  
> +	if (is_journal_aborted(journal))
> +		return -EIO;
> +
>  	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
>  	jbd_debug(1, "JBD2: updating superblock (start %lu, seq %u)\n",
>  		  tail_block, tail_tid);
> -- 
> 2.16.1.72.g5be1f00a9a
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
