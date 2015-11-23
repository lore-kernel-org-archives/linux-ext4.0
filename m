From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] generic/15[78]: fix error messages in the golden
 output
Date: Mon, 23 Nov 2015 13:25:33 -0800
Message-ID: <20151123212533.GC10589@birch.djwong.org>
References: <20151121005001.20398.92856.stgit@birch.djwong.org>
 <20151121005014.20398.22316.stgit@birch.djwong.org>
 <20151121180644.GA23916@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, fstests@vger.kernel.org, xfs@oss.sgi.com,
	tao.peng@primarydata.com, linux-ext4@vger.kernel.org,
	Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151121180644.GA23916@infradead.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Nov 21, 2015 at 10:06:44AM -0800, Christoph Hellwig wrote:
> > --- a/tests/generic/158.out
> > +++ b/tests/generic/158.out
> >  Try to dedupe a device
> > -XFS_IOC_FILE_EXTENT_SAME: Permission denied
> > +XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> >  Try to dedupe to a dir
> > -/mnt/test-158/dir1: Is a directory
> > +TEST_DIR/test-158/dir1: Is a directory
> >  Try to dedupe to a device
> > -dedupe: Permission denied
> > +dedupe: Operation not supported
> >  Try to dedupe to a fifo
> > -dedupe: Permission denied
> > +dedupe: Operation not supported
> 
> Shouldn't these be Invalid argument just like the
> to a device case above or the clone case?

I was trying to mirror the behavior of reflink, which spits out EOPNOTSUPP when
the destination isn't a regular file and EINVAL when the source isn't a regular
file.

--D

> 
> Otherwise looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
