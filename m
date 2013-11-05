From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] fs: add FIEMAP_FLAG_DISCARD support
Date: Mon, 4 Nov 2013 19:51:46 -0500
Message-ID: <20131105005146.GA26249@thunk.org>
References: <1383435930-29295-1-git-send-email-tytso@mit.edu>
 <20131104100343.GA10004@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54224 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab3KEAvw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Nov 2013 19:51:52 -0500
Content-Disposition: inline
In-Reply-To: <20131104100343.GA10004@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 04, 2013 at 02:03:43AM -0800, Christoph Hellwig wrote:
> 
> Besides that I really miss an explanation what the intended use cases
> are.  What does this buy us over punching a hole on an actual real
> workload?  Where is the overhead?  Is it our shitty discard
> implementation? If so there's tons of low hanging fruit to fix there
> anyway that we shouldn't work around by interfaces taking shortcuts.
> Is it problems in ext4's extent management on hole punch?  Is the
> bit of metadata created when doing an actual hole punch too much for
> that very specific workload?

The an application in question wants to treat a large file as if it
were a block device --- that's hardly unprecedented; enterprise
databases tend to prefer using raw block devices (at least for
benchmarking purposes), but system administrators like to
administrative convenience of using a file system.

The goal here is get the performace as close to a raw block device as
possible.  Especially if you are using fast flash, the overhead of
deallocating blocks using punch, only to reallocate the blocks when we
later write into them, is just unnecessary overhead.  Also, if you
deallocate the blocks, they could end up getting grabbed by some other
block allocation, which means the file can end up getting very
fragmented --- which doesn't matter that much for flash, I suppose,
but it means the extent tree could end up growing and getting nasty
over time.  The bottom line is why bother doing extra work when it's
not necessary?

If people don't like exposing this via FIEMAP, we could just simply
make it available via the BLKDISCARD ioctl, which already exists
(although currently it is only implemented for block devices).

					- Ted
