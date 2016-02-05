From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: don't use ioends for direct write completions
Date: Sat, 6 Feb 2016 09:36:26 +1100
Message-ID: <20160205223626.GN459@dastard>
References: <1454524816-11392-1-git-send-email-hch@lst.de>
 <1454524816-11392-3-git-send-email-hch@lst.de>
 <20160205215718.GM20038@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160205215718.GM20038@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 05, 2016 at 01:57:18PM -0800, Darrick J. Wong wrote:
> On Wed, Feb 03, 2016 at 07:40:15PM +0100, Christoph Hellwig wrote:
> > -	struct kiocb		*iocb,
> > -	loff_t			offset,
> > -	ssize_t			size,
> > -	void			*private)
> > -{
> > -	struct inode		*inode = file_inode(iocb->ki_filp);
> > -	struct xfs_ioend	*ioend = private;
> > +		trace_xfs_end_io_direct_write_append(ip, offset, size);
> >  
> > -	if (size <= 0)
> > -		return 0;
> > -
> > -	trace_xfs_gbmap_direct_endio(XFS_I(inode), offset, size,
> > -				     ioend ? ioend->io_type : 0, NULL);
> > -
> > -	if (!ioend) {
> > -		ASSERT(offset + size <= i_size_read(inode));
> > -		return 0;
> > +		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
> > +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
> > +		if (error) {
> > +			xfs_trans_cancel(tp);
> > +			return error;
> > +		}
> > +		error = xfs_setfilesize(ip, tp, offset, size);
> 
> Don't we need a xfs_trans_commit() here?

No, xfs_setfilesize() does that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
