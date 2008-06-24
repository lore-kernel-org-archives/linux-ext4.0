From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] JBD: positively dispose the unmapped data buffers in
 journal_commit_transaction
Date: Mon, 23 Jun 2008 19:27:31 -0700
Message-ID: <20080623192731.baf0904a.akpm@linux-foundation.org>
References: <485F8263.8000103@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbYFXC2W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2008 22:28:22 -0400
In-Reply-To: <485F8263.8000103@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 23 Jun 2008 20:00:51 +0900 Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> Hi.
> 
> I found the possibility that the system has the page which has
> buffers (are marked 'BH_Freed') without mapping. As a result,
> the resource management software etc. might not operate correctly
> because there is a possibility that the page which cannot be
> estimated exists.
> 
> I made a patch to positively release the pages that had the buffers
> which were marked 'BH_Freed'.
> 
> Please confirm it.
> 
> This patch is for 2.6.26-rc6.
> ---
> On ordered mode, before journal_commit_transaction does with
> t_locked_list, all data buffers which are requested to dispose
> by journal_unmap_buffer aren't disposed by JBD.

Why not?  What is it which prevents these buffers from being released
in the normal fashion?

> Such all data
> buffers are marked 'BH_Freed'. So, also pages corresponding
> to them aren't released by JBD. The pages have data buffers
> without mapping. Due to this fact, we cannot estimate free
> memory correctly when there are many pages which have data
> buffers without mapping. Therefore the resource management
> software cannot work correctly.
> But it is not memory leakage because the pages can be released
> when the system has really few available memory.
> 
> BTW,
> all metadata buffers on such situation are disposed at
> 'JBD: commit phase 7' by JBD and pages corresponding to them
> can be released on the same time.
> 
> Therefore, by applying the same statements as ones for disposing
> metadata buffers (marked 'BH_Freed'), JBD in
> journal_commit_transaction can release the pages which has data
> buffers without mapping.
> As a result, the page which cannot be estimated is lost.
> 

Are you sure that this change cannot reintroduce the problem which the
addition of buffer_freed() fixed?

> ---
>  fs/jbd/commit.c |   45 +++++++++++++++++++++++++++++++++++----------
>  1 files changed, 35 insertions(+), 10 deletions(-)
> --- linux-2.6.26-rc6.org/fs/jbd/commit.c	2008-06-13 06:22:24.000000000 +0900
> +++ linux-2.6.26-rc6/fs/jbd/commit.c	2008-06-19 14:44:29.000000000 +0900
> @@ -42,11 +42,11 @@ static void journal_end_buffer_io_sync(s
>   * by the VM, but their apparent absence upsets the VM accounting, and it makes
>   * the numbers in /proc/meminfo look odd.
>   *
> - * So here, we have a buffer which has just come off the forget list.  Look to
> - * see if we can strip all buffers from the backing page.
> + * So here, we have a buffer which has just come off the list.  Confirm if we
> + * can strip all buffers from the backing page.
>   *
> - * Called under lock_journal(), and possibly under journal_datalist_lock.  The
> - * caller provided us with a ref against the buffer, and we drop that here.
> + * Called under journal->j_list_lock.  The caller provided us with a ref
> + * against the buffer, and we drop that here.
>   */
>  static void release_buffer_page(struct buffer_head *bh)
>  {
> @@ -231,7 +231,16 @@ write_out_data:
>  			if (locked)
>  				unlock_buffer(bh);
>  			BUFFER_TRACE(bh, "already cleaned up");
> -			put_bh(bh);
> +			if (buffer_freed(bh)) {
> +				/* This bh has been marked 'BH_Feed'. */

"BH_Freed".

But the comment is rather unnecessary anyway.

> +				clear_buffer_freed(bh);
> +				/* Release the page if all other buffers
> +				 * that belong to the page that has this bh
> +				 * can be freed.
> +				 */
> +				release_buffer_page(bh);
> +			} else
> +				put_bh(bh);	

Perhaps the above code snippet shold be in a function rather than
repeated three times.

The patch adds new trailing whitespace.

>  			continue;
>  		}
>  		if (locked && test_clear_buffer_dirty(bh)) {
> @@ -258,10 +267,17 @@ write_out_data:
>  			if (locked)
>  				unlock_buffer(bh);
>  			journal_remove_journal_head(bh);
> -			/* Once for our safety reference, once for
> -			 * journal_remove_journal_head() */
> -			put_bh(bh);
> -			put_bh(bh);
> +			put_bh(bh); /* for journal_remove_journal_head() */
> +			if (buffer_freed(bh)) {
> +				/* This bh has been marked 'BH_Feed'. */
> +				clear_buffer_freed(bh);
> +				/* Release the page if all other buffers
> +				 * that belong to the page that has this bh
> +				 * can be freed.
> +				 */
> +				release_buffer_page(bh);
> +			} else
> +				put_bh(bh);
>  		}
> 
>  		if (need_resched() || spin_needbreak(&journal->j_list_lock)) {
> @@ -443,7 +459,16 @@ void journal_commit_transaction(journal_
>  		} else {
>  			jbd_unlock_bh_state(bh);
>  		}
> -		put_bh(bh);
> +		if (buffer_freed(bh)) {
> +			/* This bh has been marked 'BH_Feed'. */
> +			clear_buffer_freed(bh);
> +			/* Release the page if all other buffers
> +			 * that belong to the page that has this bh
> +			 * can be freed.
> +			 */
> +			release_buffer_page(bh);
> +		} else
> +			put_bh(bh);
>  		cond_resched_lock(&journal->j_list_lock);
>  	}
>  	spin_unlock(&journal->j_list_lock);
