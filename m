From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC] fs: add FIEMAP_FLAG_DISCARD support
Date: Mon, 4 Nov 2013 17:17:31 -0800
Message-ID: <20131105011731.GA4586@infradead.org>
References: <1383435930-29295-1-git-send-email-tytso@mit.edu>
 <20131104100343.GA10004@infradead.org>
 <20131105005146.GA26249@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131105005146.GA26249@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 04, 2013 at 07:51:46PM -0500, Theodore Ts'o wrote:
> The an application in question wants to treat a large file as if it
> were a block device --- that's hardly unprecedented; enterprise
> databases tend to prefer using raw block devices (at least for
> benchmarking purposes), but system administrators like to
> administrative convenience of using a file system.

Totally reasonable use case.

> 
> The goal here is get the performace as close to a raw block device as
> possible.  Especially if you are using fast flash, the overhead of
> deallocating blocks using punch, only to reallocate the blocks when we
> later write into them, is just unnecessary overhead.  Also, if you
> deallocate the blocks, they could end up getting grabbed by some other
> block allocation, which means the file can end up getting very
> fragmented --- which doesn't matter that much for flash, I suppose,
> but it means the extent tree could end up growing and getting nasty
> over time.  The bottom line is why bother doing extra work when it's
> not necessary?

Now we're getting into trouble.  I'm all for optimizing for a use case
someone cares for.  But exposing intimate implementation of that use
case is almost always a bad idea.

So having a new fallocate to zero out parts of a file and not requiring
an allocation to back the file is fine.  If it is on a filesystem
supporting discards with the discard zeroes blocks flag we can use the
implementation from your patch.  If the device doesn't support discards
or doesn't zero them we'd need to implement it like the
XFS_IOC_ZERO_RANGE ioctl.

Note that exposing stale blocks is a problem at the block device level,
too.  If you look at the openstack volume service for example they have
to explicitly zero out volumes during volume creation or deletion to
make sure no data is exposed to another tenant.  The only way to
avoid that is to have some auto-zeroing extent state either in software
or hardware.
