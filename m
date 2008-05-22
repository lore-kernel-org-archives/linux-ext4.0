From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2][TAKE3] JBD: Fix race between free buffer and commit
 trasanction
Date: Wed, 21 May 2008 22:57:49 -0700
Message-ID: <20080521225749.7a92ff22.akpm@linux-foundation.org>
References: <20080512155419.GD15856@duck.suse.cz>
	<1210639184.3661.43.camel@localhost.localdomain>
	<20080513145449.GC20806@duck.suse.cz>
	<1210717389.3638.24.camel@localhost.localdomain>
	<20080514170856.GH24363@duck.suse.cz>
	<1210786872.3657.48.camel@localhost.localdomain>
	<20080514181444.GI24363@duck.suse.cz>
	<1210947250.3608.18.camel@localhost.localdomain>
	<1210957976.4231.31.camel@badari-desktop>
	<1210971693.3608.46.camel@localhost.localdomain>
	<20080518223739.GB11006@atrey.karlin.mff.cuni.cz>
	<1211227158.3663.25.camel@localhost.localdomain>
	<20080519132553.de9b78b0.akpm@linux-foundation.org>
	<1211234829.3663.39.camel@localhost.localdomain>
	<1211306575.3664.19.camel@localhost.localdomain>
	<1211413087.8596.9.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, pbadari@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754389AbYEVF6e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2008 01:58:34 -0400
In-Reply-To: <1211413087.8596.9.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 21 May 2008 16:38:07 -0700 Mingming <cmm@us.ibm.com> wrote:
>
> Subject: [PATCH 1/2][TAKE3] JBD: Fix race between free buffer and commit trasanction

"fix race between buffer freeing and transaction commit", perhaps.

> Changes since take 2:
> - fix a bug pointed by Jan, and updated the comments
> 
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
> --- linux-2.6.26-rc3.orig/fs/jbd/transaction.c	2008-05-21 16:17:51.000000000 -0700
> +++ linux-2.6.26-rc3/fs/jbd/transaction.c	2008-05-21 16:20:11.000000000 -0700
> @@ -1648,12 +1648,40 @@ out:
>  	return;
>  }
>  
> +/*
> + * journal_try_to_free_buffers() could race with journal_commit_transaction()
> + * The later might still hold the reference count to the buffers when inspecting

"latter"
"hold a reference on"

> + * them on t_syncdata_list or t_locked_list.
> + *
> + * Journal_try_to_free_buffers() will call this function to

"journal_try_to_free_buffers"

> + * wait for the current transaction to finish syncing data buffers, before
> + * try to free that buffer.

"trying"

> + *
> + * Called with journal->j_state_lock hold.

"held"

> + */
> +static void journal_wait_for_transaction_sync_data(journal_t *journal)
> +{
> +	transaction_t *transaction = NULL;

Unneeded initialisation.  Could just do

	transaction_t *transaction = journal->j_committing_transaction;

> +	tid_t tid;
> +
> +	transaction = journal->j_committing_transaction;
> +
> +	if (!transaction)
> +		return;
> +
> +	tid = transaction->t_tid;
> +	spin_unlock(&journal->j_state_lock);
> +	log_wait_commit(journal, tid);
> +	spin_lock(&journal->j_state_lock);
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
> @@ -1682,9 +1710,11 @@ out:
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
> @@ -1713,7 +1743,30 @@ int journal_try_to_free_buffers(journal_
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

"the latter still holds a reference on the buffers"

> +	 * try_to_free_buffers() failed to free those buffers. Some of the
> +	 * caller of releasepage() request page buffers to be dropped, otherwise

"callers"
"request the"

>	 * treat the fail-to-free as errors (such as generic_file_direct_IO())
> +	 *
> +	 * So, if the caller of try_to_release_page() wants the synchronous
> +	 * behaviour(i.e make sure buffers are dropped upon return),
> +	 * let's wait for the current transaction to finish flush of

"the flush"

> +	 * dirty data buffers, then try to free those buffers again,
> +	 * with the journal locked.
> +	 */
> +	if (ret == 0 && (gfp_mask & GFP_KERNEL == GFP_KERNEL)) {

Sorry about all the spelling flames ;) I'd normally just fix them
myself rather than typing them all into an email and having you type
them in again, etc.  But I think the patch needs to be respun anyway.

The mask-and-compare with GFP_KERNEL does appear to be correct, but it
is quite unusual.  Generally in a situation like this we will test for
the specific __GFP_foo flags which we're interested in.  For
documentation reasons if nothing else.

So the preferred form here would be

	if (ret == 0 &&
		(gfp_mask & (__GFP_WAIT|__GFP_FS)) == (__GFP_WAIT|__GFP_FS)) {

which really tells the reader what we're trying to do here.  And I
don't think this code cares about __GFP_IO, even though it would be
mighty peculirr (probably buggy) for someone to do
alloc_pages(__GFP_FS|__GFP_WAIT).


> +        	spin_lock(&journal->j_state_lock);
> +		journal_wait_for_transaction_sync_data(journal);
> +		ret = try_to_free_buffers(page);
> +		spin_unlock(&journal->j_state_lock);
> +	}

Did we actually need to hold j_state_lock across the
try_to_free_buffers() call here?  Because it'll increase hold times and
will introduce a lock-ranking dependency which we might not otherwise
have had (I didn't check).


>  busy:
>  	return ret;
>  }
> Index: linux-2.6.26-rc3/mm/filemap.c
> ===================================================================
> --- linux-2.6.26-rc3.orig/mm/filemap.c	2008-05-21 16:17:51.000000000 -0700
> +++ linux-2.6.26-rc3/mm/filemap.c	2008-05-21 16:17:58.000000000 -0700
> @@ -2581,9 +2581,8 @@ out:
>   * Otherwise return zero.
>   *
>   * The @gfp_mask argument specifies whether I/O may be performed to release
> - * this page (__GFP_IO), and whether the call may block (__GFP_WAIT).
> + * this page (__GFP_IO), and whether the call may block (__GFP_WAIT & __GFP_FS).
>   *
> - * NOTE: @gfp_mask may go away, and this function may become non-blocking.

Yup, that note is dead.

>   */
>  int try_to_release_page(struct page *page, gfp_t gfp_mask)
>  {
> 
