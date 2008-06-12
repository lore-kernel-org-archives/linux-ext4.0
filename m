From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Thu, 12 Jun 2008 16:10:47 -0700
Message-ID: <1213312247.3698.29.camel@localhost.localdomain>
References: <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1212154769-16486-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1212154769-16486-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20080602093459.GC30613@duck.suse.cz> <20080602095956.GB9225@skywalker>
	 <20080602102759.GG30613@duck.suse.cz> <20080605135413.GI8942@skywalker>
	 <20080605162209.GG27370@duck.suse.cz> <20080605191909.GD4723@skywalker>
	 <20080611124157.GB8121@duck.suse.cz>  <20080611135631.GA15169@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56313 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703AbYFLXKt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 19:10:49 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5CNAmSZ012970
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 19:10:48 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5CNAmEE209166
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 19:10:48 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5CNAlS8014503
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 19:10:48 -0400
In-Reply-To: <20080611135631.GA15169@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-06-11 at 19:26 +0530, Aneesh Kumar K.V wrote:

> Attaching the updated patch.
> 
> Mingming,
> 
> Can you update the patchqueu with the  below attached patch ?
> 

Sure, just did.

Mingming
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

