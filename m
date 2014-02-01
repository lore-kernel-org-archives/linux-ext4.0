From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] libext2fs/e2fsck: implement metadata prefetching
Date: Sat, 1 Feb 2014 00:16:46 -0800
Message-ID: <20140201081646.GF8798@birch.djwong.org>
References: <20140130235044.31064.38113.stgit@birch.djwong.org>
 <20140130235058.31064.21096.stgit@birch.djwong.org>
 <45DEEA58-69FD-42EF-BB51-1A8D80000469@dilger.ca>
 <20140131135325.GF7118@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37764 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaBAIQ4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Feb 2014 03:16:56 -0500
Content-Disposition: inline
In-Reply-To: <20140131135325.GF7118@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 31, 2014 at 08:53:25AM -0500, Theodore Ts'o wrote:
> On Fri, Jan 31, 2014 at 03:10:00AM -0700, Andreas Dilger wrote:
> > We implemented something like this for a metadata scanning tool called
> > "e2scan".  At the time, the fastest method of prefetching data was
> > posix_fadvise(POSIX_FADV_WILLNEED). We also tried the readahead() syscall. 

Thanks, Andreas! :)

Hmm.  I pulled in that patch and rewrites the prefetcher routines to
spawn a single thread to try to pull in the bitmaps and itable via
posix_fadvise.  I also noticed that e2fsck pass1 creates a list of
directory blocks to scan in pass2, so I restructured the prefetch code
to prefetch an arbitrary dblist.  The bitmap/itable prefetcher now
simply creates a dblist and hands it off to the dblist fetch routine.
It's also smart enough to do find contiguous runs of blocks and
fadvise the whole thing in with a single call.

The initial naive e2fsck implementation starts separate threads to
prefetch everything without caring if it blows out the cache.  This
seems to reduce e2fsck run times on SSD and RAIDs by 20-40%.

On the plus side the code became much easier, and fsck seems able to
repair a broken filesystem without crashing.  Welp, I guess that
teaches me not to go overboard with complexity until it's needed.

I made a few changes to Andreas' patch -- first, I changed the
parameters to ULL types to be consistent with the other IO manager
function prototypes; second, I made it a bit more robust for IO
managers that don't provide a readahead function.  (Does anyone still
build this on NT?)

> I think using posix_fadvise() and readahead() is probably the best way
> to go, at least initially.  If we can avoid needing to add an extra
> I/O manager, I think that would be better.

Agreed.  I will send new patches shortly.

> As far as a single HDD prefetching its brains out, it would be good if
> we can figure out a way to enable the right amount of prefetching
> automatically.  Something that might be worth trying is to instrument
> unix_io so we can measure the time waiting for disk I/O, and then
> compare that to the wall clock time running on a single disk file
> system, without doing any prefetching.

Changing to this fadvise mechanism seems to have eliminated the
horrible blowout on USB HDDs.  There's a slight speed decrease.

> If there isn't any delta, then the only way prefetching could help us
> is if we can optimize the head motion and remove some seeks (i.e., if
> we know that we will need block #23 in the future, and we get a
> request for block #24, we can read both at one go).  If we measure the
> difference between time spent for disk I/O during each e2fsck pass,
> and wall clock time during each I/O, we'll also know which e2fsck pass
> would benefit the most from smarter prefetching.
> 
> What that might imply is that for HDD's --- which is where we would
> want something like this the most --- what we might want to do is to
> create a list of blocks that e2fsck knows it will need next (for
> example, during pass 1, we are collecting the blocks for directories,
> so we could use that to populate the prefetch list for pass 2.
> 
> Something that we might need to go to in the future is instead of
> using mmap(), to maintain our own explicit buffer cache inside
> unix_io, and use direct I/O to avoid caching the disk blocks twice.
> Then when we use a single-threaded disk prefetcher, managed by the
> unix_io, it will know when a particular I/O request has completed, and
> more importantly, if there is a synchronous read request coming in
> from main body of the program, it can stop prefetching and allow the
> higher priority read to complete.  We can also experiment with how
> many threads might make sense --- even with an HDD, using multiple
> threads so that we can take advantage of NCQ might still be a win.
> 
> One other thought.  The location of the dynamic metadata blocks (i.e.,
> directory and extent tree blocks) is a hint that we could potentially
> store in the file system.  Since it is only for optimization purposes,
> e2fsck can try to find it in the file system, and if it is there, and
> it looks valid it can use it.  If the file system is too corrupted, or
> the data looks suspect, it can always ignore the cached hints.
> 
> Finally, if we are managing our own buffer cache, we should consider
> adding a bforget method to the I/O manager.  That way e2fsck can give
> hints to the caching layer that a block isn't needed any more.  If it
> is in the cache, it can be dropped, to free memory, and if it is still
> on the to-be-prefetched list it should also be dropped.  (Of course,
> if a block is on the to-be-prefetched list, and a synchronous read
> request comes in for that block, we should have dropped it from the
> to-be-prefetched list at that point.)  The main use for having a
> bforget method is for the most part, once we are done scanning a
> non-directory extent tree block, we won't be needing it again.  
> 
> Slightly more complex (so it might not be worth it), we could also
> drop inode table blocks from our buffer cache that do not contain any
> directory inodes once we are done scanning them in pass 1.

Let's play around with my silly prefetch patches and decide if we need
this extra complexity.

I thought about prefetching the extent tree too, but I'm not sure if
that's worth the trouble.  It might be worth it to go for the ETBs
that the inode points to directly, since that's more or less free.

--D
