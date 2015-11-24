From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] generic/15[78]: fix error messages in the golden
 output
Date: Mon, 23 Nov 2015 23:41:59 -0800
Message-ID: <20151124074159.GA32289@infradead.org>
References: <20151121005001.20398.92856.stgit@birch.djwong.org>
 <20151121005014.20398.22316.stgit@birch.djwong.org>
 <20151121180644.GA23916@infradead.org>
 <20151123212533.GC10589@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com,
	fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com,
	linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com,
	linux-btrfs@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151123212533.GC10589@birch.djwong.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 23, 2015 at 01:25:33PM -0800, Darrick J. Wong wrote:
> > Shouldn't these be Invalid argument just like the
> > to a device case above or the clone case?
> 
> I was trying to mirror the behavior of reflink, which spits out
> EOPNOTSUPP when the destination isn't a regular file and EINVAL
> when the source isn't a regular file.

clone is called on the destination and takes the source from the
ioctl argument.  dedupe is called on the source and then opens the
destinations, so they're not really comparable.  Btrfs currently
returns EACCES for non-dir, non-regular destinations which look
wrong and I think EINVAL for a mismatch between source and destination
types would make most sense.  I've also prepared a btrfs patch for
this and clone, but I'd like to have consensus on the exact error
first.
