From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/25] libext2fs: don't overflow when punching indirect
 blocks with large blocks
Date: Wed, 23 Oct 2013 20:08:34 -0400
Message-ID: <20131024000834.GE31400@thunk.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018044928.7339.30260.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49895 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab3JXAIh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 20:08:37 -0400
Content-Disposition: inline
In-Reply-To: <20131018044928.7339.30260.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 09:49:28PM -0700, Darrick J. Wong wrote:
> On a FS with a rather large blockize (> 4K), the old block map
> structure can construct a fat enough "tree" (or whatever we call that
> lopsided thing) that (at least in theory) one could create mappings
> for logical blocks higher than 32 bits.  In practice this doesn't
> happen, but the 'max' and 'iter' variables that the punch helpers use
> will overflow because the BLOCK_SIZE_BITS shifts are too large to fit
> a 32-bit variable.  This causes punch to fail on TIND-mapped blocks
> even if the file is < 16T.  So enlarge the fields to fit.

Hmm.... this brings up the question of whether we should support
inodes that have indirect block maps that result in mappings for
logical blocks > 32-bits.  There is probably a lot of code that
assumes that the logical block number is 32-bits that will break
horribly.

So things brings up a couple of different questions.

#1) Does e2fsck notice, and does it complain if it trips against one
of these.

#2) What should e2fsprogs do when it comes across one of these inodes.
It may be that simply returning an error is enough, once we notice
that it hsa blocks larger than this.  Would it be cleaner and more
efficient for the punch code to simply make sure that it stops before
the logical block number overflows?  64-bit variables have a cost,
especially on 32-bit machines.

					- Ted
