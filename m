From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] jbd2/log_wait_for_space: drop checkpoint mutex when
 waiting
Date: Mon, 10 Jun 2013 22:33:31 -0400
Message-ID: <20130611023331.GB23966@thunk.org>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370892723-30860-3-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370892723-30860-3-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 10, 2013 at 03:32:01PM -0400, Paul Gortmaker wrote:
> 
> What is interesting here, is that we call log_wait_commit, from
> within wait_for_space, but we are still holding the checkpoint_mutex
> as it surrounds mostly the whole of wait_for_space.  And then, as we
> are waiting, journal_commit_transaction can run, and if the JBD2_FLUSHED
> bit is set, then we will also try to take the same checkpoint_mutex.

>  			} else if (tid) {
> +				/*
> +				 * jbd2_journal_commit_transaction() may want
> +				 * to take the checkpoint_mutex if JBD2_FLUSHED
> +				 * is set.  So we need to temporarily drop it.
> +				 */
> +				mutex_unlock(&journal->j_checkpoint_mutex);
>  				jbd2_log_wait_commit(journal, tid);
> +				mutex_lock(&journal->j_checkpoint_mutex);
>  			} else {
>  				printk(KERN_ERR "%s: needed %d blocks and "
>  				       "only had %d space available\n",

After we execute the code in the else cause, we drop through to just
before the bottom of the while loop, where we see:

		mutex_unlock(&journal->j_checkpoint_mutex);
	}

So it would be better to change things like this instead, so we don't
end up grabbing and releasing the j_checkpoint_mutex unnecessarily:

 			} else if (tid) {
+				/*
+				 * jbd2_journal_commit_transaction() may want
+				 * to take the checkpoint_mutex if JBD2_FLUSHED
+				 * is set.  So we need to temporarily drop it.
+				 */
+				mutex_unlock(&journal->j_checkpoint_mutex);
 				jbd2_log_wait_commit(journal, tid);
+				write_lock(&journal->j_state_lock);
+				continue;
 			} else {
 				printk(KERN_ERR "%s: needed %d blocks and "
 				       "only had %d space available\n",

Could you try respinning the patch like this and testing the result?

Thanks,

						- Ted
