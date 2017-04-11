From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] ext4: Avoid unnecessary transaction stalls during
 writeback
Date: Tue, 11 Apr 2017 18:16:54 +0200
Message-ID: <20170411161654.GD2471@quack2.suse.cz>
References: <20170411135418.9638-1-jack@suse.cz>
 <20170411135418.9638-4-jack@suse.cz>
 <CAOQ4uxidGcjCp4WD0sBEcMSNhCP0RKYcRK7z93V07uaVZCC3Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        Ext4 <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33486 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750721AbdDKQRD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Apr 2017 12:17:03 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxidGcjCp4WD0sBEcMSNhCP0RKYcRK7z93V07uaVZCC3Gw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 11-04-17 18:00:50, Amir Goldstein wrote:
> On Tue, Apr 11, 2017 at 4:54 PM, Jan Kara <jack@suse.cz> wrote:
> > Currently ext4_writepages() submits all pages with transaction started.
> > When no page needs block allocation or extent conversion we can submit
> > all dirty pages in the inode while holding a single transaction handle
> > and when device is congested this can take significant amount of time.
> > Thus ext4_writepages() can block transaction commits for extended
> > periods of time.
> >
> > Take for example a simple benchmark simulating PostgreSQL database
> > (pgioperf in mmtest). The benchmark runs 16 processes doing random reads
> > from a huge file, one process doing random writes to the huge file, and
> > one process doing sequential writes to a small writes and frequently
> 
> typo s/small writes/small file/

Yeah, thanks.

> > running fsync. With unpatched kernel transaction commits take on average
> > ~18s with standard deviation of ~41s, top 5 commit times are:
> >
> > 274.466639s, 126.467347s, 86.992429s, 34.351563s, 31.517653s.
> >
> > After this patch transaction commits take on average 0.1s with standard
> > deviation of 0.15s, top 5 commit times are:
> >
> > 0.563792s, 0.519980s, 0.509841s, 0.471700s, 0.469899s
> 
> That's a very nice improvement! I wonder what the "commit time" metrics
> means to end users though.
> Perhaps you should additionally phrase the problem statement and the
> improvement in metrics that end users understand?
> i.e. the runtime of fsync on the small file? is that what it means?

Well, I don't think kernel commit logs are really for "end users" :). But
generally any change in ext4 can wait for an outstanding transaction commit
so even a plain atime update or write(2) can block until transaction is
committed.

> Out of curiousity, I wonder how XFS performs in this benchmark
> did you happen to check?
> I am guessing it would be closer to the 'after' results?

Out of curiosity I've run the benchmark on XFS and yes, XFS is closer to
'after' results. The benchmark actually reports three things - times to
read, times to write, and times to fsync. Reads are very similar for ext4
after the patch and xfs. XFS is much faster for writes even after the patch
(I assume because we pay the overhead of transaction machinery in ext4
although it is not necessary for the writes we do here). ext4 is about 2x
faster for fsync calls.

								Honza

> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/inode.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index baa87e7d1426..ff55d430938b 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -2171,6 +2171,9 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
> >
> >         /* First block in the extent? */
> >         if (map->m_len == 0) {
> > +               /* We cannot map unless handle is started... */
> > +               if (!mpd->io_submit.io_end)
> > +                       return false;
> >                 map->m_lblk = lblk;
> >                 map->m_len = 1;
> >                 map->m_flags = bh->b_state & BH_FLAGS;
> > @@ -2223,6 +2226,9 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
> >                         /* Found extent to map? */
> >                         if (mpd->map.m_len)
> >                                 return 0;
> > +                       /* Buffer needs mapping and handle is not started? */
> > +                       if (!mpd->io_submit.io_end)
> > +                               return 0;
> >                         /* Everything mapped so far and we hit EOF */
> >                         break;
> >                 }
> > @@ -2739,6 +2745,21 @@ static int ext4_writepages(struct address_space *mapping,
> >                 tag_pages_for_writeback(mapping, mpd.first_page, mpd.last_page);
> >         done = false;
> >         blk_start_plug(&plug);
> > +
> > +       /*
> > +        * First writeback pages that don't need mapping - we can avoid
> > +        * starting a transaction unnecessarily and also avoid being blocked
> > +        * in the block layer on device congestion while having transaction
> > +        * started.
> > +        */
> > +       ret = mpage_prepare_extent_to_map(&mpd);
> > +       /* Submit prepared bio */
> > +       ext4_io_submit(&mpd.io_submit);
> > +       /* Unlock pages we didn't use */
> > +       mpage_release_unused_pages(&mpd, false);
> > +       if (ret < 0)
> > +               goto unplug;
> > +
> >         while (!done && mpd.first_page <= mpd.last_page) {
> >                 /* For each extent of pages we use new io_end */
> >                 mpd.io_submit.io_end = ext4_init_io_end(inode, GFP_KERNEL);
> > @@ -2767,6 +2788,7 @@ static int ext4_writepages(struct address_space *mapping,
> >                                 wbc->nr_to_write, inode->i_ino, ret);
> >                         /* Release allocated io_end */
> >                         ext4_put_io_end(mpd.io_submit.io_end);
> > +                       mpd.io_submit.io_end = NULL;
> >                         break;
> >                 }
> >
> > @@ -2816,6 +2838,7 @@ static int ext4_writepages(struct address_space *mapping,
> >                         ext4_journal_stop(handle);
> >                 } else
> >                         ext4_put_io_end(mpd.io_submit.io_end);
> > +               mpd.io_submit.io_end = NULL;
> >
> >                 if (ret == -ENOSPC && sbi->s_journal) {
> >                         /*
> > @@ -2831,6 +2854,7 @@ static int ext4_writepages(struct address_space *mapping,
> >                 if (ret)
> >                         break;
> >         }
> > +unplug:
> >         blk_finish_plug(&plug);
> >         if (!ret && !cycled && wbc->nr_to_write > 0) {
> >                 cycled = 1;
> > --
> > 2.12.0
> >
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
