From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix checking on nr_to_write
Date: Mon, 14 Oct 2013 14:58:58 +0200
Message-ID: <20131014125858.GH19604@quack.suse.cz>
References: <1381682393-5769-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Ming Lei <ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381682393-5769-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

On Mon 14-10-13 00:39:52, Ming Lei wrote:
> Commit 4e7ea81db5(ext4: restructure writeback path) introduces
> another performance regression on random write:
> 
> - one more page may be mapped to ext4 extent in mpage_prepare_extent_to_map,
> and will be submitted for I/O so nr_to_write will become -1 before 'done'
> is set
> 
> - the worse thing is that dirty pages may still be retrieved from page
>   cache after nr_to_write becomes negative, so lots of small chunks can be
>   submitted to block device when page writeback is catching up with write path,
>   and performance is hurted.
  Umm, I guess I see what are you pointing at. Thanks for catching that.
mpage_process_page_bufs() always adds a buffer to mpd even if nr_to_write
is already <= 0. But I would somewhat prefer not to call
mpage_prepare_extent_to_map() at all when nr_to_write <= 0. So a patch
like:
                ret = mpage_prepare_extent_to_map(&mpd);
                if (!ret) {
-			if (mpd.map.m_len)
+			if (mpd.map.m_len) {
                                ret = mpage_map_and_submit_extent(handle, &mpd,
                                        &give_up_on_write);
-                       else {
+				done = (wbc->nr_to_write <= 0);
+                       } else {

Should also fix your problem, am I right?

								Honza

> On one arm A15 board(arndale) with sata 3.0 SSD(CPU: 1.5GHz dura core, RAM: 2GB),
> this patch can improve below test result from 157MB/sec to 174MB/sec(>10%):
> 
> 	dd if=/dev/zero of=./z.img bs=8K count=512K
> 
> The above test is actually prototype of block write in bonnie++ utility.
> 
> This patch fixes check on nr_to_write in mpage_prepare_extent_to_map()
> to make sure nr_to_write won't become negative.
> 
> Cc: Ted Tso <tytso@mit.edu>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-ext4@vger.kernel.org
> Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  fs/ext4/inode.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 32c04ab..6a62803 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2356,15 +2356,6 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			if (mpd->map.m_len == 0)
>  				mpd->first_page = page->index;
>  			mpd->next_page = page->index + 1;
> -			/* Add all dirty buffers to mpd */
> -			lblk = ((ext4_lblk_t)page->index) <<
> -				(PAGE_CACHE_SHIFT - blkbits);
> -			head = page_buffers(page);
> -			err = mpage_process_page_bufs(mpd, head, head, lblk);
> -			if (err <= 0)
> -				goto out;
> -			err = 0;
> -
>  			/*
>  			 * Accumulated enough dirty pages? This doesn't apply
>  			 * to WB_SYNC_ALL mode. For integrity sync we have to
> @@ -2374,9 +2365,18 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			 * of the old dirty pages.
>  			 */
>  			if (mpd->wbc->sync_mode == WB_SYNC_NONE &&
> -			    mpd->next_page - mpd->first_page >=
> +			    mpd->next_page - mpd->first_page >
>  							mpd->wbc->nr_to_write)
>  				goto out;
> +
> +			/* Add all dirty buffers to mpd */
> +			lblk = ((ext4_lblk_t)page->index) <<
> +				(PAGE_CACHE_SHIFT - blkbits);
> +			head = page_buffers(page);
> +			err = mpage_process_page_bufs(mpd, head, head, lblk);
> +			if (err <= 0)
> +				goto out;
> +			err = 0;
>  		}
>  		pagevec_release(&pvec);
>  		cond_resched();
> -- 
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
