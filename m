From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] jbd2: fold __process_buffer() into
 jbd2_log_do_checkpoint()
Date: Tue, 2 Sep 2014 18:53:26 +0200
Message-ID: <20140902165326.GD19412@quack.suse.cz>
References: <1409624051-6902-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaIBQx3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Sep 2014 12:53:29 -0400
Content-Disposition: inline
In-Reply-To: <1409624051-6902-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 01-09-14 22:14:10, Ted Tso wrote:
> __process_buffer() is only called by jbd2_log_do_checkpoint(), and it
> had a very complex locking protocol where it would be called with the
> j_list_lock, and sometimes exit with the lock held (if the return code
> was 0), or release the lock.
> 
> This was confusing both to humans and to smatch (which erronously
> complained that the lock was taken twice).
> 
> Folding __process_buffer() to the caller allows us to simplify the
> control flow, making the resulting function easier to read and reason
> about, and dropping the compiled size of fs/jbd2/checkpoint.c by 150
> bytes (over 4% of the text size).
  This looks good. A few nits below but overall you can add:
Reviewed-by: Jan Kara <jack@suse.cz>

> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/jbd2/checkpoint.c | 195 ++++++++++++++++++++++-----------------------------
>  1 file changed, 84 insertions(+), 111 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 7f34f47..993a187 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
...
> +		"JBD2: %s: Waiting for Godot: block %llu\n",
> +		journal->j_devname, (unsigned long long) bh->b_blocknr);
> +
> +			jbd2_log_start_commit(journal, tid);
> +			jbd2_log_wait_commit(journal, tid);
> +			goto retry;
> +		}
> +		if (!buffer_dirty(bh)) {
> +			if (unlikely(buffer_write_io_error(bh)) && !result)
> +				result = -EIO;
> +			get_bh(bh);
> +			BUFFER_TRACE(bh, "remove from checkpoint");
> +			__jbd2_journal_remove_checkpoint(jh);
> +			spin_unlock(&journal->j_list_lock);
> +			__brelse(bh);
> +			goto retry;
>  		}
  Actually the get_bh / __brelse pair is unnecessary here and also we don't
have to retry here unless this was the last buffer.  But that's for a
separate cleanup patch (I can send it).

>  		/*
> -		 * Now we have cleaned up the first transaction's checkpoint
> -		 * list. Let's clean up the second one
> +		 * Important: we are about to write the buffer, and
> +		 * possibly block, while still holding the journal
> +		 * lock.  We cannot afford to let the transaction
> +		 * logic start messing around with this buffer before
> +		 * we write it to disk, as that would break
> +		 * recoverability.
>  		 */
> -		err = __wait_cp_io(journal, transaction);
> -		if (!result)
> -			result = err;
> +		BUFFER_TRACE(bh, "queue");
> +		get_bh(bh);
> +		J_ASSERT_BH(bh, !buffer_jwrite(bh));
> +		journal->j_chkpt_bhs[batch_count++] = bh;
> +		__buffer_relink_io(jh);
> +		transaction->t_chp_stats.cs_written++;
> +		if ((batch_count == JBD2_NR_BATCH) ||
> +		    need_resched() ||
> +		    spin_needbreak(&journal->j_list_lock))
> +			goto unlock_and_flush;
>  	}
> +
> +	if (batch_count) {
> +		unlock_and_flush:
> +			spin_unlock(&journal->j_list_lock);
> +		retry:
> +			if (batch_count)
> +				__flush_batch(journal, &batch_count);
> +			spin_lock(&journal->j_list_lock);
> +			goto restart;
> +	}
  This:
if (batch_count) {
...
	if (batch_count)
}
  looks strange but I don't see a cleaner solution :(.

								Honza

> +
> +	/*
> +	 * Now we issued all of the transaction's buffers, let's deal
> +	 * with the buffers that are out for I/O.
> +	 */
> +	err = __wait_cp_io(journal, transaction);
> +	if (!result)
> +		result = err;
>  out:
>  	spin_unlock(&journal->j_list_lock);
>  	if (result < 0)
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
