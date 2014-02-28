From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] libext2fs/e2fsck: implement metadata prefetching
Date: Thu, 27 Feb 2014 21:28:26 -0500
Message-ID: <20140228022826.GA31809@thunk.org>
References: <20140130235044.31064.38113.stgit@birch.djwong.org>
 <20140130235058.31064.21096.stgit@birch.djwong.org>
 <45DEEA58-69FD-42EF-BB51-1A8D80000469@dilger.ca>
 <20140131135325.GF7118@thunk.org>
 <530F6FFC.4040903@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35051 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbaB1DC6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Feb 2014 22:02:58 -0500
Content-Disposition: inline
In-Reply-To: <530F6FFC.4040903@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 27, 2014 at 12:03:56PM -0500, Phillip Susi wrote:
> 
> Why build your own cache instead of letting the kernel take care of
> it?  I  believe the IO elevator already gives preferential treatment
> to blocking reads so just using readahead() to prefetch and sticking
> with plain old read() should work nicely.

The reason why it might be better for us to use our own cache is
because we can more accurately know when we're done with the block,
and we can drop it from the cache.

I suppose we could use posix_fadvise(POSIX_FADV_DONTNEED) --- and
hopefully this works on block devices for the buffer cache, but it
wouldn't all surprise me that if we can get finer-grained control if
we use O_DIRECT and manage the buffers ourselves.  Whether it's worth
the extra complexitry is a fair question --- but simply adding
metadata prefetching is going to add a fair amount of complexity
already, and we should test to make sure that readahead() and
posix_fadvise() actually work correctly on block devices --- a couple
of years ago, I had explored readahead() precisely as a cheap way of
adding metadata precaching for e2fsck, and it was a no-op when I tried
the test back then.

						- Ted
