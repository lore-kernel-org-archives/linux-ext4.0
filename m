From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Memory allocation failed, e2fsck: aborted
Date: Fri, 20 Aug 2010 08:46:42 -0400
Message-ID: <20100820124642.GB4053@thunk.org>
References: <20100818140422.GL27457@skl-net.de>
 <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca>
 <20100819130123.GU16603@skl-net.de>
 <ABE19F5B-74C8-47E9-B359-D3FB2C137087@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andre Noll <maan@systemlinux.org>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41093 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0HTOPM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Aug 2010 10:15:12 -0400
Content-Disposition: inline
In-Reply-To: <ABE19F5B-74C8-47E9-B359-D3FB2C137087@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 19, 2010 at 01:03:06PM -0600, Andreas Dilger wrote:
> 
> I think the problem isn't just the TOTAL amount of RAM being used,
> but the fact that this piece of code is trying to do a SINGLE
> allocation that is HUGE.  The second problem is that the constant
> re-allocation of this huge array (every 100 insertions) means that
> it can never really exceed 1/2 of RAM in size.

Part of the problem is that the data structures are optimized for
relatively few hard links and a reasonable number of directories
compared to other types of inodes.  For people who are using hard-link
backup schemes, these assumptions are violated in some fairly massive
ways.

Something that might be interesting to do is to keep some statistics
in the superblock about the number of hard links.  This would allow
e2fsck to allocate the data structures appropriately up front, and
maybe allow it to switch to some other representation if it turns out
the file system is one which is dense with hard links.

> That said, any insert-optimized tree structure with a high fan-out
> would be suitable.  Elements are almost never deleted, and we would
> never need to compact the tree (it is freed as a whole when it is
> done).

We could try to create a tree-optimized data structure, but I wonder
if it's worth it.  IIRC berk_db has an in-memory and file-backed
option, and it has a btree option.  Using that might be easier than
trying to hand-code something special.

							- Ted
