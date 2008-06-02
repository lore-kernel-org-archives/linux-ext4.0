From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Mon, 2 Jun 2008 11:35:00 +0200
Message-ID: <20080602093459.GC30613@duck.suse.cz>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33477 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750735AbYFBJfB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 05:35:01 -0400
Content-Disposition: inline
In-Reply-To: <1212154769-16486-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> @@ -1052,6 +1051,7 @@ static int __mpage_da_writepage(struct page *page,
>  		head = page_buffers(page);
>  		bh = head;
>  		do {
> +
  I guess this line is a typo.

>  			BUG_ON(buffer_locked(bh));
>  			if (buffer_dirty(bh))
>  				mpage_add_bh_to_extent(mpd, logical, bh);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 789b6ad..655b8bf 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -881,7 +881,12 @@ int write_cache_pages(struct address_space *mapping,
>  	pagevec_init(&pvec, 0);
>  	if (wbc->range_cyclic) {
>  		index = mapping->writeback_index; /* Start from prev offset */
> -		end = -1;
> +		/*
> +		 * write only till the specified range_end even in cyclic mode
> +		 */
> +		end = wbc->range_end >> PAGE_CACHE_SHIFT;
> +		if (!end)
> +			end = -1;
>  	} else {
>  		index = wbc->range_start >> PAGE_CACHE_SHIFT;
>  		end = wbc->range_end >> PAGE_CACHE_SHIFT;
  Are you sure you won't break other users of range_cyclic with this
change?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
