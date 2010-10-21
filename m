From: Ted Ts'o <tytso@mit.edu>
Subject: Re: What am I doing wrong?  submit_bio() suddenly stops working...
Date: Thu, 21 Oct 2010 14:14:32 -0400
Message-ID: <20101021181432.GE3127@thunk.org>
References: <E1P8kSE-0001DW-8C@tytso-glaptop>
 <4CBFE4E2.7050001@kernel.dk>
 <20101021165525.GB3127@thunk.org>
 <4CC07B62.9070000@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49531 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab0JUSOl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Oct 2010 14:14:41 -0400
Content-Disposition: inline
In-Reply-To: <4CC07B62.9070000@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 21, 2010 at 07:41:54PM +0200, Boaz Harrosh wrote:
> > +#ifdef PDEBUG
> > +	trace_printk("%s: io submitted io_end %p\n", 
> > +		     io->io_end->inode->i_sb->s_id, io->io_end);
> > +#endif
> > +	submit_bio(io->io_op, io->io_bio);
> > +	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
> > +	bio_put(io->io_bio);
> 
> The extra get/put is only done for the duration of the ASSERT above, right?
> I'd put a comment. And why don't you just call the _get here just before
> submit_bio instead of down at io_submit_init.

The bio layer isn't well documented, so a lot of this was written by
cargo cult programming.  In this case, I was following what XFS did
when I originally wrote it.  It's only in the past week when I've been
diving deep into the source and was able to conclude that yes, it's
only needed for the ASSERT.

One of the frustrating things about the bio layer is that all of the
different file systems use very different patterns about how they
access the bio layer --- which is perhaps caused by the lack of
documentation.  But I finally did notice that the JFS code dodn't do a
bio_get() after calling bio_alloc(), and it was only when I did a lot
of source code tracing that I realized that it strictly speaking the
ASSERT isn't really even all that necessary, since we're not calling
using a discard or barrier op, which is the only thing that could
possibly set the EOPNOTSUPP flag anyway....

> > +	do {
> > +		bio = bio_alloc(GFP_NOIO, nvecs);
> > +		nvecs >>= 1;
> > +	} while (bio == NULL);
> 
> This is surly bad. bio_alloc must be allowed to fail
> (Specially with GFP_NOIO). You should only loop down to
> 1 and then prepare to return -ENOMEM from this function
> and handle it properly in callers. (Or schedule and wait
> like below)

Copied exactly from the XFS code.  I was under the (possibly mistaken)
assumption that the XFS code was a good place to copy from, since
everyone sings the praises of XFS.....

I do agree that bio_alloc() should be allowed to fail, although life
gets really tough deep in the writeback stack to throw a failure all
the way back out.  This was on my todo list to fix, after I got things
basically working.

							- Ted
