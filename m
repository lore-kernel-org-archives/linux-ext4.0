From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: e2fsprogs-1.39-tyt3
Date: Tue, 1 May 2007 01:56:41 -0600
Message-ID: <20070501075641.GB5967@schatzie.adilger.int>
References: <E1HiXhp-0002Fi-Mm@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:35543 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965635AbXEAH4n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 May 2007 03:56:43 -0400
Content-Disposition: inline
In-Reply-To: <E1HiXhp-0002Fi-Mm@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 30, 2007  11:22 -0400, Theodore Ts'o wrote:
> One concern I still have is the fact that we're exposing a lot of
> interfaces in libext2fs.so which are very specifically tied to the
> current 48-bit physical/32-bit logical on-disk extent data structure.
> If/when we add support for the 64/64-bit extent data structure, and some
> kind of compressed/bit-packed extent format, those interfaces will have
> to be extended.

Some other comments:
- it appears you have all of extents.c copied into both "block.c" and
  in "extent.c"
- it appears you are missing a couple of extent sanity checks for headers
  and such that were added more recently, but those might also have been
  removed by you
- do the patches as they stand actually fix the duplicate block test
  cases yet?  It seems all of the BLOCK_CHANGED handling was removed
  from block_iterate_extents().
- it would be easier to read if the patches were generated with "diff -up"
  (can be set in .quiltrc via 'export QUILT_DIFF_OPTS="-up"'.  I also like
  "export QUILT_NO_DIFF_TIMESTAMPS=1" to avoid tons of gratuitous changes
  to patches when they are refreshed.

> Another problem is that while external extent blocks are getting byte
> swapped, there is no byte swapping going on for the extents stored in
> the inode.  I haven't tried it on a big endian system, such as Power
> machine, but I'm pretty sure it's going to blow up spectacularly.

Ah, interesting.  We have 64-bit machines for testing, but no big-endian
ones.

> The patches can be found at:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim/e2fsprogs-1.39-tyt3

What else I think is important to get into this patch series is a change
to "mkfs.ext4" so that the default inode size is increased to 256.  I'm
not sure how/if this can be done via mke2fs.conf.

I also wouldn't object to changing the default inode_ratio on large
filesystems to be a lot fewer than 1/8192 bytes.  At a minimum, allowing
an inode_ratio > 1/4MB should be allowed.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
