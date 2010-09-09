From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: RE: [PATCH] ext4: fix 50% disk write performance regression
Date: Wed, 8 Sep 2010 17:23:12 -0700
Message-ID: <469D2D911E4BF043BFC8AD32E8E30F5BF2CF8F@wdscexbe07.sc.wdc.com>
References: <20100829231126.8d8b2086.billfink@mindspring.com>	<4C7C7A72.3020001@redhat.com> <20100831005309.2457743d.billfink@mindspring.com> <4C7C8DAE.50902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wdscspam2.wdc.com ([129.253.170.131]:54887 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0IIAdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Sep 2010 20:33:51 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4C7C8DAE.50902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just wondering if this patch is adequate or there's more to come.

I want to put a fix into our 2.6.32 kernel.

Thanks.

> -----Original Message-----
> From: linux-ext4-owner@vger.kernel.org 
> [mailto:linux-ext4-owner@vger.kernel.org] On Behalf Of Eric Sandeen
> Sent: Monday, August 30, 2010 10:06 PM
> To: Bill Fink
> Cc: tytso@mit.edu; adilger@sun.com; 
> linux-ext4@vger.kernel.org; bill.fink@nasa.gov
> Subject: Re: [PATCH] ext4: fix 50% disk write performance regression
> 
> Bill Fink wrote:
> > On Mon, 30 Aug 2010, Eric Sandeen wrote:
> > 
> >> Can you give this a shot?
> >>
> >> The first hunk is, I think, the biggest problem.  Even if
> >> we get the max number of pages we need, we keep scanning forward
> >> until "done" without doing any more actual, useful work.
> >>
> >> The 2nd hunk is an oddity, some places assign nr_to_write
> >> to LONG_MAX, and we get here and multiply -that- by 8... giving
> >> us "-8" for nr_to_write, that can't help things when we
> >> do later comparisons on that number...
> >>
> >> I also see us asking to find pages starting at "idx" and
> >> the first dirty page we find is well ahead of that,
> >> I'm not sure if that's indicative of a problem or not.
> >>
> >> Anyway, want to give this a shot, in place of the patch you sent,
> >> and see how it fares compared to stock and/or with your patch?
> >>
> >> It's build-and-sanity tested but not really performance 
> tested here.
> >>
> >> Thanks,
> >> -Eric
> > 
> > Great!  It looks like that does the trick.
> > 
> > 2.6.35 + your patch:
> > 
> > i7test7% dd if=/dev/zero of=/i7raid/bill/testfile1 bs=1M count=32768
> > 32768+0 records in
> > 32768+0 records out
> > 34359738368 bytes (34 GB) copied, 50.6702 s, 678 MB/s
> > 
> > That's the same performance as with my patch, and pretty darn
> > close to the original 2.6.31 performance.
> 
> hah, that's good esp. considering my followup email that found
> what I think is a problem with my patch.  ;)
> 
> What happens if you change:
> 
> 	if (!range_cyclic && range_whole && wbc->nr_to_write != 
> LONG_MAX)
> 		desired_nr_to_write = wbc->nr_to_write * 8;
>   	else
>   		desired_nr_to_write = ext4_num_dirty_pages(inode, index,
> 
> to:
> 
>         if (!range_cyclic && range_whole) {
>                 if (wbc->nr_to_write != LONG_MAX)
>                         desired_nr_to_write = wbc->nr_to_write * 8;
>                 else
>                         desired_nr_to_write = wbc->nr_to_write;
>         } else
>   		desired_nr_to_write = ext4_num_dirty_pages(inode, index,
> 
> and see how that fares?  I think that makes a little more sense, if we
> got there with LONG_MAX that means "write everything" and 
> there's no need
> to bump it up or to go counting pages.  It may not make any 
> real difference.
> 
> But I'm seeing really weird behavior in writeback, it starts 
> out nicely
> writing 32768 pages at a time, and then goes all wonky, 
> revisiting pages
> it's already done and doing IO in little chunks.   This is 
> going to take
> some staring I think.
> 
> -Eric
> 
> 
> 
> > 						-Thanks a bunch
> > 
> > 						-Bill
> > 
> > 
> > 
> >> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >> index 4b8debe..33c2167 100644
> >> --- a/fs/ext4/inode.c
> >> +++ b/fs/ext4/inode.c
> >> @@ -1207,8 +1207,10 @@ static pgoff_t 
> ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
> >>  				break;
> >>  			idx++;
> >>  			num++;
> >> -			if (num >= max_pages)
> >> -				break;
> >> +			if (num >= max_pages) {
> >> +				pagevec_release(&pvec);
> >> +				return num;
> >> +			}
> >>  		}
> >>  		pagevec_release(&pvec);
> >>  	}
> >> @@ -3002,7 +3004,7 @@ static int ext4_da_writepages(struct 
> address_space *mapping,
> >>  	 * sbi->max_writeback_mb_bump whichever is smaller.
> >>  	 */
> >>  	max_pages = sbi->s_max_writeback_mb_bump << (20 - 
> PAGE_CACHE_SHIFT);
> :
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
