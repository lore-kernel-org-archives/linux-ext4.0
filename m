From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] dynamic inodes
Date: Thu, 25 Sep 2008 22:11:32 -0400
Message-ID: <20080926021132.GA11413@mit.edu>
References: <48DA28B0.2020207@sun.com> <20080925223731.GM10950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <bzzz@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41635 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755234AbYIZCLf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Sep 2008 22:11:35 -0400
Content-Disposition: inline
In-Reply-To: <20080925223731.GM10950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 25, 2008 at 04:37:31PM -0600, Andreas Dilger wrote:
> If one adds a new group (ostensibly "at the end of the filesystem") that
> has a flag which indicates there are no blocks available in the group,
> then what we get is the inode bitmap and inode table, with a 1-block
> "excess baggage" of the block bitmap and a new group descriptor.  The
> "baggage" is small considering any overhead needed to locate and describe
> fully dynamic inode tables.

It's a good idea; and technically you don't have to allocate a block
bitmap, given that the flag is present which says "no blocks
available".  The reason for allocating it is if you're trying to
maintain full backwards compatibility, it will work --- except that
you need some way of making sure that the on-line resizing code won't
screw with the filesystem --- so the feature would have to be a
read/only compat feature anyway.

To do on-line resizing, you'd have to clear the flag and then know to
that the first "inode-only" block group should be given the new
blocks.

> The itable location would be replicated to all of the group descriptor
> backups for safety, though we would need to find a way for "META_BG"
> to store a backup of the GDT in blocks that don't exist, in the case
> where increasing the GDT size in-place isn't possible.

This is actually the big problem; with META_BG, in order to find the
group descriptor blocks, it assumes that the first group descriptor
can be found at the beginning of the group descriptor block, which
means it has to be found at a certain offset from the beginning of the
filesystem.  And this would not be true for inode-only block groups.


The simplest solution actually would be to to allocate inodes from the
*end* of the 32-bit inode space, growing downwards, and having those
inodes be stored in a reserved inode.  You would lose block locality,
although that could be solved by adding a block group affinity field
in the inode structure which is used by "extended inodes".

       	     	       	     	     		  - Ted
