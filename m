From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] update i_disksize coherently with block allocation
Date: Mon, 25 Aug 2014 21:13:10 -0400
Message-ID: <20140826011310.GB11317@thunk.org>
References: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
 <1408707147-22482-6-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48855 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933438AbaHZBNU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2014 21:13:20 -0400
Content-Disposition: inline
In-Reply-To: <1408707147-22482-6-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 22, 2014 at 03:32:27PM +0400, Dmitry Monakhov wrote:
> Writeback call trace looks like follows:
> ext4_writepages
>  while(nr_pages)
>  ->journal_start
>  ->mpage_map_and_submit_extent -> may alloc some blocks
>    ->mpage_map_one_extent
>  ->journal_stop
> In case of delalloc block i_disksize may be less than i_size. So we have to
> update i_disksize each time we allocated and submitted some blocks beyond
> i_disksize. And we MUST update it in the same transaction, otherwise this
> result in fs-inconsistency in case of upcoming power-failure.

This description doesn't seem to be consistent with the change in the
patch; the patch included makes sure that on an error, we update the
on-disk block size if some blocks had been previously allocated.
Which looks OK, but the commit description seems to imply tha the
patch does more than this.  Did part of the patch get dropped, or
should we rewrite the commit description to be more clear what it is
changing?

Thanks,

					- Ted


> 
> Another possible way to fix that issue is to insert inode to orhphan list
> on ext4_writepages entrance.
> 
> testcase: xfstest generic/019
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3919e25..b1d92fb 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2077,6 +2077,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  	struct ext4_map_blocks *map = &mpd->map;
>  	int err;
>  	loff_t disksize;
> +	int progress = 0;
>  
>  	mpd->io_submit.io_end->offset =
>  				((loff_t)map->m_lblk) << inode->i_blkbits;
> @@ -2093,8 +2094,11 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  			 * is non-zero, a commit should free up blocks.
>  			 */
>  			if ((err == -ENOMEM) ||
> -			    (err == -ENOSPC && ext4_count_free_clusters(sb)))
> +			    (err == -ENOSPC && ext4_count_free_clusters(sb))) {
> +				if (progress)
> +					goto update_disksize;
>  				return err;
> +			}
>  			ext4_msg(sb, KERN_CRIT,
>  				 "Delayed block allocation failed for "
>  				 "inode %lu at logical offset %llu with"
> @@ -2111,15 +2115,17 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  			*give_up_on_write = true;
>  			return err;
>  		}
> +		progress = 1;
>  		/*
>  		 * Update buffer state, submit mapped pages, and get us new
>  		 * extent to map
>  		 */
>  		err = mpage_map_and_submit_buffers(mpd);
>  		if (err < 0)
> -			return err;
> +			goto update_disksize;
>  	} while (map->m_len);
>  
> +update_disksize:
>  	/*
>  	 * Update on-disk size after IO is submitted.  Races with
>  	 * truncate are avoided by checking i_size under i_data_sem.
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
