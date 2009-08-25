From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2 V2] Direct IO for holes and fallocate: add end_io
	callback
Date: Tue, 25 Aug 2009 15:19:41 +0200
Message-ID: <20090825131941.GF405@duck.novell.com>
References: <1250092470.18329.27.camel@mingming-laptop> <20090819141557.GA4705@atrey.karlin.mff.cuni.cz> <20090824191137.GA19624@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Mingming <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45265 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbZHYNTn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 09:19:43 -0400
Content-Disposition: inline
In-Reply-To: <20090824191137.GA19624@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 24-08-09 15:11:38, Theodore Tso wrote:
> On Wed, Aug 19, 2009 at 04:15:57PM +0200, Jan Kara wrote:
> > > +static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> > > +			    ssize_t size, void *private)
> > > +{
> > > +        ext4_io_end_t *io_end = iocb->private;
> > > +	struct workqueue_struct *wq;
> > > +
> > > +	/* if not hole or unwritten extents, just simple return */
> > > +	if (!io_end || !size)
> > > +		return;
> > > +	io_end->offset = offset;
> > > +	io_end->size = size;
> > > +	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
> > > +
> > > +	/* We need to convert unwritten extents to written */
> > > +	queue_work(wq, &io_end->work);
> > > +
> > > +        if (is_sync_kiocb(iocb))
> > > +		flush_workqueue(wq);
> >   I don't think you can flush_workqueue here. end_io is called from
> > interrupt context and flush_workqueue blocks for a long time...
> > The wait should be done in ext4_direct_IO IMHO...
> 
> I don't see a problem here?  This is a direct_io end_io callback, not
> a bio callback; so it's only called from an interrupt context in the
> async I/O case, and we only call flush_workqueue() when the kiocb is
> synchronous.
  Ah, right, I didn't realize that DIO end_io callback gets called from
an interrupt context only for async IO. That also explains why XFS is fine
doing the same thing. Thanks for the explanation.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
