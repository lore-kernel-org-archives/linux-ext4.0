From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH-v2] JBD: Fix race between free buffer and commit
	trasanction
Date: Wed, 21 May 2008 10:14:53 -0700
Message-ID: <1211390093.5571.16.camel@BVR-FS.beaverton.ibm.com>
References: <1210786872.3657.48.camel@localhost.localdomain>
	 <20080514181444.GI24363@duck.suse.cz>
	 <1210947250.3608.18.camel@localhost.localdomain>
	 <1210957976.4231.31.camel@badari-desktop>
	 <1210971693.3608.46.camel@localhost.localdomain>
	 <20080518223739.GB11006@atrey.karlin.mff.cuni.cz>
	 <1211227158.3663.25.camel@localhost.localdomain>
	 <20080519132553.de9b78b0.akpm@linux-foundation.org>
	 <1211234829.3663.39.camel@localhost.localdomain>
	 <1211306575.3664.19.camel@localhost.localdomain>
	 <20080520235303.GB23521@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44480 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936195AbYEURRm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2008 13:17:42 -0400
In-Reply-To: <20080520235303.GB23521@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2008-05-21 at 01:53 +0200, Jan Kara wrote:
> > JBD: fix race between journal_try_to_free_buffers() and jbd commit transaction
> > 
> > From: Mingming Cao <cmm@us.ibm.com>
> > 
> > journal_try_to_free_buffers() could race with jbd commit transaction when
> > the later is holding the buffer reference while waiting for the data buffer
> > to flush to disk. If the caller of journal_try_to_free_buffers() request
> > tries hard to release the buffers, it will treat the failure as error and return
> > back to the caller. We have seen the directo IO failed due to this race. 
> > Some of the caller of releasepage() also expecting the buffer to be dropped
> > when passed with GFP_KERNEL mask to the releasepage()->journal_try_to_free_buffers().
> > 
> > With this patch, if the caller is passing the GFP_KERNEL to indicating this
> > call could wait, in case of try_to_free_buffers() failed, let's waiting for
> > journal_commit_transaction() to finish commit the current committing transaction
> > , then try to free those buffers again with journal locked.
> > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com> 
> > ---
> >  fs/jbd/transaction.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++--
> >  mm/filemap.c         |    3 --
> >  2 files changed, 54 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6.26-rc2/fs/jbd/transaction.c
> > ===================================================================
> > --- linux-2.6.26-rc2.orig/fs/jbd/transaction.c	2008-05-11 17:09:41.000000000 -0700
> > +++ linux-2.6.26-rc2/fs/jbd/transaction.c	2008-05-19 16:16:41.000000000 -0700
> > @@ -1648,12 +1648,39 @@ out:
> >  	return;
> >  }
> >  
> > +/*
> > + * journal_try_to_free_buffers() could race with journal_commit_transaction()
> > + * The later might still hold the reference count to the buffers when inspecting
> > + * them on t_syncdata_list or t_locked_list.
> > + *
> > + * Journal_try_to_free_buffers() will call this function to
> > + * wait for the current transaction to finish syncing data buffers, before
> > + * try to free that buffer.
> > + *
> > + * Called with journal->j_state_lock hold.
> > + */
> > +static void journal_wait_for_transaction_sync_data(journal_t *journal)
> > +{
> > +	transaction_t *transaction = NULL;
> > +	tid_t tid;
> > +
> > +	transaction = journal->j_committing_transaction;
> > +
> > +	if (!transaction)
> > +		return;
> > +
> > +	tid = transaction->t_tid;
> > +	spin_unlock(&journal->j_state_lock);
> > +	log_wait_commit(journal, tid);
> > +	spin_lock(&journal->j_state_lock);
> > +}
>   What is actually the point of entering the function with j_state_lock
> held and also keeping it after return? It should be enough to take it
> and release it just inside this function, shouldn't it?
> 

I was worried about the case when we call try_to_free_buffers() again,
it races with the current transaction commit again. Is it possible? I
guess the question is whether it is possible to have buffers on the same
page attached to different transaction.  If so, I think we need to keep
the journal state lock while retry try_to_free_buffers(), so that the
retry won't race with the commit transaction again...

> >  /**
> >   * int journal_try_to_free_buffers() - try to free page buffers.
> >   * @journal: journal for operation
> >   * @page: to try and free
> > - * @unused_gfp_mask: unused
> > + * @gfp_mask: specifies whether the call may block
> > + * 		(__GFP_WAIT & __GFP_FS via GFP_KERNEL)
>   This comment seems a bit misleading to me - I'd rather write there:
> 
> @gfp_mask: we use the mask to detect how hard should we try to release
> buffers. If __GFP_WAIT and __GFP_FS is set, we wait for commit code to
> release the buffers.
> 

Sure.

> >   *
> >   *
> >   * For all the buffers on this page,
> > @@ -1682,9 +1709,11 @@ out:
> >   * journal_try_to_free_buffer() is changing its state.  But that
> >   * cannot happen because we never reallocate freed data as metadata
> >   * while the data is part of a transaction.  Yes?
> > + *
> > + * Return 0 on failure, 1 on success
> >   */
> >  int journal_try_to_free_buffers(journal_t *journal,
> > -				struct page *page, gfp_t unused_gfp_mask)
> > +				struct page *page, gfp_t gfp_mask)
> >  {
> >  	struct buffer_head *head;
> >  	struct buffer_head *bh;
> > @@ -1713,7 +1742,30 @@ int journal_try_to_free_buffers(journal_
> >  		if (buffer_jbd(bh))
> >  			goto busy;
> >  	} while ((bh = bh->b_this_page) != head);
> > +
> >  	ret = try_to_free_buffers(page);
> > +
> > + 	/*
> > +	 * There are a number of places where journal_try_to_free_buffers()
> > +	 * could race with journal_commit_transaction(), the later still
> > +	 * holds the reference to the buffers to free while processing them.
> > +	 * try_to_free_buffers() failed to free those buffers. Some of the
> > +	 * caller of releasepage() request page buffers to be dropped, otherwise
> > +	 * treat the fail-to-free as errors (such as generic_file_direct_IO())
> > +	 *
> > +	 * So, if the caller of try_to_release_page() wants the synchronous
> > +	 * behaviour(i.e make sure buffers are dropped upon return),
> > +	 * let's wait for the current transaction to finish flush of
> > +	 * dirty data buffers, then try to free those buffers again,
> > +	 * with the journal locked.
> > +	 */
> > +	if (ret == 0 && gfp_mask & GFP_KERNEL) {
>   I think this test is wrong - it should rather be something like
> (ret == 0 && (gfp_mask & GFP_KERNEL == GFP_KERNEL)) - or even expand the
> test to gfp_mask & __GFP_WAIT && gfp_mask & __GFP_FS && gfp_mask &
> __GFP_IO.
> 

Thanks for pointing this out.

> > +        	spin_lock(&journal->j_state_lock);
> > +		journal_wait_for_transaction_sync_data(journal);
> > +		ret = try_to_free_buffers(page);
> > +		spin_unlock(&journal->j_state_lock);
> > +	}
> > +
> >  busy:
> >  	return ret;
> >  }
> > Index: linux-2.6.26-rc2/mm/filemap.c
> > ===================================================================
> > --- linux-2.6.26-rc2.orig/mm/filemap.c	2008-05-19 16:00:01.000000000 -0700
> > +++ linux-2.6.26-rc2/mm/filemap.c	2008-05-19 16:01:34.000000000 -0700
> > @@ -2581,9 +2581,8 @@ out:
> >   * Otherwise return zero.
> >   *
> >   * The @gfp_mask argument specifies whether I/O may be performed to release
> > - * this page (__GFP_IO), and whether the call may block (__GFP_WAIT).
> > + * this page (__GFP_IO), and whether the call may block (__GFP_WAIT & __GFP_FS).
>   Probably __GFP_WAIT | __GFP_IO here... But I'm not sure why do we
> really change this...
> 

For try_to_release_page(),we should wait only when (__GFP_WAIT &
__GFP_FS), isn't it?

> >   *
> > - * NOTE: @gfp_mask may go away, and this function may become non-blocking.
> >   */
> >  int try_to_release_page(struct page *page, gfp_t gfp_mask)
> >  {
> > 
> 
> 								Honza

Thanks, patch v3 to follow.

Mingming

