From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH] fix softlockups in ext2/3 when trying to allocate blocks
Date: Wed, 8 Jul 2009 16:26:13 -0400
Message-ID: <20090708202612.GC16893@shell>
References: <20090706194739.GB19798@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, emcnabb@redhat.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbZGHU0O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jul 2009 16:26:14 -0400
Content-Disposition: inline
In-Reply-To: <20090706194739.GB19798@dhcp231-156.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 06, 2009 at 03:47:39PM -0400, Josef Bacik wrote:
> This isn't a huge deal, but using a big beefy box with more CPUs than what is
> sane, you can get a nice flood of softlockup messages when running heavy
> multi-threaded io tests on ext2/3.  The processors compete for blocks from the
> allocator, so they will loop quite a bit trying to get their allocation.  This
> patch simply makes sure that we reschedule if need be.  This made the softlockup
> messages disappear whereas before they happened almost immediately.  Thanks,
> 
> Tested-by: Evan McNabb <emcnabb@redhat.com>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/ext2/balloc.c |    1 +
>  fs/ext3/balloc.c |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 7f8d2e5..17dd55f 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -1176,6 +1176,7 @@ ext2_try_to_allocate_with_rsv(struct super_block *sb, unsigned int group,
>  			break;				/* succeed */
>  		}
>  		num = *count;
> +		cond_resched();
>  	}
>  	return ret;
>  }
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 27967f9..cffc8cd 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -735,6 +735,7 @@ bitmap_search_next_usable_block(ext3_grpblk_t start, struct buffer_head *bh,
>  	struct journal_head *jh = bh2jh(bh);
>  
>  	while (start < maxblocks) {
> +		cond_resched();
>  		next = ext3_find_next_zero_bit(bh->b_data, maxblocks, start);
>  		if (next >= maxblocks)
>  			return -1;

I'm curious: Why schedule at the beginning of the while() loop rather
than at the end?

> @@ -1391,6 +1392,7 @@ ext3_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
>  			break;				/* succeed */
>  		}
>  		num = *count;
> +		cond_resched();
>  	}
>  out:
>  	if (ret >= 0) {
> -- 
> 1.6.2.2

I like this patch in general, but I worry about introducing new
performance problems in other cases.  Have you guys tested on single
cpu systems?  Maybe with a file system close to ENOSPC or badly
fragmented?

-VAL
