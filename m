From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] ext4: fix checking on nr_to_write
Date: Tue, 15 Oct 2013 19:15:56 +0800
Message-ID: <20131015191556.50c3eb03@tom-ThinkPad-T410>
References: <1381682393-5769-1-git-send-email-ming.lei@canonical.com>
	<20131014125858.GH19604@quack.suse.cz>
	<CACVXFVPpkJdw_AVwd=dRpD8ju6frjaU3QhKorr_PNNGu_D0jAQ@mail.gmail.com>
	<20131014173459.GL19604@quack.suse.cz>
	<20131015102553.22d4a018@tom-ThinkPad-T410>
	<20131015103900.GB12428@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ming Lei <tom.leiming@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131015103900.GB12428@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 15 Oct 2013 12:39:00 +0200
Jan Kara <jack@suse.cz> wrote:

> On Tue 15-10-13 10:25:53, Ming Lei wrote:
> > Looks it makes sense, so how about below change?
> > 
> > --
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 32c04ab..c32b599 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -2294,7 +2294,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
> >  {
> >  	struct address_space *mapping = mpd->inode->i_mapping;
> >  	struct pagevec pvec;
> > -	unsigned int nr_pages;
> > +	unsigned int nr_pages, nr_added = 0;
> >  	pgoff_t index = mpd->first_page;
> >  	pgoff_t end = mpd->last_page;
> >  	int tag;
> > @@ -2330,6 +2330,18 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
> >  			if (page->index > end)
> >  				goto out;
> >  
> > +			/*
> > +			 * Accumulated enough dirty pages? This doesn't apply
> > +			 * to WB_SYNC_ALL mode. For integrity sync we have to
> > +			 * keep going because someone may be concurrently
> > +			 * dirtying pages, and we might have synced a lot of
> > +			 * newly appeared dirty pages, but have not synced all
> > +			 * of the old dirty pages.
> > +			 */
> > +			if (mpd->wbc->sync_mode == WB_SYNC_NONE &&
> > +					nr_added >= mpd->wbc->nr_to_write)
> > +				goto out;
> > +
>   This won't quite work because if the page is fully mapped
> mpage_process_page_bufs() will immediately submit the page and decrease
> nr_to_write. So now you would end up writing less than you were asked for
> in some cases. 

Yes, your are right, so how about below?

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 32c04ab..3cf7abb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2295,6 +2295,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 	struct address_space *mapping = mpd->inode->i_mapping;
 	struct pagevec pvec;
 	unsigned int nr_pages;
+	int left = mpd->wbc->nr_to_write;
 	pgoff_t index = mpd->first_page;
 	pgoff_t end = mpd->last_page;
 	int tag;
@@ -2330,6 +2331,17 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			if (page->index > end)
 				goto out;
 
+			/*
+			 * Accumulated enough dirty pages? This doesn't apply
+			 * to WB_SYNC_ALL mode. For integrity sync we have to
+			 * keep going because someone may be concurrently
+			 * dirtying pages, and we might have synced a lot of
+			 * newly appeared dirty pages, but have not synced all
+			 * of the old dirty pages.
+			 */
+			if (mpd->wbc->sync_mode == WB_SYNC_NONE && left <= 0)
+				goto out;
+
 			/* If we can't merge this page, we are done. */
 			if (mpd->map.m_len > 0 && mpd->next_page != page->index)
 				goto out;
@@ -2364,19 +2376,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
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
+			left--;
 		}
 		pagevec_release(&pvec);
 		cond_resched();


> Attached patch should do what's needed. Can you try whether
> it fixes the problem for you (it seems to work OK in my testing).

In fact, I had wrote and tested your attached patch before my last post,
and it may trigger BUG() in mpage_release_unused_pages(), that is because
we touch mpd->next_page without locking current page, so it is better to
not increase mpd->next_page if the current page won't be processed.


Thanks,
-- 
Ming Lei
