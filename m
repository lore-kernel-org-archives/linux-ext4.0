From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Wed, 20 Apr 2016 13:59:23 -0700
Message-ID: <20160420205923.GA24797@infradead.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
 <1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
 <x49twj26edj.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-nvdimm@ml01.01.org, Dave Chinner <david@fromorbit.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	Jens Axboe <axboe@fb.com>, linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <x49twj26edj.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 15, 2016 at 12:11:36PM -0400, Jeff Moyer wrote:
> > +	if (IS_DAX(inode)) {
> > +		ret = dax_do_io(iocb, inode, iter, offset, blkdev_get_block,
> >  				NULL, DIO_SKIP_DIO_COUNT);
> > +		if (ret == -EIO && (iov_iter_rw(iter) == WRITE))
> > +			ret_saved = ret;
> > +		else
> > +			return ret;
> > +	}
> > +
> > +	ret = __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter, offset,
> >  				    blkdev_get_block, NULL, NULL,
> >  				    DIO_SKIP_DIO_COUNT);
> > +	if (ret < 0 && ret_saved)
> > +		return ret_saved;
> > +
> 
> Hmm, did you just break async DIO?  I think you did!  :)
> __blockdev_direct_IO can return -EIOCBQUEUED, and you've now turned that
> into -EIO.  Really, I don't see a reason to save that first -EIO.  The
> same applies to all instances in this patch.

Yes, there is no point in saving the earlier error - just return the
second error all the time.

E.g.

	ret = dax_io();
	if (dax_need_dio_retry(ret))
		ret = direct_IO();

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
