From: tytso@mit.edu
Subject: Re: [PATCH 1/3] ext4: Fix insertion point of extent in
 mext_insert_across_blocks()
Date: Wed, 3 Mar 2010 20:25:09 -0500
Message-ID: <20100304012508.GD3530@thunk.org>
References: <4B8E0679.8060706@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55288 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab0CDBZO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Mar 2010 20:25:14 -0500
Content-Disposition: inline
In-Reply-To: <4B8E0679.8060706@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 03, 2010 at 03:49:29PM +0900, Akira Fujita wrote:
> ext4: Fix insertion point of extent in mext_insert_across_blocks()
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> If the leaf node has 2 extent space or fewer and
> EXT4_IOC_MOVE_EXT ioctl is called
> with the file offset where after the 2nd extent covers,
> mext_insert_across_blocks() always tries to insert extent into the first extent.
> As a result, the file gets corrupted because of
> wrong extent order.  The patch fixes this problem.

Do you have test cases that we can use as part of a regression test
suite to test the EXT4_IOC_MOVE_EXT ioctl?  I'm very glad you found
these problems (although timing --- right before the merge window is
about to close --- wasn't exactly ideal), but what's more important to
me is how we get better regression testing.

The other two two patches are obviously correct, but this one is going
to require me to spend a long time staring at the verious corner cases
in order for me to convince myself that it is totally safe.  If we had
a set of test cases where we could easily verify the "before" and
"after" file system images as being correct, and then combined it with
a code coverage tool, it would make it a lot easier to validate future
patches in fs/ext4/move_extent.c.

It would be useful for other parts of the kernel as well, but at least
for the standard extents function we have some fairly aggressive
generic file system tests, combined with the fact that
fs/ext4/extents.c gets exercised much more frequently than
fs/ext4/move_extents.c.

So the question is how can get we get to the point where we can
comfortable tell people that e2defrag is totally safe, and has no
chance of corrupting their data?

						- Ted

P.S.  Here's another random idea for how we might aggressively test
the EXT4_IOC_MOVE_EXT ioctl: (1) create an empty filesystem, (2)
create a tool which randomly sets 50% of the bits in the block
allocation bitmap, marking them as in use, and making the free space
look very badly fragmented.  (3) write a large number of files into
the filesystem.  (4) calculate the checksums for all of the files.
(5) run e2fsck on the filesystem to fix up the block allocation
bitmap.  (6) defrag all of the files on the filesystem.  (7) use
e2fsck to make sure the filesystem is still consistent.  (8) calculate
the checksums for all of the files to make sure they still contain
their original data.

