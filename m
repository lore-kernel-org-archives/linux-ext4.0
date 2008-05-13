From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
Date: Tue, 13 May 2008 16:54:49 +0200
Message-ID: <20080513145449.GC20806@duck.suse.cz>
References: <20080428122626.GC17054@duck.suse.cz> <1209402694.23575.5.camel@badari-desktop> <20080428180932.GI17054@duck.suse.cz> <1209409764.11872.6.camel@localhost.localdomain> <20080429124321.GD1987@duck.suse.cz> <1209654981.27240.19.camel@badari-desktop> <20080505170636.GK25722@duck.suse.cz> <1210372072.3639.52.camel@localhost.localdomain> <20080512155419.GD15856@duck.suse.cz> <1210639184.3661.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Badari Pulavarty <pbadari@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46465 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753267AbYEMOyu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 May 2008 10:54:50 -0400
Content-Disposition: inline
In-Reply-To: <1210639184.3661.43.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 12-05-08 17:39:43, Mingming Cao wrote:
> On Mon, 2008-05-12 at 17:54 +0200, Jan Kara wrote:
> Does this match what you are thinking? It certainly slow down the DIO
> path, but the positive side is it doesn't disturb the other code path...
> thanks for your feedback!
> 
> --------------------------------------------
> 
> An unexpected EIO error gets returned when writing to a file
> using buffered writes and DIO writes at the same time.
> 
> We found there are a number of places where journal_try_to_free_buffers()
> could race with journal_commit_transaction(), the later still
> helds the reference to the buffers on the t_syncdata_list or t_locked_list
> , while journal_try_to_free_buffers() tries to free them, which resulting an EIO
> error returns back to the dio caller. 
> 
> The logic fix is to retry freeing if journal_try_to_free_buffers() to failed
> to free those data buffers while journal_commit_transaction() is still
> reference those buffers.
> This is done via implement ext3 launder_page() callback, instead of inside
> journal_try_to_free_buffers() itself, so that it doesn't affecting other code
> path calling journal_try_to_free_buffers and only dio path get affected.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> Index: linux-2.6.26-rc1/fs/ext3/inode.c
> ===================================================================
> --- linux-2.6.26-rc1.orig/fs/ext3/inode.c	2008-05-03 11:59:44.000000000 -0700
> +++ linux-2.6.26-rc1/fs/ext3/inode.c	2008-05-12 12:41:27.000000000 -0700
> @@ -1766,6 +1766,23 @@ static int ext3_journalled_set_page_dirt
>  	return __set_page_dirty_nobuffers(page);
>  }
>  
> +static int ext3_launder_page(struct page *page)
> +{
> +        int ret;
> +	int retry = 5;
> +
> +	while (retry --) {
> +		ret = ext3_releasepage(page, GFP_KERNEL);
> +		if (ret == 1)
> +			break;
> +		else
> +			schedule();
> +	}
> +
> +        return ret;
> +}
> +
> +
  Yes, I meant something like this. We could be more clever and do:

	head = bh = page_buffers(page);
	do {
		wait_on_buffer(bh);
		bh = bh->b_this_page;
	} while (bh != head);
	/*
	 * Now commit code should have been able to proceed and release
         * those buffers
	 */
        schedule();

or we could do simple:
	log_wait_commit(...);

That would impose larger perf. penalty but on the other hand you shouldn't
hit this path too often. But maybe the code above would be fine and would
handle most cases. Also please add a big comment to that function to explain
why this magic is needed.

>  static const struct address_space_operations ext3_ordered_aops = {
>  	.readpage	= ext3_readpage,
>  	.readpages	= ext3_readpages,
> @@ -1778,6 +1795,7 @@ static const struct address_space_operat
>  	.releasepage	= ext3_releasepage,
>  	.direct_IO	= ext3_direct_IO,
>  	.migratepage	= buffer_migrate_page,
> +	.launder_page	= ext3_launder_page,
>  };
>  
>  static const struct address_space_operations ext3_writeback_aops = {
> @@ -1792,6 +1810,7 @@ static const struct address_space_operat
>  	.releasepage	= ext3_releasepage,
>  	.direct_IO	= ext3_direct_IO,
>  	.migratepage	= buffer_migrate_page,
> +	.launder_page	= ext3_launder_page,
>  };
>  
>  static const struct address_space_operations ext3_journalled_aops = {
> @@ -1805,6 +1824,7 @@ static const struct address_space_operat
>  	.bmap		= ext3_bmap,
>  	.invalidatepage	= ext3_invalidatepage,
>  	.releasepage	= ext3_releasepage,
> +	.launder_page	= ext3_launder_page,
>  };
>  
>  void ext3_set_aops(struct inode *inode)
  Actually, we need .launder_page callback only in data=order mode.
data=writeback mode doesn't need it at all (journal code doesn't touch data
buffers there) and for data=journal mode DIO could have never worked
reasonably when mixed with buffered IO and it would have to do a different
and much more expensive trickery (like flushing the journal, or at least
forcing current transaction to commit).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
