From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] libext2fs/e2fsck: implement metadata prefetching
Date: Thu, 27 Feb 2014 10:31:02 -0800
Message-ID: <20140227183102.GA9793@birch.djwong.org>
References: <20140130235044.31064.38113.stgit@birch.djwong.org>
 <20140130235058.31064.21096.stgit@birch.djwong.org>
 <45DEEA58-69FD-42EF-BB51-1A8D80000469@dilger.ca>
 <20140131135325.GF7118@thunk.org>
 <530F6FFC.4040903@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32897 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaB0SbL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Feb 2014 13:31:11 -0500
Content-Disposition: inline
In-Reply-To: <530F6FFC.4040903@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 27, 2014 at 12:03:56PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 1/31/2014 8:53 AM, Theodore Ts'o wrote:
> > Something that we might need to go to in the future is instead of 
> > using mmap(), to maintain our own explicit buffer cache inside 
> > unix_io, and use direct I/O to avoid caching the disk blocks
> > twice. Then when we use a single-threaded disk prefetcher, managed
> > by the unix_io, it will know when a particular I/O request has
> > completed, and more importantly, if there is a synchronous read
> > request coming in from main body of the program, it can stop
> > prefetching and allow the higher priority read to complete.  We can
> > also experiment with how many threads might make sense --- even
> > with an HDD, using multiple threads so that we can take advantage
> > of NCQ might still be a win.
> 
> Why build your own cache instead of letting the kernel take care of
> it?  I  believe the IO elevator already gives preferential treatment
> to blocking reads so just using readahead() to prefetch and sticking
> with plain old read() should work nicely.
> 
> > Finally, if we are managing our own buffer cache, we should
> > consider adding a bforget method to the I/O manager.  That way
> > e2fsck can give hints to the caching layer that a block isn't
> > needed any more.  If it is in the cache, it can be dropped, to free
> > memory, and if it is still on the to-be-prefetched list it should
> > also be dropped.  (Of course, if a block is on the to-be-prefetched
> > list, and a synchronous read request comes in for that block, we
> > should have dropped it from the to-be-prefetched list at that
> > point.)  The main use for having a bforget method is for the most
> > part, once we are done scanning a non-directory extent tree block,
> > we won't be needing it again.
> 
> Good idea, but this also could just be translated to posix_fadvise to
> have the kernel drop the pages from the cache.

That's more or less what I've done with the e2fsck patchset I'm working on.
It's not terribly smarter than Val's old thing from ~2007, but nowadays more
people have the kind of hardware where prefetching is noticeable.

Well, pass2 tells the kernel to drop the dir block as soon as thinks it's
finished with the dir block.  I haven't studied the effect of dropping the
itable during pass1.

--D
