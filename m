From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/34] libext2fs/e2fsck: refactor everyone who writes
 zero blocks to disk
Date: Mon, 13 Oct 2014 10:09:00 -0700
Message-ID: <20141013170900.GD12009@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221259.13646.60917.stgit@birch.djwong.org>
 <20141013100903.GD9738@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41448 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaJMRJH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2014 13:09:07 -0400
Content-Disposition: inline
In-Reply-To: <20141013100903.GD9738@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2014 at 06:09:03AM -0400, Theodore Ts'o wrote:
> On Sat, Sep 13, 2014 at 03:12:59PM -0700, Darrick J. Wong wrote:
> > Convert all call sites that write zero blocks to disk to use
> > ext2fs_zero_blocks2() since it can use Linux's zero out feature to do
> > the writes more quickly.  Reclaim the zero buffer at freefs time and
> > make the write-zeroes fallback use a larger buffer.
> 
> This patch doesn't actually convert Linux to use the zero out feature,

Assuming you meant '...convert e2fsprogs to use...'?

(You're right, it converts e2fsprogs to use ext2fs_zero_blocks(), which at this
point in the patch series might call BLKZEROOUT.)

> and I'm not entirely sure how much benefit this is going to actually
> give us, since in most of the places which you are converting to use
> ext2fs_zero_blocks2() is only zero'ing a block or two.
> 
> On the cost side of the equation, the first time we try to zero out a
> single 4k block, this patch causes us to ignore the block allocated
> and passed into ext2fs_alloc_block2(), and instead allocate a 4
> megabyte buffer which is used only for ext2fs_zero_blocks2, which is
> not released until e2fsck/mke2fs/resize2fs exits.
> 
> If we had reliable trim/discard that was guaranteed to zero a block
> and would never be dropped by the storage device, then maybe it would
> be worth it, but as it is, the only real benefit I see from this patch
> is the fact that patch results in the deletion of 84 lines of code.

I'm not calling discard/trim, I'm calling blkzeroout or (in the next patchbomb
rev) file punch.  Zero-out is supposed to be mandatory, unlike its flakey
cousin discard.  Right?

> Maybe it would be worth it to add a ext2fs_zero_blocks3() which takes
> an optional temporary buffer, much like the other if we really want to
> do the code refactor?

Yes, I think that would be a good idea -- only allocate the static buffer if
the caller declines to provide one.

> 					- Ted
> 
> P.S.  Did you really see a speedup in using a 4MB zero block buffer,
> instead of a 32k block buffer?  The reason why I had chosen a stride
> length of 8 was that some ten years ago, using hardware I had at my
> disposal, using a larger zero buffer really didn't improve performance
> any.  I'm sure that things have changed since then, but on what
> systems were you testing that motivated going to a 4 meg buffer?

A bunch of (probably crummy) consumer grade SSDs.  I suspect the erase size is
4MB, or at least a few megabytes. :)

I also noticed that my throwaway RAID0 (stripe size 512K) got faster at mkfs
time since it could issue IO to multiple disks simultaneously.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
