From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] libext2fs/e2fsck: implement metadata prefetching
Date: Fri, 31 Jan 2014 08:53:25 -0500
Message-ID: <20140131135325.GF7118@thunk.org>
References: <20140130235044.31064.38113.stgit@birch.djwong.org>
 <20140130235058.31064.21096.stgit@birch.djwong.org>
 <45DEEA58-69FD-42EF-BB51-1A8D80000469@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53077 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbaAaNx2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Jan 2014 08:53:28 -0500
Content-Disposition: inline
In-Reply-To: <45DEEA58-69FD-42EF-BB51-1A8D80000469@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 31, 2014 at 03:10:00AM -0700, Andreas Dilger wrote:
> We implemented something like this for a metadata scanning tool called
> "e2scan".  At the time, the fastest method of prefetching data was
> posix_fadvise(POSIX_FADV_WILLNEED). We also tried the readahead() syscall. 

I think using posix_fadvise() and readahead() is probably the best way
to go, at least initially.  If we can avoid needing to add an extra
I/O manager, I think that would be better.

As far as a single HDD prefetching its brains out, it would be good if
we can figure out a way to enable the right amount of prefetching
automatically.  Something that might be worth trying is to instrument
unix_io so we can measure the time waiting for disk I/O, and then
compare that to the wall clock time running on a single disk file
system, without doing any prefetching.

If there isn't any delta, then the only way prefetching could help us
is if we can optimize the head motion and remove some seeks (i.e., if
we know that we will need block #23 in the future, and we get a
request for block #24, we can read both at one go).  If we measure the
difference between time spent for disk I/O during each e2fsck pass,
and wall clock time during each I/O, we'll also know which e2fsck pass
would benefit the most from smarter prefetching.

What that might imply is that for HDD's --- which is where we would
want something like this the most --- what we might want to do is to
create a list of blocks that e2fsck knows it will need next (for
example, during pass 1, we are collecting the blocks for directories,
so we could use that to populate the prefetch list for pass 2.

Something that we might need to go to in the future is instead of
using mmap(), to maintain our own explicit buffer cache inside
unix_io, and use direct I/O to avoid caching the disk blocks twice.
Then when we use a single-threaded disk prefetcher, managed by the
unix_io, it will know when a particular I/O request has completed, and
more importantly, if there is a synchronous read request coming in
from main body of the program, it can stop prefetching and allow the
higher priority read to complete.  We can also experiment with how
many threads might make sense --- even with an HDD, using multiple
threads so that we can take advantage of NCQ might still be a win.

One other thought.  The location of the dynamic metadata blocks (i.e.,
directory and extent tree blocks) is a hint that we could potentially
store in the file system.  Since it is only for optimization purposes,
e2fsck can try to find it in the file system, and if it is there, and
it looks valid it can use it.  If the file system is too corrupted, or
the data looks suspect, it can always ignore the cached hints.

Finally, if we are managing our own buffer cache, we should consider
adding a bforget method to the I/O manager.  That way e2fsck can give
hints to the caching layer that a block isn't needed any more.  If it
is in the cache, it can be dropped, to free memory, and if it is still
on the to-be-prefetched list it should also be dropped.  (Of course,
if a block is on the to-be-prefetched list, and a synchronous read
request comes in for that block, we should have dropped it from the
to-be-prefetched list at that point.)  The main use for having a
bforget method is for the most part, once we are done scanning a
non-directory extent tree block, we won't be needing it again.  

Slightly more complex (so it might not be worth it), we could also
drop inode table blocks from our buffer cache that do not contain any
directory inodes once we are done scanning them in pass 1.

Cheers,

						- Ted
