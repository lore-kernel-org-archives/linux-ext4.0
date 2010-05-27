From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] writeback: pay attention to wbc->nr_to_write in
 write_cache_pages
Date: Thu, 27 May 2010 14:32:51 -0700
Message-ID: <20100527143251.5193842d.akpm@linux-foundation.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-5-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, jens.axboe@oracle.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759251Ab0E0VdY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 May 2010 17:33:24 -0400
In-Reply-To: <1274784852-30502-5-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 25 May 2010 20:54:10 +1000
Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> If a filesystem writes more than one page in ->writepage, write_cache_pages
> fails to notice this and continues to attempt writeback when wbc->nr_to_write
> has gone negative - this trace was captured from XFS:
> 
> 
>     wbc_writeback_start: towrt=1024
>     wbc_writepage: towrt=1024
>     wbc_writepage: towrt=0
>     wbc_writepage: towrt=-1
>     wbc_writepage: towrt=-5
>     wbc_writepage: towrt=-21
>     wbc_writepage: towrt=-85
> 
> This has adverse effects on filesystem writeback behaviour. write_cache_pages()
> needs to terminate after a certain number of pages are written, not after a
> certain number of calls to ->writepage are made.  This is a regression
> introduced by 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4, but cannot be reverted

It's conventional to identify commits by their title as well as their
hash.  So 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4 ("vfs: Add
no_nrwrite_index_update writeback control flag").  Because that commit
might have different hashes in different trees, I think.  A Linus idea.

I do this ten times a day - It's a PITA.

> directly due to subsequent bug fixes that have gone in on top of it.
> 
> This commit adds a ->writepage tracepoint inside write_cache_pages() (how the
> above trace was generated) and does the revert manually leaving the subsequent
> bug fixes in tact. ext4 is not affected by this as a previous commit in the

"intact".

> series stops ext4 from using the generic function.
> 
> -			if (nr_to_write > 0) {
> -				nr_to_write--;
> -				if (nr_to_write == 0 &&
> +			if (wbc->nr_to_write > 0) {
> +				if (--wbc->nr_to_write == 0 &&
>  				    wbc->sync_mode == WB_SYNC_NONE) {
>  					/*
>  					 * We stop writing back only if we are
> @@ -974,11 +973,8 @@ continue_unlock:
>  		end = writeback_index - 1;
>  		goto retry;
>  	}
> -	if (!wbc->no_nrwrite_index_update) {
> -		if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
> -			mapping->writeback_index = done_index;
> -		wbc->nr_to_write = nr_to_write;
> -	}
> +	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
> +		mapping->writeback_index = done_index;
>  
>  	return ret;

'bout time we fixed that.  I wonder why it took so long to find.
