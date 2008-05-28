From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH-v2] JBD: Fix race between free buffer and commit
	trasanction
Date: Wed, 28 May 2008 20:55:55 +0200
Message-ID: <20080528185554.GA16018@duck.suse.cz>
References: <1210971693.3608.46.camel@localhost.localdomain> <20080518223739.GB11006@atrey.karlin.mff.cuni.cz> <1211227158.3663.25.camel@localhost.localdomain> <20080519132553.de9b78b0.akpm@linux-foundation.org> <1211234829.3663.39.camel@localhost.localdomain> <1211306575.3664.19.camel@localhost.localdomain> <20080520235303.GB23521@atrey.karlin.mff.cuni.cz> <1211390093.5571.16.camel@BVR-FS.beaverton.ibm.com> <20080524224447.GE20563@atrey.karlin.mff.cuni.cz> <1211998739.3791.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48785 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340AbYE1Sz5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 14:55:57 -0400
Content-Disposition: inline
In-Reply-To: <1211998739.3791.20.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 28-05-08 11:18:59, Mingming Cao wrote:
> On Sun, 2008-05-25 at 00:44 +0200, Jan Kara wrote:
> > > On Wed, 2008-05-21 at 01:53 +0200, Jan Kara wrote:
> > > > >  fs/jbd/transaction.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > > > >  mm/filemap.c         |    3 --
> > > > >  2 files changed, 54 insertions(+), 4 deletions(-)
> > > > > 
> > > > > Index: linux-2.6.26-rc2/fs/jbd/transaction.c
> > > > > ===================================================================
> > > > > --- linux-2.6.26-rc2.orig/fs/jbd/transaction.c	2008-05-11 17:09:41.000000000 -0700
> > > > > +++ linux-2.6.26-rc2/fs/jbd/transaction.c	2008-05-19 16:16:41.000000000 -0700
> > > > > @@ -1648,12 +1648,39 @@ out:
> > > > >  	return;
> > > > >  }
> > > > >  
> > > > > +/*
> > > > > + * journal_try_to_free_buffers() could race with journal_commit_transaction()
> > > > > + * The later might still hold the reference count to the buffers when inspecting
> > > > > + * them on t_syncdata_list or t_locked_list.
> > > > > + *
> > > > > + * Journal_try_to_free_buffers() will call this function to
> > > > > + * wait for the current transaction to finish syncing data buffers, before
> > > > > + * try to free that buffer.
> > > > > + *
> > > > > + * Called with journal->j_state_lock hold.
> > > > > + */
> > > > > +static void journal_wait_for_transaction_sync_data(journal_t *journal)
> > > > > +{
> > > > > +	transaction_t *transaction = NULL;
> > > > > +	tid_t tid;
> > > > > +
> > > > > +	transaction = journal->j_committing_transaction;
> > > > > +
> > > > > +	if (!transaction)
> > > > > +		return;
> > > > > +
> > > > > +	tid = transaction->t_tid;
> > > > > +	spin_unlock(&journal->j_state_lock);
> > > > > +	log_wait_commit(journal, tid);
> > > > > +	spin_lock(&journal->j_state_lock);
> > > > > +}
> > > >   What is actually the point of entering the function with j_state_lock
> > > > held and also keeping it after return? It should be enough to take it
> > > > and release it just inside this function, shouldn't it?
> > > > 
> > > 
> > > I was worried about the case when we call try_to_free_buffers() again,
> > > it races with the current transaction commit again. Is it possible? I
> > > guess the question is whether it is possible to have buffers on the same
> > > page attached to different transaction.  If so, I think we need to keep
> > > the journal state lock while retry try_to_free_buffers(), so that the
> > > retry won't race with the commit transaction again...
> >   Well, but by the time log_wait_commit() finishes, it may well
> > happen that a new transaction is already started so your lock doesn't
> > help you much. And the page you are called on is actually locked, so
> > noone can really mess with it until you unlock it... So I think you can
> > just use the lock for obtaining tid and then drop it.
> > 
> 
> You are right that the page was locked during the process we are trying
> to free the buffer. so I agree it's safe to drop the lock. 
> 
> > 								Honza
> > 
> > PS: For JBD2 you'd need to be a bit more careful because you cannot call
> > log_wait_commit() while holding page lock (we have reversed locking
> > order for ext4) - but ordered-mode rewrite patch actually fixes this
> > problem and I'm going to submit the splitted patches on Monday or
> > Tuesday (I only need to test them that I didn't do something stupid
> > while porting them to ext4)...
> > 
> Thanks for pointing this out. I think when we put back the reversed
> locking order and new ordered mode the jbd2 patch could go away...
> 
> Updated patch for JBD (take 4) below.
> Mingming
> 
> JBD: fix race between journal_try_to_free_buffers() and jbd commit transaction
> 
> From: Mingming Cao <cmm@us.ibm.com>
> 
> journal_try_to_free_buffers() could race with jbd commit transaction when
> the later is holding the buffer reference while waiting for the data buffer
> to flush to disk. If the caller of journal_try_to_free_buffers() request
> tries hard to release the buffers, it will treat the failure as error and return
> back to the caller. We have seen the directo IO failed due to this race. 
> Some of the caller of releasepage() also expecting the buffer to be dropped
> when passed with GFP_KERNEL mask to the releasepage()->journal_try_to_free_buffers().
> 
> With this patch, if the caller is passing the GFP_KERNEL to indicating this
> call could wait, in case of try_to_free_buffers() failed, let's waiting for
> journal_commit_transaction() to finish commit the current committing transaction
> , then try to free those buffers again with journal locked.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com> 
> ---
>  fs/jbd/transaction.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  mm/filemap.c         |    3 --
>  2 files changed, 56 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.26-rc3/fs/jbd/transaction.c
> ===================================================================
> --- linux-2.6.26-rc3.orig/fs/jbd/transaction.c	2008-05-28 10:55:37.000000000 -0700
> +++ linux-2.6.26-rc3/fs/jbd/transaction.c	2008-05-28 10:57:32.000000000 -0700
> @@ -1648,12 +1648,42 @@ out:
>  	return;
>  }
>  
> +/*
> + * journal_try_to_free_buffers() could race with journal_commit_transaction()
> + * The later might still hold the reference count to the buffers when inspecting
> + * them on t_syncdata_list or t_locked_list.
> + *
> + * Journal_try_to_free_buffers() will call this function to
> + * wait for the current transaction to finish syncing data buffers, before
> + * try to free that buffer.
> + *
> + * Called with journal->j_state_lock hold.
> + */
> +static void journal_wait_for_transaction_sync_data(journal_t *journal)
> +{
> +	transaction_t *transaction = NULL;
> +	tid_t tid;
> +
> +	spin_lock(&journal->j_state_lock);
> +	transaction = journal->j_committing_transaction;
> +
> +	if (!transaction) {
> +		spin_unlock(&journal->j_state_lock);
> +		return;
> +	}
> +
> +	tid = transaction->t_tid;
> +	spin_unlock(&journal->j_state_lock);
> +	log_wait_commit(journal, tid);
> +}
>  
>  /**
>   * int journal_try_to_free_buffers() - try to free page buffers.
>   * @journal: journal for operation
>   * @page: to try and free
> - * @unused_gfp_mask: unused
> + * @gfp_mask: we use the mask to detect how hard should we try to release
> + * buffers. If __GFP_WAIT and __GFP_FS is set, we wait for commit code to
> + * release the buffers.
>   *
>   *
>   * For all the buffers on this page,
> @@ -1682,9 +1712,11 @@ out:
>   * journal_try_to_free_buffer() is changing its state.  But that
>   * cannot happen because we never reallocate freed data as metadata
>   * while the data is part of a transaction.  Yes?
> + *
> + * Return 0 on failure, 1 on success
>   */
>  int journal_try_to_free_buffers(journal_t *journal,
> -				struct page *page, gfp_t unused_gfp_mask)
> +				struct page *page, gfp_t gfp_mask)
>  {
>  	struct buffer_head *head;
>  	struct buffer_head *bh;
> @@ -1713,7 +1745,28 @@ int journal_try_to_free_buffers(journal_
>  		if (buffer_jbd(bh))
>  			goto busy;
>  	} while ((bh = bh->b_this_page) != head);
> +
>  	ret = try_to_free_buffers(page);
> +
> + 	/*
> +	 * There are a number of places where journal_try_to_free_buffers()
> +	 * could race with journal_commit_transaction(), the later still
> +	 * holds the reference to the buffers to free while processing them.
> +	 * try_to_free_buffers() failed to free those buffers. Some of the
> +	 * caller of releasepage() request page buffers to be dropped, otherwise
> +	 * treat the fail-to-free as errors (such as generic_file_direct_IO())
> +	 *
> +	 * So, if the caller of try_to_release_page() wants the synchronous
> +	 * behaviour(i.e make sure buffers are dropped upon return),
> +	 * let's wait for the current transaction to finish flush of
> +	 * dirty data buffers, then try to free those buffers again,
> +	 * with the journal locked.
> +	 */
> +	if (ret == 0 && (gfp_mask & GFP_KERNEL == GFP_KERNEL)) {
  I think Andrew prefered this test to be expanded but otherwise the patch
is fine now. You can add:
  Acked-by: Jan Kara <jack@suse.cz>

Thanks for solving this :)

> +		journal_wait_for_transaction_sync_data(journal);
> +		ret = try_to_free_buffers(page);
> +	}
> +
>  busy:
>  	return ret;
>  }
> Index: linux-2.6.26-rc3/mm/filemap.c
> ===================================================================
> --- linux-2.6.26-rc3.orig/mm/filemap.c	2008-05-28 10:55:38.000000000 -0700
> +++ linux-2.6.26-rc3/mm/filemap.c	2008-05-28 10:55:43.000000000 -0700
> @@ -2581,9 +2581,8 @@ out:
>   * Otherwise return zero.
>   *
>   * The @gfp_mask argument specifies whether I/O may be performed to release
> - * this page (__GFP_IO), and whether the call may block (__GFP_WAIT).
> + * this page (__GFP_IO), and whether the call may block (__GFP_WAIT & __GFP_FS).
>   *
> - * NOTE: @gfp_mask may go away, and this function may become non-blocking.
>   */
>  int try_to_release_page(struct page *page, gfp_t gfp_mask)
>  {
> 

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
