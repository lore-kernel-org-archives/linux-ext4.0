From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] dynamic inodes
Date: Fri, 26 Sep 2008 04:33:22 -0600
Message-ID: <20080926103322.GA10950@webber.adilger.int>
References: <48DA28B0.2020207@sun.com>
 <20080925223731.GM10950@webber.adilger.int> <20080926021132.GA11413@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Alex Tomas <bzzz@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65292 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYIZKdq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 06:33:46 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8QAXic8004856
	for <linux-ext4@vger.kernel.org>; Fri, 26 Sep 2008 03:33:45 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7S00K01TA3NV00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 26 Sep 2008 03:33:44 -0700 (PDT)
In-reply-to: <20080926021132.GA11413@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 25, 2008  22:11 -0400, Theodore Ts'o wrote:
> On Thu, Sep 25, 2008 at 04:37:31PM -0600, Andreas Dilger wrote:
> > If one adds a new group (ostensibly "at the end of the filesystem") that
> > has a flag which indicates there are no blocks available in the group,
> > then what we get is the inode bitmap and inode table, with a 1-block
> > "excess baggage" of the block bitmap and a new group descriptor.  The
> > "baggage" is small considering any overhead needed to locate and describe
> > fully dynamic inode tables.
>
> It's a good idea; and technically you don't have to allocate a block
> bitmap, given that the flag is present which says "no blocks
> available".  The reason for allocating it is if you're trying to
> maintain full backwards compatibility, it will work --- except that
> you need some way of making sure that the on-line resizing code won't
> screw with the filesystem --- so the feature would have to be a
> read/only compat feature anyway.

Sure, I agree it is possible to go either way.  I was just trying to
go for the element of least surprise.  Having a group with
"bg_block_bitmap = 0" would be strange, but no more strange than having
a group for blocks beyond the end of the filesystem...

> To do on-line resizing, you'd have to clear the flag and then know to
> that the first "inode-only" block group should be given the new
> blocks.

Right.

> > The itable location would be replicated to all of the group descriptor
> > backups for safety, though we would need to find a way for "META_BG"
> > to store a backup of the GDT in blocks that don't exist, in the case
> > where increasing the GDT size in-place isn't possible.
>
> This is actually the big problem; with META_BG, in order to find the
> group descriptor blocks, it assumes that the first group descriptor
> can be found at the beginning of the group descriptor block, which
> means it has to be found at a certain offset from the beginning of the
> filesystem.  And this would not be true for inode-only block groups.

We could special-case the placement of the GDT blocks in this case, and
then put them into the proper META_BG location when/if the blocks are
actually added to the filesystem.

> The simplest solution actually would be to to allocate inodes from the
> *end* of the 32-bit inode space, growing downwards, and having those
> inodes be stored in a reserved inode.  You would lose block locality,
> although that could be solved by adding a block group affinity field
> in the inode structure which is used by "extended inodes".

I don't see how growing the inode numbers downward really helps anything.
With FLEX_BG there already is no "affinity" between the inodes and the
blocks.  The drawback of putting the inode table into an inode is that
this is relatively fragile if the inode is corrupted.  We'd want to have
replication of the inode itself (we couldn't replicate the whole inode
table very efficiently).

Alternately, we could put the GDT into the inode and replicate the whole
inode several times (the data would already be present in the filesystem).
We just need to select inodes from disparate parts of the filesystem to
avoid corruption (I'd suggest one inode from each backup superblock
group), point them at the existing GDT blocks, then allow the new GDT
blocks to be added to each one.  The backup GDT-inode copies only need
to be changed when new groups are added/removed.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

