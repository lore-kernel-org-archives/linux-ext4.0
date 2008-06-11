From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Wed, 11 Jun 2008 19:48:14 +0200
Message-ID: <20080611174814.GK8121@duck.suse.cz>
References: <1212154769-16486-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602093459.GC30613@duck.suse.cz> <20080602095956.GB9225@skywalker> <20080602102759.GG30613@duck.suse.cz> <20080605135413.GI8942@skywalker> <20080605162209.GG27370@duck.suse.cz> <20080605191909.GD4723@skywalker> <20080611124157.GB8121@duck.suse.cz> <20080611135631.GA15169@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58849 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756856AbYFKRsQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 13:48:16 -0400
Content-Disposition: inline
In-Reply-To: <20080611135631.GA15169@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Attaching the updated patch.
> 
> Mingming,
> 
> Can you update the patchqueu with the  below attached patch ?
> 
> -aneesh
> 
> mm: Add range_cont mode for writeback.
> 
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> Filesystems like ext4 needs to start a new transaction in
> the writepages for block allocation. This happens with delayed
> allocation and there is limit to how many credits we can request
> from the journal layer. So we call write_cache_pages multiple
> times with wbc->nr_to_write set to the maximum possible value
> limitted by the max journal credits available.
> 
> Add a new mode to writeback that enables us to handle this
> behaviour. In the new mode we update the wbc->range_start
> to point to the new offset to be written. Next call to
> call to write_cache_pages will start writeout from  specified
> range_start offset. In the new mode we also limit writing
> to the specified wbc->range_end.
> 
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
> 
>  include/linux/writeback.h |    1 +
>  mm/page-writeback.c       |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index f462439..0d8573e 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -63,6 +63,7 @@ struct writeback_control {
>  	unsigned for_writepages:1;	/* This is a writepages() call */
>  	unsigned range_cyclic:1;	/* range_start is cyclic */
>  	unsigned more_io:1;		/* more io to be dispatched */
> +	unsigned range_cont:1;
>  };
>  
>  /*
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 789b6ad..ded57d5 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -956,6 +956,9 @@ int write_cache_pages(struct address_space *mapping,
>  	}
>  	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
>  		mapping->writeback_index = index;
> +
> +	if (wbc->range_cont)
> +		wbc->range_start = index << PAGE_CACHE_SHIFT;
>  	return ret;
>  }
>  EXPORT_SYMBOL(write_cache_pages);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
