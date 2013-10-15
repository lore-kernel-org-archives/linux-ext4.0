From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix checking on nr_to_write
Date: Tue, 15 Oct 2013 12:39:00 +0200
Message-ID: <20131015103900.GB12428@quack.suse.cz>
References: <1381682393-5769-1-git-send-email-ming.lei@canonical.com>
 <20131014125858.GH19604@quack.suse.cz>
 <CACVXFVPpkJdw_AVwd=dRpD8ju6frjaU3QhKorr_PNNGu_D0jAQ@mail.gmail.com>
 <20131014173459.GL19604@quack.suse.cz>
 <20131015102553.22d4a018@tom-ThinkPad-T410>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="aM3YZ0Iwxop3KEKx"
Cc: Jan Kara <jack@suse.cz>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ming Lei <tom.leiming@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131015102553.22d4a018@tom-ThinkPad-T410>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 15-10-13 10:25:53, Ming Lei wrote:
> Looks it makes sense, so how about below change?
> 
> --
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 32c04ab..c32b599 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2294,7 +2294,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  {
>  	struct address_space *mapping = mpd->inode->i_mapping;
>  	struct pagevec pvec;
> -	unsigned int nr_pages;
> +	unsigned int nr_pages, nr_added = 0;
>  	pgoff_t index = mpd->first_page;
>  	pgoff_t end = mpd->last_page;
>  	int tag;
> @@ -2330,6 +2330,18 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			if (page->index > end)
>  				goto out;
>  
> +			/*
> +			 * Accumulated enough dirty pages? This doesn't apply
> +			 * to WB_SYNC_ALL mode. For integrity sync we have to
> +			 * keep going because someone may be concurrently
> +			 * dirtying pages, and we might have synced a lot of
> +			 * newly appeared dirty pages, but have not synced all
> +			 * of the old dirty pages.
> +			 */
> +			if (mpd->wbc->sync_mode == WB_SYNC_NONE &&
> +					nr_added >= mpd->wbc->nr_to_write)
> +				goto out;
> +
  This won't quite work because if the page is fully mapped
mpage_process_page_bufs() will immediately submit the page and decrease
nr_to_write. So now you would end up writing less than you were asked for
in some cases. Attached patch should do what's needed. Can you try whether
it fixes the problem for you (it seems to work OK in my testing).

								Honza

>  			/* If we can't merge this page, we are done. */
>  			if (mpd->map.m_len > 0 && mpd->next_page != page->index)
>  				goto out;
> @@ -2364,19 +2376,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			if (err <= 0)
>  				goto out;
>  			err = 0;
> -
> -			/*
> -			 * Accumulated enough dirty pages? This doesn't apply
> -			 * to WB_SYNC_ALL mode. For integrity sync we have to
> -			 * keep going because someone may be concurrently
> -			 * dirtying pages, and we might have synced a lot of
> -			 * newly appeared dirty pages, but have not synced all
> -			 * of the old dirty pages.
> -			 */
> -			if (mpd->wbc->sync_mode == WB_SYNC_NONE &&
> -			    mpd->next_page - mpd->first_page >=
> -							mpd->wbc->nr_to_write)
> -				goto out;
> +			nr_added++;
>  		}
>  		pagevec_release(&pvec);
>  		cond_resched();
> 
> 
> 
> Thanks,
> -- 
> Ming Lei
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--aM3YZ0Iwxop3KEKx
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-performance-regression-in-ext4_writepages.patch"

>From 2ea950d5d601fd1236065f3fe87a9383d78d3785 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@canonical.com>
Date: Tue, 15 Oct 2013 12:30:50 +0200
Subject: [PATCH] ext4: Fix performance regression in ext4_writepages()

Commit 4e7ea81db5(ext4: restructure writeback path) introduces another
performance regression on random write: The logic in
mpage_prepare_extent_to_map() always prepares at least one page for
mapping and the loop in ext4_writepages() doesn't terminate when
nr_to_write drops to zero if there is something to map. So we will still
try to write more that we should and we will do it in 1 page chunks.

Fix the problem by moving nr_to_write check in
mpage_prepare_extent_to_map() before preparing the first page. That way
mpage_prepare_extent_to_map() will return without preparing anything when
nr_to_write is exhausted and the loop in ext4_writepages() will be
terminated properly.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e274e9c1171f..7d12a38fbde4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2334,6 +2334,22 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			if (mpd->map.m_len > 0 && mpd->next_page != page->index)
 				goto out;
 
+			if (mpd->map.m_len == 0)
+				mpd->first_page = page->index;
+			mpd->next_page = page->index + 1;
+			/*
+			 * Accumulated enough dirty pages? This doesn't apply
+			 * to WB_SYNC_ALL mode. For integrity sync we have to
+			 * keep going because someone may be concurrently
+			 * dirtying pages, and we might have synced a lot of
+			 * newly appeared dirty pages, but have not synced all
+			 * of the old dirty pages.
+			 */
+			if (mpd->wbc->sync_mode == WB_SYNC_NONE &&
+			    mpd->next_page - mpd->first_page >
+							mpd->wbc->nr_to_write)
+				goto out;
+
 			lock_page(page);
 			/*
 			 * If the page is no longer dirty, or its mapping no
@@ -2353,9 +2369,6 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			wait_on_page_writeback(page);
 			BUG_ON(PageWriteback(page));
 
-			if (mpd->map.m_len == 0)
-				mpd->first_page = page->index;
-			mpd->next_page = page->index + 1;
 			/* Add all dirty buffers to mpd */
 			lblk = ((ext4_lblk_t)page->index) <<
 				(PAGE_CACHE_SHIFT - blkbits);
@@ -2364,19 +2377,6 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			if (err <= 0)
 				goto out;
 			err = 0;
-
-			/*
-			 * Accumulated enough dirty pages? This doesn't apply
-			 * to WB_SYNC_ALL mode. For integrity sync we have to
-			 * keep going because someone may be concurrently
-			 * dirtying pages, and we might have synced a lot of
-			 * newly appeared dirty pages, but have not synced all
-			 * of the old dirty pages.
-			 */
-			if (mpd->wbc->sync_mode == WB_SYNC_NONE &&
-			    mpd->next_page - mpd->first_page >=
-							mpd->wbc->nr_to_write)
-				goto out;
 		}
 		pagevec_release(&pvec);
 		cond_resched();
-- 
1.8.1.4


--aM3YZ0Iwxop3KEKx--
