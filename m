From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC v4+ hot_track 05/19] vfs: add hooks to enable hot tracking
Date: Tue, 6 Nov 2012 23:51:36 +0100
Message-ID: <20121106225136.GU3102@twin.jikos.cz>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
 <1351485061-12297-6-git-send-email-zwu.kernel@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: zwu.kernel@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:49825 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2KFWvx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2012 17:51:53 -0500
Content-Disposition: inline
In-Reply-To: <1351485061-12297-6-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 29, 2012 at 12:30:47PM +0800, zwu.kernel@gmail.com wrote:
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -19,6 +19,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/syscalls.h>
>  #include <linux/file.h>
> +#include <linux/hot_tracking.h>
>  
>  /*
>   * Initialise a struct file's readahead state.  Assumes that the caller has
> @@ -138,6 +139,11 @@ static int read_pages(struct address_space *mapping, struct file *filp,
>  out:
>  	blk_finish_plug(&plug);
>  
> +	/* Hot data tracking */
> +	hot_update_freqs(mapping->host, (u64)(list_entry(pages->prev,\
> +				struct page, lru)->index) << PAGE_CACHE_SHIFT,
> +			(u64)nr_pages * PAGE_CACHE_SIZE, 0);

There's a stale \ at the end of the line, and I find this formatting
hard to read. Does the following look acceptable?

	hot_update_freqs(mapping->host,
		(u64)(list_entry(pages->prev, struct page, lru)->index)
			<< PAGE_CACHE_SHIFT,
		(u64)nr_pages * PAGE_CACHE_SIZE, 0);

> +
>  	return ret;
>  }
>  
