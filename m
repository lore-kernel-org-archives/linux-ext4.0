From: Jan Kara <jack@suse.cz>
Subject: Re: (take 2)[PATCH] JBD: positively dispose the unmapped data buffers in journal_commit_transaction
Date: Wed, 25 Jun 2008 22:39:22 +0200
Message-ID: <20080625203922.GA8711@atrey.karlin.mff.cuni.cz>
References: <485F8263.8000103@jp.fujitsu.com> <20080623192731.baf0904a.akpm@linux-foundation.org> <4860A9E8.9090103@jp.fujitsu.com> <4861F4BF.5060408@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44408 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYFYUjX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jun 2008 16:39:23 -0400
Content-Disposition: inline
In-Reply-To: <4861F4BF.5060408@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> I updated my patch and introduction article for it by reflecting
> the comment of Andrew's.
> 
> I think that this fix doesn't introduce other problems because
> I only add the code which releases the pages (and buffers) which
> should be released originally, and I have never experienced any
> problems while performing long run test.
> 
> Please confirm them.
> 
> This patch is for 2.6.26-rc6.
> ---
> [Problem]
> After ext3-ordered files are truncated, there is a possibility
> that the pages which cannot be estimated still remain. Remaining
> pages can be released when the system has really few memory.
> So, it is not memory leakage. But the resource management
> software etc. may not work correctly.
> 
> [Description]
> It is possible that journal_unmap_buffer() cannot release
> the buffers, and the pages to which they belong because
> they are attached to a commiting transaction and
> journal_unmap_buffer() cannot release them.
> To release such the buffers and the pages later,
> journal_unmap_buffer() leaves it to journal_commit_transaction().
> (journal_unmap_buffer() puts the mark 'BH_Freed' to the buffers
> so that journal_commit_transaction() can identify whether they
> can be released or not.)
> 
> In the journalled mode and the writeback mode, jbd does with only
> metadata buffers.  But in the ordered mode, jbd does with metadata
> buffers and also data buffers.
> 
> Actually, journal_commit_transaction() releases only the metadata
> buffers of which release is demanded by journal_unmap_buffer(),
> and also releases the pages to which they belong if possible.
> 
> As a result, the data buffers of which release is demanded
> by journal_unmap_buffer() remain after a transaction commits.
> And also the pages to which they belong remain.
> 
> Such the remained pages don't have mapping any longer.
> Due to this fact, there is a possibility that the pages which
> cannot be estimated remain.
> 
> [How to fix]
> The metadata buffers marked 'BH_Freed' and the pages to which
> they belong can be released at 'JBD: commit phase 7'.
> 
> Therefore, by applying the same code into 'JBD: commit phase 2'
> (where the data buffers are done with),
> journal_commit_transaction() can also release the data buffers
> marked 'BH_Freed' and the pages to which they belong.
> 
> As a result, all the buffers marked 'BH_Freed' can be released,
> and also all the pages to which these buffers belong can be
> released at journal_commit_transaction().
> So, the page which cannot be estimated is lost.
> 
  <snip>

> [Additional information]
> At journal_commit_transaction() code,
> there is one extra message in the series of jbd debug messages.
> ("JBD: commit phase 2")
> This patch fixes it, too.
> 
> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
  I agree with the change. It's true that we can leave some anonymous
pages behind and it's nicer to the MM to release them earlier when we
know they will be never needed again. The patch looks fine to me, you
can add
  Acked-by: Jan Kara <jack@suse.cz>

  How much have you stressed the patched kernel? I suggest you use
fsxlinux and put some memory pressure to the system...

								Honza

> ---
>  fs/jbd/commit.c |   29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> --- linux-2.6.26-rc6.org/fs/jbd/commit.c	2008-06-13 
> 06:22:24.000000000 +0900
> +++ linux-2.6.26-rc6/fs/jbd/commit.c	2008-06-25 14:51:55.000000000 +0900
> @@ -36,7 +36,7 @@ static void journal_end_buffer_io_sync(s
> 
>  /*
>   * When an ext3-ordered file is truncated, it is possible that many pages 
>   are
> - * not sucessfully freed, because they are attached to a committing 
> transaction.
> + * not successfully freed, because they are attached to a committing 
> transaction.
>   * After the transaction commits, these pages are left on the LRU, with no
>   * ->mapping, and with attached buffers.  These pages are trivially 
>   reclaimable
>   * by the VM, but their apparent absence upsets the VM accounting, and it 
>   makes
> @@ -45,8 +45,8 @@ static void journal_end_buffer_io_sync(s
>   * So here, we have a buffer which has just come off the forget list.  
>   Look to
>   * see if we can strip all buffers from the backing page.
>   *
> - * Called under lock_journal(), and possibly under journal_datalist_lock.  
> The
> - * caller provided us with a ref against the buffer, and we drop that here.
> + * Called under journal->j_list_lock.  The caller provided us with a ref
> + * against the buffer, and we drop that here.
>   */
>  static void release_buffer_page(struct buffer_head *bh)
>  {
> @@ -78,6 +78,19 @@ nope:
>  }
> 
>  /*
> + * Decrement reference counter for data buffer. If it has been marked
> + * 'BH_Freed', release it and the page to which it belongs if possible.
> + */
> +static void release_data_buffer(struct buffer_head *bh)
> +{
> +	if (buffer_freed(bh)) {
> +		clear_buffer_freed(bh);
> +		release_buffer_page(bh);
> +	} else
> +		put_bh(bh);
> +}
> +
> +/*
>   * Try to acquire jbd_lock_bh_state() against the buffer, when j_list_lock 
>   is
>   * held.  For ranking reasons we must trylock.  If we lose, schedule away 
>   and
>   * return 0.  j_list_lock is dropped in this case.
> @@ -231,7 +244,7 @@ write_out_data:
>  			if (locked)
>  				unlock_buffer(bh);
>  			BUFFER_TRACE(bh, "already cleaned up");
> -			put_bh(bh);
> +			release_data_buffer(bh);
>  			continue;
>  		}
>  		if (locked && test_clear_buffer_dirty(bh)) {
> @@ -258,10 +271,10 @@ write_out_data:
>  			if (locked)
>  				unlock_buffer(bh);
>  			journal_remove_journal_head(bh);
> -			/* Once for our safety reference, once for
> +			/* One for our safety reference, other for
>  			 * journal_remove_journal_head() */
>  			put_bh(bh);
> -			put_bh(bh);
> +			release_data_buffer(bh);
>  		}
> 
>  		if (need_resched() || spin_needbreak(&journal->j_list_lock)) 
>  		{
> @@ -443,7 +456,7 @@ void journal_commit_transaction(journal_
>  		} else {
>  			jbd_unlock_bh_state(bh);
>  		}
> -		put_bh(bh);
> +		release_data_buffer(bh);
>  		cond_resched_lock(&journal->j_list_lock);
>  	}
>  	spin_unlock(&journal->j_list_lock);
> @@ -453,8 +466,6 @@ void journal_commit_transaction(journal_
> 
>  	journal_write_revoke_records(journal, commit_transaction);
> 
> -	jbd_debug(3, "JBD: commit phase 2\n");
> -
>  	/*
>  	 * If we found any dirty or locked buffers, then we should have
>  	 * looped back up to the write_out_data label.  If there weren't
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
