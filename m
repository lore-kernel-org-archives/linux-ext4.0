From: Theodore Tso <tytso@mit.edu>
Subject: Re: Fallocate and DirectIO
Date: Fri, 12 Jun 2009 13:33:01 -0400
Message-ID: <20090612173301.GC6417@mit.edu>
References: <20090612123112.GB25239@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57846 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbZFLRdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Jun 2009 13:33:07 -0400
Content-Disposition: inline
In-Reply-To: <20090612123112.GB25239@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 12, 2009 at 06:01:12PM +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> I noticed yesterday that a write to fallocate
> space via directIO results in fallback to buffer_IO. ie the userspace
> pages get copied to the page cache and then call a sync.
> 
> I guess this defeat the purpose of using directIO. May be we should
> consider this a high priority bug.

I agree that many of users of fallocate() feature (i.e. databases) are
going to consider this to be a major misfeature.

There's going to be a major performance hit though --- O_DIRECT is
supposed to be synchronous if all of the alignment requirements are
met, which means that by the time the write(2) system call returns,
the data is guaranteed to be on disk.  But if we need to manipulate
the extent tree to indicate that the block is now in use (so the data
is actually accessible), do we force a synchronous journal commit or
not?  If we don't, then a crash right after an O_DIRECT right into an
uninitialized region will cause the data to be "lost" (or at least,
unavailable via the read/write system call).  If we do, then the first
write into uninitialized block will cause a synchronous journal commit
that will be Slow And Painful, and it might destroy most of the
performance benefits that might tempt an enterprise database client to
use fallocate() in the first place.

I wonder how XFS deals with this case?  It's a problem that is going
to hit any journalled filesystem that wants to support fallocate() and
direct I/O.

One thing I can think of potentially doing is to check to see if the
extent tree block has already been journalled, and if it is not
currently involved the current transaction or the previous committing
transaction, *and* if there is space in the extent tree to mark the
current unitialized block as initialized (i.e., if the extent needs to
be split, there is sufficient space so we don't have to allocate a new
leaf block for the extent tree), we could update the leaf block in
place and then synchronously write it out, and thus avoid needing to
do a synchronous journal commit.

In any case, adding this support is going to be non-trivial.  If
someone has time to work on it in the next 2-3 weeks or so, I can push
it to Linus as a bug fix --- but I'm concerned the fixing this may be
tricky enough (and the patch invasive enough) that it might be
challenging to get this fixed in time for 2.6.31.

						- Ted
