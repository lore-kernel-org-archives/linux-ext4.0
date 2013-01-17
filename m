From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/6] block: Optionally snapshot page contents to
 provide stable pages during write
Date: Thu, 17 Jan 2013 11:32:08 +0100
Message-ID: <20130117103208.GA12562@quack.suse.cz>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
 <20130115054305.1563.48197.stgit@blackbox.djwong.org>
 <20130116020000.GA25806@quack.suse.cz>
 <20130117030132.GK6426@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk, lucho@ionkov.net,
	ericvh@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk,
	rminnich@sandia.gov, martin.petersen@oracle.com, neilb@suse.de,
	david@fromorbit.com, gnehzuil.liu@gmail.com,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org,
	Andy Lutomirski <luto@amacapital.net>,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130117030132.GK6426@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 16-01-13 19:01:32, Darrick J. Wong wrote:
> > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > index c973249..277134c 100644
> > > --- a/block/blk-core.c
> > > +++ b/block/blk-core.c
> > > @@ -1474,6 +1474,11 @@ void blk_queue_bio(struct request_queue *q, struct bio *bio)
> > >  	 */
> > >  	blk_queue_bounce(q, &bio);
> > >  
> > > +	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
> > > +		bio_endio(bio, -EIO);
> > > +		return;
> > > +	}
> > > +
> > >  	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
> > >  		spin_lock_irq(q->queue_lock);
> > >  		where = ELEVATOR_INSERT_FLUSH;
> > > @@ -1714,9 +1719,6 @@ generic_make_request_checks(struct bio *bio)
> > >  	 */
> > >  	blk_partition_remap(bio);
> > >  
> > > -	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
> > > -		goto end_io;
> > > -
> >   Umm, why did you move this hunk?
> 
> I moved it so that the integrity data are generated against the contents of the
> bounce buffer because the write paths don't wait for writeback to finish if the
> snapshotting mode is enabled, which means (I think) that programs can wander in
> and scribble on the original page in between bio_integrity_prep and
> blk_queue_bounce.
  Ah, I see. OK.

> > >  	if (bio_check_eod(bio, nr_sectors))
> > >  		goto end_io;
> > 
> > > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > > index 780d4c6..0144fbb 100644
> > > --- a/include/uapi/linux/fs.h
> > > +++ b/include/uapi/linux/fs.h
> > > @@ -69,6 +69,7 @@ struct inodes_stat_t {
> > >  #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
> > >  #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
> > >  #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
> > > +#define MS_SNAP_STABLE	256	/* Snapshot pages during writeback, if needed */
> > >  #define MS_NOATIME	1024	/* Do not update access times. */
> > >  #define MS_NODIRATIME	2048	/* Do not update directory access times */
> > >  #define MS_BIND		4096
> >   Please don't mix MS_SNAP_STABLE flag among flags passed by mount(2)
> > syscall. I think putting it at 1 << 27 might be acceptable. I remember
> > Al Viro saying something along the lines that kernel internal superblock
> > flags should be separated from those passed from userspace into a special
> > superblock entry but that's a different story I guess.
> 
> Ok, I'll change it to 1<<27.  I'll add a comment stating that we're trying to
> keep internal sb flags separate.  It looks like those last four flags are all
> internal?
  Yes. Flags with low numbers are part of kernel ABI...

> > > diff --git a/mm/bounce.c b/mm/bounce.c
> > > index 0420867..a5b30f9 100644
> > > --- a/mm/bounce.c
> > > +++ b/mm/bounce.c
> > > @@ -178,8 +178,44 @@ static void bounce_end_io_read_isa(struct bio *bio, int err)
> > >  	__bounce_end_io_read(bio, isa_page_pool, err);
> > >  }
> > >  
> > > +#ifdef CONFIG_NEED_BOUNCE_POOL
> > > +static int must_snapshot_stable_pages(struct bio *bio)
> > > +{
> > > +	struct page *page;
> > > +	struct backing_dev_info *bdi;
> > > +	struct address_space *mapping;
> > > +	struct bio_vec *from;
> > > +	int i;
> > > +
> > > +	if (bio_data_dir(bio) != WRITE)
> > > +		return 0;
> > > +
> > > +	/*
> > > +	 * Based on the first page that has a valid mapping, decide whether or
> > > +	 * not we have to employ bounce buffering to guarantee stable pages.
> > > +	 */
> > > +	bio_for_each_segment(from, bio, i) {
> > > +		page = from->bv_page;
> > > +		mapping = page_mapping(page);
> > > +		if (!mapping)
> > > +			continue;
> > > +		bdi = mapping->backing_dev_info;
> > > +		if (!bdi_cap_stable_pages_required(bdi))
> > > +			return 0;
> > > +		return mapping->host->i_sb->s_flags & MS_SNAP_STABLE;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> >   How about using q->backing_dev_info for the
> > bdi_cap_stable_pages_required() check? It will be a fast path and this check
> > will be faster..
> Ok.
  And maybe I should have told explicitely that then you can move the check
before bio_for_each_segment() loop...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
