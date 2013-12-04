From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/25] libext2fs: don't overflow when punching indirect
 blocks with large blocks
Date: Tue, 3 Dec 2013 20:40:27 -0800
Message-ID: <20131204044027.GN9535@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018044928.7339.30260.stgit@birch.djwong.org>
 <20131024000834.GE31400@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40125 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3LDEkd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 23:40:33 -0500
Content-Disposition: inline
In-Reply-To: <20131024000834.GE31400@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 23, 2013 at 08:08:34PM -0400, Theodore Ts'o wrote:
> On Thu, Oct 17, 2013 at 09:49:28PM -0700, Darrick J. Wong wrote:
> > On a FS with a rather large blockize (> 4K), the old block map
> > structure can construct a fat enough "tree" (or whatever we call that
> > lopsided thing) that (at least in theory) one could create mappings
> > for logical blocks higher than 32 bits.  In practice this doesn't
> > happen, but the 'max' and 'iter' variables that the punch helpers use
> > will overflow because the BLOCK_SIZE_BITS shifts are too large to fit
> > a 32-bit variable.  This causes punch to fail on TIND-mapped blocks
> > even if the file is < 16T.  So enlarge the fields to fit.
> 
> Hmm.... this brings up the question of whether we should support
> inodes that have indirect block maps that result in mappings for
> logical blocks > 32-bits.  There is probably a lot of code that
> assumes that the logical block number is 32-bits that will break
> horribly.

I'm not sure.  The way I noticed this brokeness was by creating a FS with 64k
blocks, sparse-writing a range of blocks at lblk 268451854 (to force it to
create a tind map) and then try to punch it.  The file itself had a size of
just under 16T.  e2fsck seemed fine with the file, and as you can see the lblk
number was nowhere close to 2^32.

I think the problem is that the punch code is using two variables max and incr
as upper limits on how many blocks it should try to punch for a given level.
Since the variables aren't wide enough, they overflow (effectively becoming
zero) and then things like (offset + incr(0) <= start) become true and so it
quits early.

---

If I use fuse2fs to create a non-extent file that exceeds 2^32 blocks (and
blocksize > 4k), fsck doesn't complain.

If the blocksize is 4k or less, the kernel refuses to write the file, but
fuse2fs creates a garbled filesystem (with enormous i_size but no blocks
mapped) and fsck complains.  Hmm, I'll look into that.

--D

> 
> So things brings up a couple of different questions.
> 
> #1) Does e2fsck notice, and does it complain if it trips against one
> of these.
> 
> #2) What should e2fsprogs do when it comes across one of these inodes.
> It may be that simply returning an error is enough, once we notice
> that it hsa blocks larger than this.  Would it be cleaner and more
> efficient for the punch code to simply make sure that it stops before
> the logical block number overflows?  64-bit variables have a cost,
> especially on 32-bit machines.
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
