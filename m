From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: Use WRITE_SYNC in journal checkpoint.
Date: Wed, 8 Jun 2011 17:50:48 +0200
Message-ID: <20110608155048.GD5361@quack.suse.cz>
References: <1307419010-3390-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, tytso@mit.edu
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40388 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab1FHPuv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2011 11:50:51 -0400
Content-Disposition: inline
In-Reply-To: <1307419010-3390-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 07-06-11 11:56:50, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In journal checkpoint, we write the buffer and wait for its finish.
> But in cfq, the async queue has a very low priority, and in our test,
> if there are too many sync queues and every queue is filled up with
> requests, and the process will hang waiting for the log space.
> 
> So this patch tries to use WRITE_SYNC in __flush_batch so that the request will
> be moved into sync queue and handled by cfq timely. We also use the new plug,
> sot that all the WRITE_SYNC requests can be given as a whole when we unplug it.
  OK, makes sense to me. I'd like to merge the patch but I'd also like to
keep compatibility with ext4 here so I'll wait for a while what Ted thinks
about this change... Ted?

								Honza
> 
> Cc: Jan Kara <jack@suse.cz>
> Reported-by: Robin Dong <sanbai@taobao.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/jbd/checkpoint.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
> index e4b87bc..a7ce053 100644
> --- a/fs/jbd/checkpoint.c
> +++ b/fs/jbd/checkpoint.c
> @@ -22,6 +22,7 @@
>  #include <linux/jbd.h>
>  #include <linux/errno.h>
>  #include <linux/slab.h>
> +#include <linux/blkdev.h>
>  
>  /*
>   * Unlink a buffer from a transaction checkpoint list.
> @@ -253,9 +254,12 @@ static void
>  __flush_batch(journal_t *journal, struct buffer_head **bhs, int *batch_count)
>  {
>  	int i;
> +	struct blk_plug plug;
>  
> +	blk_start_plug(&plug);
>  	for (i = 0; i < *batch_count; i++)
> -		write_dirty_buffer(bhs[i], WRITE);
> +		write_dirty_buffer(bhs[i], WRITE_SYNC);
> +	blk_finish_plug(&plug);
>  
>  	for (i = 0; i < *batch_count; i++) {
>  		struct buffer_head *bh = bhs[i];
> -- 
> 1.7.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
