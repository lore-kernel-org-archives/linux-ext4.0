From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] fix journal overflow problem
Date: Fri, 22 Feb 2008 11:08:47 +0100
Message-ID: <20080222100847.GB12908@duck.suse.cz>
References: <200802211358.56015.jbacik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35631 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751171AbYBVKIt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 05:08:49 -0500
Content-Disposition: inline
In-Reply-To: <200802211358.56015.jbacik@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 21-02-08 13:58:55, Josef Bacik wrote:
> This is related to that jbd patch I sent a few weeks ago.  I originally
> found that the problem where t_nr_buffers would be > than
> t_outstanding_credits wouldn't happen upstream, but apparently I'm an
> idiot and I was just missing my messsages, and the problem does exist.
> Now for the entirely too long of a description of whats going wrong.
> 
> Say we have a transaction dirty a bitmap buffer and go to flush it to the
> disk.  Then ext3 goes to get write access to that buffer via
> journal_get_undo_access(), finds out it doesn't need it, and then
> subsequently does a journal_release_buffer() and then proceeds to never
> touch that buffer again.  Then the original committing transaction will
> go through and add its buffers to the checkpointing list, and refile the
> buffer.  Because we did a journal_get_undo_access(), the
> jh->b_next_transaction is set to our currently running transaction, and
> that buffer because it was set BH_JBDDirty by the committing transaction
> is filed onto the running transactions BJ_Metadata list, which increments
> our t_nr_buffers counter.  Because we never actually dirtied this buffer
> ourselves, we never accounted for the credit, and we end up with
> t_outstanding_credits being less than t_nr_buffers.
  Thanks for the debugging. You're right that such situation can happen
and we then miscount the transactions credits. Actually, we miscount the
credits whenever we do journal_get_write_access() on a jbd_dirty buffer
that isn't yet in our transaction and don't call journal_dirty_metadata()
later.

> This is a problem because while we are writing out the metadata blocks to
> the journal, we do a t_outstanding_credits-- for each buffer.  If
> t_outstanding_credits is less than the number of buffers we have then
> t_outstanding_credits will eventually become negative, which means that
> jbd_space_needed will eventually start saying it needs way less credits
> than it actually does, and will allow transactions to grow huge and
> eventually we'll overflow the journal (albeit this is a bitch to try and
> reproduce).
  Yes, actually, how much negative t_outstanding_credits grow? I'd expect
that this is not too common situation...

> So my approach is to have a counter that is incremented each time the
> transaction calls do_get_write_access (or journal_get_create_access) so
> we can keep track of how many people are currently trying to modify that
> buffer.  So in the case where we do a
> journal_get_undo_access()+journal_release_buffer() and nobody else ever
> touches the buffer, we can then set jh->b_next_transaction to NULL in
> journal_release_buffer() and avoid having the buffer filed onto our
> transaction.  If somebody else is modifying the journal head then we know
> to leave it alone because chances are it will be dirtied and the credit
> will be accounted for.
  But the race is still possibly there in case we refile the buffer from
t_forget list just between do_get_write_access() and
journal_release_buffer(), isn't it?
  And it would be quite hard to get rid of such races. So maybe how about
the following: In do_get_write_access() (or journal_get_create_access())
when we see the buffer is jbddirty and we set j_next_transaction to our
transaction, we also set j_modified to 1. That should fix the accounting of
transaction credits. I agree that sometimes we needlessly refile some
buffers from the previous transaction but as I said above, it shouldn't be
that much (and we did it up to now anyway).
 
> There is also a slight change to how we reset b_modified.  I originally
> reset b_nr_access (my access counter) in the same way b_modified was
> reset, but I didn't really like this because we were only taking the
> j_list_lock instead of the jbd_buffer lock, so we could race and still
> end up in the same situation (which is in fact what happened).  So I've
  Yes, that is a good catch.

> changed how we reset b_modified.  Instead of looping through all of the
> buffers for the transaction, which is a little innefficient anyway, we
> reset it in do_get_write_access in the cases where we know that this is
> the first time that this transaction has accessed the buffer (ie when
> b_next_transaction != transaction && b_transaction != transaction).  I
> reset b_nr_access in the same way.  I ran tests with this patch and
> verified that we no longer got into the situation where
> t_outstanding_credits was less than t_nr_buffers.
> 
> This is just my patch that I was using, I plan on cleaning it up if this
> is an acceptable way to fix the problem.  I'd also like to put an ASSERT
> before we process the t_buffers list for the case where
> t_outstanding_credits is less than t_nr_buffers.  If my particular
> solution isn't acceptable I'm open to suggestions, however I still think
> that resetting b_modified should be changed the way I have it as its a
> potential race condition and innefficient.  Thanks much,
  I agree with the b_modified change, but please send it as a separate
patch. For the credit accounting I'd rather go by the route I've suggested
above.

								Honza

> diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
> index a38c718..6cc0a1e 100644
> --- a/fs/jbd/commit.c
> +++ b/fs/jbd/commit.c
> @@ -407,22 +407,6 @@ void journal_commit_transaction(journal_t *journal)
>  	jbd_debug (3, "JBD: commit phase 2\n");
>  
>  	/*
> -	 * First, drop modified flag: all accesses to the buffers
> -	 * will be tracked for a new trasaction only -bzzz
> -	 */
> -	spin_lock(&journal->j_list_lock);
> -	if (commit_transaction->t_buffers) {
> -		new_jh = jh = commit_transaction->t_buffers->b_tnext;
> -		do {
> -			J_ASSERT_JH(new_jh, new_jh->b_modified == 1 ||
> -					new_jh->b_modified == 0);
> -			new_jh->b_modified = 0;
> -			new_jh = new_jh->b_tnext;
> -		} while (new_jh != jh);
> -	}
> -	spin_unlock(&journal->j_list_lock);
> -
> -	/*
>  	 * Now start flushing things to disk, in the order they appear
>  	 * on the transaction lists.  Data blocks go first.
>  	 */
> @@ -490,6 +474,11 @@ void journal_commit_transaction(journal_t *journal)
>  
>  	descriptor = NULL;
>  	bufs = 0;
> +
> +	if (commit_transaction->t_nr_buffers >
> +	    commit_transaction->t_outstanding_credits)
> +		printk(KERN_EMERG "nr buffers greater than outstanding credits\n");
> +
>  	while (commit_transaction->t_buffers) {
>  
>  		/* Find the next buffer to be journaled... */
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 3943a89..5059b79 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -1800,6 +1800,7 @@ static void __journal_remove_journal_head(struct 
> buffer_head *bh)
>  				printk(KERN_WARNING "%s: freeing "
>  						"b_committed_data\n",
>  						__FUNCTION__);
> +				dump_stack();
>  				jbd_free(jh->b_committed_data, bh->b_size);
>  			}
>  			bh->b_private = NULL;
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index 038ed74..db00d39 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -609,6 +609,13 @@ repeat:
>  		goto done;
>  
>  	/*
> +	 * This is the first time this transaction has touched this buffer
> +	 * reset b_modified and b_nr_access
> +	 */
> +	jh->b_modified = 0;
> +	jh->b_nr_access = 0;
> +
> +	/*
>  	 * If there is already a copy-out version of this buffer, then we don't
>  	 * need to make another one
>  	 */
> @@ -713,6 +720,11 @@ repeat:
>  	}
>  
>  done:
> +	/*
> +	 * Ok we got write access, update the access counter
> +	 */
> +	jh->b_nr_access++;
> +
>  	if (need_copy) {
>  		struct page *page;
>  		int offset;
> @@ -819,13 +831,33 @@ int journal_get_create_access(handle_t *handle, struct 
> buffer_head *bh)
>  	J_ASSERT_JH(jh, buffer_locked(jh2bh(jh)));
>  
>  	if (jh->b_transaction == NULL) {
> +		/*
> +		 * first time this transaction has touched this buffer,
> +		 * reset b_modified
> +		 */
> +		jh->b_modified = 0;
> +
>  		jh->b_transaction = transaction;
>  		JBUFFER_TRACE(jh, "file as BJ_Reserved");
>  		__journal_file_buffer(jh, transaction, BJ_Reserved);
>  	} else if (jh->b_transaction == journal->j_committing_transaction) {
>  		JBUFFER_TRACE(jh, "set next transaction");
> +
> +		if (jh->b_next_transaction != transaction) {
> +			/* reset b_modified */
> +			jh->b_modified = 0;
> +		}
> +
>  		jh->b_next_transaction = transaction;
>  	}
> +
> +	/*
> +	 * Nobody who calls journal_get_create_access calls
> +	 * journal_release_buffer, but if at some point somebody decides to
> +	 * we'll need this
> +	 */
> +	jh->b_nr_access++;
> +
>  	spin_unlock(&journal->j_list_lock);
>  	jbd_unlock_bh_state(bh);
>  
> @@ -1190,11 +1222,41 @@ out:
>   * journal_release_buffer: undo a get_write_access without any buffer
>   * updates, if the update decided in the end that it didn't need access.
>   *
> + * We decrement the b_nr_access as this person no longer requires write
> + * access to the buffer, and if nobody else requires write access then we want
> + * to set b_next_transaction to NULL in case this buffer is on the committing
> + * transaction, as it will get refiled onto this transaction without it being
> + * counted.  We don't worry about the case where this is the first time this
> + * jh has been used (ie jh->b_transaction == handle->h_transaction) since the
> + * beginning of the committing of this transaction will drop the jh.
>   */
>  void
>  journal_release_buffer(handle_t *handle, struct buffer_head *bh)
>  {
> +	struct journal_head *jh = bh2jh(bh);
>  	BUFFER_TRACE(bh, "entry");
> +
> +	jbd_lock_bh_state(bh);
> +	/*
> +	 * if nobody else has requested write access to this jh then set
> +	 * b_next_transaction to NULL to keep it from getting refiled onto
> +	 * this transaction
> +	 */
> +	if (!(--jh->b_nr_access)) {
> +
> +		/*
> +		 * A journal_get_undo_access()+journal_release_buffer() will
> +		 * leave undo-committed data that we no longer need
> +		 */
> +		if (jh->b_next_transaction && jh->b_committed_data) {
> +			jbd_free(jh->b_committed_data, bh->b_size);
> +			jh->b_committed_data = NULL;
> +		}
> +
> +		jh->b_next_transaction = NULL;
> +	}
> +
> +	jbd_unlock_bh_state(bh);
>  }
>  
>  /**
> @@ -1245,6 +1307,11 @@ int journal_forget (handle_t *handle, struct buffer_head 
> *bh)
>  	 */
>  	jh->b_modified = 0;
>  
> +	/*
> +	 * drop one of our write access credits
> +	 */
> +	jh->b_nr_access--;
> +
>  	if (jh->b_transaction == handle->h_transaction) {
>  		J_ASSERT_JH(jh, !jh->b_frozen_data);
>  
> diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
> index 8a62d1e..160f1d1 100644
> --- a/include/linux/journal-head.h
> +++ b/include/linux/journal-head.h
> @@ -39,6 +39,13 @@ struct journal_head {
>  	unsigned b_modified;
>  
>  	/*
> +	 * This is a counter of the number of things who have requested write
> +	 * access to this buffer by the current transaction
> +	 * [jbd_lock_bh_state()]
> +	 */
> +	unsigned b_nr_access;
> +
> +	/*
>  	 * Copy of the buffer data frozen for writing to the log.
>  	 * [jbd_lock_bh_state()]
>  	 */
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
