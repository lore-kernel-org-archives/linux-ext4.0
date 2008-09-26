From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] dynamic inodes
Date: Fri, 26 Sep 2008 10:33:09 -0400
Message-ID: <20080926143309.GC11413@mit.edu>
References: <48DA28B0.2020207@sun.com> <20080925223731.GM10950@webber.adilger.int> <20080926021132.GA11413@mit.edu> <20080926103322.GA10950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <bzzz@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55883 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751621AbYIZOdO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 10:33:14 -0400
Content-Disposition: inline
In-Reply-To: <20080926103322.GA10950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 26, 2008 at 04:33:22AM -0600, Andreas Dilger wrote:
> > This is actually the big problem; with META_BG, in order to find the
> > group descriptor blocks, it assumes that the first group descriptor
> > can be found at the beginning of the group descriptor block, which
> > means it has to be found at a certain offset from the beginning of the
> > filesystem.  And this would not be true for inode-only block groups.
> 
> We could special-case the placement of the GDT blocks in this case, and
> then put them into the proper META_BG location when/if the blocks are
> actually added to the filesystem.

Yes, but where do you put the GDT blocks in the case of where there is
no more space in the reserved gdt blocks?  Using some inode is
probably the best bet, since we would then know where to find the GDT
blocks.

My suggestion of using inode numbers growing downward from the top of
the 2**32 number space was to avoid needing to move the GDT blocks
into their proper place if and when the filesystem is grown; it
simplifies the code needed for the on-line resizing, and it also means
that when you do the on-line resizing the filesystem gets more inodes
along with more blocks.  If we move the GDT blocks into their proper
place, then the filesystem gets more blocks, but not more inodes; but
if the inodes are dynamically grown automatically by the filesystem,
maybe that's not a problem.

> Alternately, we could put the GDT into the inode and replicate the whole
> inode several times (the data would already be present in the filesystem).
> We just need to select inodes from disparate parts of the filesystem to
> avoid corruption (I'd suggest one inode from each backup superblock
> group), point them at the existing GDT blocks, then allow the new GDT
> blocks to be added to each one.  The backup GDT-inode copies only need
> to be changed when new groups are added/removed.

Yes, that's probably the best solution, IMHO.

					- Ted
