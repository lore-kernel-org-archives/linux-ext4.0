From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] dynamic inodes
Date: Fri, 26 Sep 2008 14:18:32 -0600
Message-ID: <20080926201832.GG10950@webber.adilger.int>
References: <48DA28B0.2020207@sun.com>
 <20080925223731.GM10950@webber.adilger.int> <20080926021132.GA11413@mit.edu>
 <20080926103322.GA10950@webber.adilger.int> <20080926143309.GC11413@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Alex Tomas <bzzz@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54714 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYIZUS4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 16:18:56 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8QKIuV2023561
	for <linux-ext4@vger.kernel.org>; Fri, 26 Sep 2008 13:18:56 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7T00001KB40A00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 26 Sep 2008 13:18:56 -0700 (PDT)
In-reply-to: <20080926143309.GC11413@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 26, 2008  10:33 -0400, Theodore Ts'o wrote:
> > We could special-case the placement of the GDT blocks in this case, and
> > then put them into the proper META_BG location when/if the blocks are
> > actually added to the filesystem.
> 
> Yes, but where do you put the GDT blocks in the case of where there is
> no more space in the reserved gdt blocks?  Using some inode is
> probably the best bet, since we would then know where to find the GDT
> blocks.

I agree that replicating a GDT inode is probably the easiest answer.
IIRC this was proposed also in the past, before META_BG was implemented.
To be honest, we should just deprecate META_BG at that time, I don't
think it was every used by anything, and still isn't properly handled
by the cross-product of filesystem features (online resize, others).

> My suggestion of using inode numbers growing downward from the top of
> the 2**32 number space was to avoid needing to move the GDT blocks
> into their proper place if and when the filesystem is grown;

How do inode numbers affect the GDT blocks?  Is it because high inode
numbers would be in correspondingly high "groups" and resizing could
be done "normally" without affecting the new GDT placement?

Once we move over to a scheme of GDT inodes, there isn't necessarily a
"proper place" for GDT blocks, so I don't know if that makes a difference.

I was going to object on the grounds that the GDT inodes will become too
large and sparse, but for a "normal" ratio (8192 inodes/group) this
only works out to be 32MB for the whole gdt to hit 2^32 inodes.

The other thing we should consider is the case where the inode ratio
is too high, and it is limiting the growth of the filesystem due to
2^32 inode limit.  With a default inode ratio of 1 inode/8192 bytes,
this hits 2^32 inodes at 262144 groups, or only 32TB...  We may need
to also be able to add "inodeless groups" in such systems unless we
also implement 2^64-bit inode numbers at the same time.

This isn't impossible, though the directory format would need to change
to handle 64-bit inode numbers, and some way to convert between the
leaf formats.

> it simplifies the code needed for the on-line resizing, and it also means
> that when you do the on-line resizing the filesystem gets more inodes
> if the inodes are dynamically grown automatically by the filesystem,
> maybe that's not a problem.

It probably makes sense to increase the "static" inode count proportionally
with the new blocks, since we already know the inode ratio is too small,
so I can see a benefit from this direction.

> > Alternately, we could put the GDT into the inode and replicate the whole
> > inode several times (the data would already be present in the filesystem).
> > We just need to select inodes from disparate parts of the filesystem to
> > avoid corruption (I'd suggest one inode from each backup superblock
> > group), point them at the existing GDT blocks, then allow the new GDT
> > blocks to be added to each one.  The backup GDT-inode copies only need
> > to be changed when new groups are added/removed.
> 
> Yes, that's probably the best solution, IMHO.
> 
> 					- Ted

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

