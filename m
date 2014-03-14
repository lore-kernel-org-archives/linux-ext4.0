From: Dave Chinner <david@fromorbit.com>
Subject: Re: ext4 extent issue when page size > block size
Date: Fri, 14 Mar 2014 11:45:38 +1100
Message-ID: <20140314004538.GK4263@dastard>
References: <5321F226.80505@fr.ibm.com>
 <20140313212428.GE504@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cedric Le Goater <clg@fr.ibm.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, anton@samba.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:42951 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbaCNApm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2014 20:45:42 -0400
Content-Disposition: inline
In-Reply-To: <20140313212428.GE504@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2014 at 10:24:28PM +0100, Jan Kara wrote:
>   Hello,
> 
> On Thu 13-03-14 19:00:06, Cedric Le Goater wrote:
> > While running openldap unit tests on a ppc64 system, we have had 
> > issues with the cp command. cp uses the FS_IOC_FIEMAP ioctl to
> > optimize the copy and it appeared that the ext4 extent list of 
> > the file did not match all the data which was 'written' on disk. 
> > 
> > The system we use has a 64kB page size but the page size being 
> > greater than the filesystem block seems to be the top level reason 
> > of the problem. One can use a 1kB block size filesystem to reproduce 
> > the issue on a 4kB page size system.
> > 
> > Attached is a simple test case from Anton, which creates extents
> > as follow :
> > 
> > 	lseek(48K -1)		-> creates [11/1)
> > 	p = mmap(128K)
> > 	*(p) = 1		-> creates [0/1) with a fault
> > 	lseek(128K)		-> creates [31/1) 
> > 	*(p + 49K) = 1		-> creates [12/1) and then merges in [11/2) 
> > 	munmap(128K)

This shoul dbe easy to reproduce on a 4k page size machine using 512
byte block size. Yup, it is.

> > On a 4kB page size system, the extent list returned by FS_IOC_FIEMAP 
> > looks correct :
> > 
> > 	Extent 0: logical: 0 physical: 0 length: 4096 flags 0x006
> > 	Extent 1: logical: 45056 physical: 0 length: 8192 flags 0x006
> > 	Extent 2: logical: 126976 physical: 0 length: 4096 flags 0x007
> > 
> > 
> > But, with a 64kB page size, we miss the in-the-middle extent (no page
> > fault but the data is on disk) :
> > 
> > 	Extent 0: logical: 0 physical: 0 length: 49152 flags 0x006
> > 	Extent 1: logical: 126976 physical: 0 length: 4096 flags 0x007

Pretty much the same:

 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..3]:          11..14            0 (11..14)             4 00000
   1: [4..14]:         hole                                    11
   2: [15..15]:        15..15            0 (15..15)             1 00000

> > This looks wrong. Right ? Or are we doing something wrong ? I have been 
> > digging in the ext4 page writeback code. There are some caveats when 
> > blocksize < pagesize but I am not sure my understanding is correct. 
>   So you are completely right with the observation that in case like you
> describe we don't create delayed allocation extent for the block just
> beyond EOF. This is a problem which exists since day one when delayed
> allocation was introduced for ext4 (but also xfs and I dare to say any
> other fs doing delayed allocation).

The above was done on XFS, because ext4 doesn't support 512 byte
block sizes.

> delayed allocation extents on page fault - at that time file is only 48KB
> so we naturally don't allocate blocks for blocks beyond those 48KB. However
> after extending the file, the part of the page at offsets beyond 48KB
> suddently becomes part of the file and if you write some data there (no
> page fault happens because the page is already marked writeable in the page
> tables), we won't have any delayed allocation extent backing that data.
> 
> One thing to note here is that posix specifically says that extending file
> while it is mmaped has undefined consequences for the mmap so technically
> speaking if we would just throw away the data, we would still adhere to it.
> I don't think we should be so harsh but I mention this to explain why some
> weirdness may be acceptable.

Right - if you touch the mmap()d range beyond EOF before the file
is extended, we segv the application. So, really, it's just a bad
idea to do this.

> Anyway, fixing this isn't completely easy. I was looking into that some
> years ago and the best solution I've found back then was to writeprotect
> the last partial page whenever blocksize < pagesize, we are extending the
> file and creating hole in the last partial page beyond original EOF. This
> actually requires tweaking not only truncate path but also write path and
> the locking was somewhat hairy there because we need to writeprotect the
> tail page before updating i_size and make sure noone can fault it in again
> before the i_size is updated.

It's just another "we can't synchronise page faults against IO"
problem, just like we have with hole punching. The way we've
optimised truncate by using page locks and isize and mapping
checks is fine for simple cases where EOF isn't changing, but
the moment we need isize update vs page fault serialisation, or IO
vs page-fault-inside-EOF serialisation, we're screwed.

The whole concept that page faults are immune to/exempted from
filesystem IO serialisation requirements is fundamentally broken.
Until we fix that we're not going to be able to solve these
nasty corner cases.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
