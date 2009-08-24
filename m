From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2 V2] Direct IO for holes and fallocate: add end_io
	callback
Date: Mon, 24 Aug 2009 15:11:38 -0400
Message-ID: <20090824191137.GA19624@mit.edu>
References: <1250092470.18329.27.camel@mingming-laptop> <20090819141557.GA4705@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58044 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbZHXTLn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 15:11:43 -0400
Content-Disposition: inline
In-Reply-To: <20090819141557.GA4705@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 19, 2009 at 04:15:57PM +0200, Jan Kara wrote:
> > +static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> > +			    ssize_t size, void *private)
> > +{
> > +        ext4_io_end_t *io_end = iocb->private;
> > +	struct workqueue_struct *wq;
> > +
> > +	/* if not hole or unwritten extents, just simple return */
> > +	if (!io_end || !size)
> > +		return;
> > +	io_end->offset = offset;
> > +	io_end->size = size;
> > +	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
> > +
> > +	/* We need to convert unwritten extents to written */
> > +	queue_work(wq, &io_end->work);
> > +
> > +        if (is_sync_kiocb(iocb))
> > +		flush_workqueue(wq);
>   I don't think you can flush_workqueue here. end_io is called from
> interrupt context and flush_workqueue blocks for a long time...
> The wait should be done in ext4_direct_IO IMHO...

I don't see a problem here?  This is a direct_io end_io callback, not
a bio callback; so it's only called from an interrupt context in the
async I/O case, and we only call flush_workqueue() when the kiocb is
synchronous.

							- Ted
