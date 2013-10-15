From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] ext4: fix checking on nr_to_write
Date: Tue, 15 Oct 2013 10:25:53 +0800
Message-ID: <20131015102553.22d4a018@tom-ThinkPad-T410>
References: <1381682393-5769-1-git-send-email-ming.lei@canonical.com>
	<20131014125858.GH19604@quack.suse.cz>
	<CACVXFVPpkJdw_AVwd=dRpD8ju6frjaU3QhKorr_PNNGu_D0jAQ@mail.gmail.com>
	<20131014173459.GL19604@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ming Lei <tom.leiming@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52005 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab3JOC0G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Oct 2013 22:26:06 -0400
In-Reply-To: <20131014173459.GL19604@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 14 Oct 2013 19:34:59 +0200
Jan Kara <jack@suse.cz> wrote:

> On Mon 14-10-13 21:50:54, Ming Lei wrote:
> > On Mon, Oct 14, 2013 at 8:58 PM, Jan Kara <jack@suse.cz> wrote:
> > >   Umm, I guess I see what are you pointing at. Thanks for catching that.
> > > mpage_process_page_bufs() always adds a buffer to mpd even if nr_to_write
> > > is already <= 0. But I would somewhat prefer not to call
> > > mpage_prepare_extent_to_map() at all when nr_to_write <= 0. So a patch
> > > like:
> > >                 ret = mpage_prepare_extent_to_map(&mpd);
> > >                 if (!ret) {
> > > -                       if (mpd.map.m_len)
> > > +                       if (mpd.map.m_len) {
> > >                                 ret = mpage_map_and_submit_extent(handle, &mpd,
> > >                                         &give_up_on_write);
> > > -                       else {
> > > +                               done = (wbc->nr_to_write <= 0);
> > > +                       } else {
> > >
> > > Should also fix your problem, am I right?
> > 
> > I am afraid it can't, because we need to stop scanning page cache
> > if end of file is reached.
>   That should be OK. mpage_process_page_bufs() won't add a buffer beyond
> EOF so we end the extent at EOF and next time we don't add anything to the
> extent. My change wouldn't change anything in this.

I mean wbc->nr_to_write may still be positive when mpage_prepare_extent_to_map()
returns zero, so your change will cause ext4_writepages not to break from the
loop, then write hangs, too crazy?

> 
> > nr_to_write will become negative inside mpage_map_and_submit_extent(),
> > that is why I fix it inside mpage_prepare_extent_to_map().
>   Yes, mpage_map_and_submit_extent() creates negative nr_to_write but only
> because mpage_prepare_extent_to_map() asked for mapping too big extent. But
> if I'm reading the code correctly we first ask for writing the extent of
> just the right size (nr_to_write becomes 0) but then ext4_writepages() asks
> mpage_prepare_extent_to_map() for another extent and it will create a single
> page extent for mapping before it finds out nr_to_write <= 0 and
> terminates. Am I understanding the problem correctly?

Your understanding is right, and I think it is a correct fix, because
we shouldn't add more pages to extent than nr_to_write.

> 
> After thinking about it again, moving the condition in
> mpage_prepare_extent_to_map() as you did is probably better that what I
> suggested. Just move it more up in the loop - like after page->index > end
> condition. So that we don't unnecessarily lock the page etc.

Looks it makes sense, so how about below change?

--
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 32c04ab..c32b599 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2294,7 +2294,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 {
 	struct address_space *mapping = mpd->inode->i_mapping;
 	struct pagevec pvec;
-	unsigned int nr_pages;
+	unsigned int nr_pages, nr_added = 0;
 	pgoff_t index = mpd->first_page;
 	pgoff_t end = mpd->last_page;
 	int tag;
@@ -2330,6 +2330,18 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
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
+			if (mpd->wbc->sync_mode == WB_SYNC_NONE &&
+					nr_added >= mpd->wbc->nr_to_write)
+				goto out;
+
 			/* If we can't merge this page, we are done. */
 			if (mpd->map.m_len > 0 && mpd->next_page != page->index)
 				goto out;
@@ -2364,19 +2376,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			if (err <= 0)
 				goto out;
 			err = 0;
