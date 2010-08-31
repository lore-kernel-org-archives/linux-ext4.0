From: Bill Fink <billfink@mindspring.com>
Subject: Re: [PATCH] ext4: fix 50% disk write performance regression
Date: Tue, 31 Aug 2010 00:53:09 -0400
Message-ID: <20100831005309.2457743d.billfink@mindspring.com>
References: <20100829231126.8d8b2086.billfink@mindspring.com>
	<4C7C7A72.3020001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org,
	bill.fink@nasa.gov
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:47204 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479Ab0HaExy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Aug 2010 00:53:54 -0400
In-Reply-To: <4C7C7A72.3020001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 30 Aug 2010, Eric Sandeen wrote:

> Can you give this a shot?
> 
> The first hunk is, I think, the biggest problem.  Even if
> we get the max number of pages we need, we keep scanning forward
> until "done" without doing any more actual, useful work.
> 
> The 2nd hunk is an oddity, some places assign nr_to_write
> to LONG_MAX, and we get here and multiply -that- by 8... giving
> us "-8" for nr_to_write, that can't help things when we
> do later comparisons on that number...
> 
> I also see us asking to find pages starting at "idx" and
> the first dirty page we find is well ahead of that,
> I'm not sure if that's indicative of a problem or not.
> 
> Anyway, want to give this a shot, in place of the patch you sent,
> and see how it fares compared to stock and/or with your patch?
> 
> It's build-and-sanity tested but not really performance tested here.
> 
> Thanks,
> -Eric

Great!  It looks like that does the trick.

2.6.35 + your patch:

i7test7% dd if=/dev/zero of=/i7raid/bill/testfile1 bs=1M count=32768
32768+0 records in
32768+0 records out
34359738368 bytes (34 GB) copied, 50.6702 s, 678 MB/s

That's the same performance as with my patch, and pretty darn
close to the original 2.6.31 performance.

						-Thanks a bunch

						-Bill



> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4b8debe..33c2167 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1207,8 +1207,10 @@ static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
>  				break;
>  			idx++;
>  			num++;
> -			if (num >= max_pages)
> -				break;
> +			if (num >= max_pages) {
> +				pagevec_release(&pvec);
> +				return num;
> +			}
>  		}
>  		pagevec_release(&pvec);
>  	}
> @@ -3002,7 +3004,7 @@ static int ext4_da_writepages(struct address_space *mapping,
>  	 * sbi->max_writeback_mb_bump whichever is smaller.
>  	 */
>  	max_pages = sbi->s_max_writeback_mb_bump << (20 - PAGE_CACHE_SHIFT);
> -	if (!range_cyclic && range_whole)
> +	if (!range_cyclic && range_whole && wbc->nr_to_write != LONG_MAX)
>  		desired_nr_to_write = wbc->nr_to_write * 8;
>  	else
>  		desired_nr_to_write = ext4_num_dirty_pages(inode, index,
