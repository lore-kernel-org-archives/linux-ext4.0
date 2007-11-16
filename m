From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] Add buffer head related helper functions
Date: Fri, 16 Nov 2007 13:33:53 -0800
Message-ID: <20071116133353.f5babdd3.akpm@linux-foundation.org>
References: <1195128646-15143-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1195128646-15143-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com,
	torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
	adilger@clusterfs.com, aneesh.kumar@linux.vnet.ibm.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760345AbXKPVer (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Nov 2007 16:34:47 -0500
In-Reply-To: <1195128646-15143-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 15 Nov 2007 17:40:43 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> Add buffer head related helper function
> bh_uptodate_or_lock and bh_submit_read
> which can be used by file system
> 

The patches look sane.

> ---
>  include/linux/buffer_head.h |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index da0d83f..82cc9ef 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -327,6 +327,35 @@ static inline void lock_buffer(struct buffer_head *bh)
>  
>  extern int __set_page_dirty_buffers(struct page *page);
>  
> +/* Return true if the buffer is up-to-date.
> + * Return false, with the buffer locked, if not.
> + */
> +static inline int bh_uptodate_or_lock(struct buffer_head *bh)
> +{
> +	if (!buffer_uptodate(bh)) {
> +		lock_buffer(bh);
> +		if (!buffer_uptodate(bh))
> +			return 0;
> +		unlock_buffer(bh);
> +	}
> +	return 1;
> +}
> +/*
> + * Submit a locked buffer for reading,
> + * return a negative error and release
> + * the buffer if failed.
> + */
> +static inline int bh_submit_read(struct buffer_head *bh)
> +{
> +	get_bh(bh);
> +	bh->b_end_io = end_buffer_read_sync;
> +	submit_bh(READ, bh);
> +	wait_on_buffer(bh);
> +	if (buffer_uptodate(bh))
> +		return 0;
> +	brelse(bh);
> +	return -EIO;
> +}
>  #else /* CONFIG_BLOCK */

But these are waaaaaay too big to be inlined.  Could I ask that they be
turned into regular EXPORT_SYMBOL()ed functions in buffer.c?

Might as well turn the comments into regular kerneldoc format, too.

The function names are a bit awkward, but I can't think of anything better.

I'm surprised that we don't already have a function which does what
bh_submit_read() does.

bh_submit_read() might become a bit simpler if it called ll_rw_block().

I'd have thought that to be more general, bh_submit_read() should return
immediately if the buffer is uptodate.  ll_rw_block() sort of helps there.
