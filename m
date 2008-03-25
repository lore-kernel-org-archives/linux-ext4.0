From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH e2fsprogs-next] Fix extent flag validity tests in pass1
	on big endian boxes.
Date: Mon, 24 Mar 2008 22:19:37 -0400
Message-ID: <20080325021937.GE30110@mit.edu>
References: <47E82796.9050807@redhat.com> <20080325003250.GM2691@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33765 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755958AbYCYCUT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 22:20:19 -0400
Content-Disposition: inline
In-Reply-To: <20080325003250.GM2691@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 24, 2008 at 06:32:51PM -0600, Andreas Dilger wrote:
> On Mar 24, 2008  17:13 -0500, Eric Sandeen wrote:
> > Extent data is shared with the i_block[] space in the inode,
> > but it is always swapped on access, not when the inode is read.
> > 
> > In e2fsck/pass1.c we must be careful when checking validity
> > of the extents flag on the inode.  If the flag was set when
> > the inode was read & swapped, then the extents data itself
> > (in ->i_block[]) was NOT swapped, so testing for a valid
> > extent header requires some swapping first.  Then, if we
> > ultimately set the extents flag, all of i_block[] must be
> > re/un-swapped.
> 
> This seems pretty awkward for any other users of the library.  Having the
> i_block[] array NOT be swabbed if it is an extent file means that every
> place in the code which is accessing this array also needs to do the
> swabbing itself.  This would break the abstraction that the in-memory
> inode is in host-endian order, and also forces every application to
> understand the difference between extent- and non-extent-mapped inodes,
> and the on-disk byte order.  Ugh.

I did this design intentionally, because the *only* part of e2fsprogs
which is supposed to know about byte-swapping is lib/ext2fs/extents.c.
Well, at least normally unless EXTENTS_FL is wrongly set or unset.  So
e2fsck needs to have some special case code to undo swapping
i_blocks[], but that's the only part of the library that will need to
deal with byte-swapping extents.

The reason why I did that is was because I didn't want to have a lot
of messy code in lib/ext2fs/swapfs.c that might need to change if we
needed to support new extents format (some of which might have more
complicated byte-swapping formats) in order to support 64-bit block
numbers, for example --- or, if we end up using a bit-packed more
compressible format so we can fit more extents into i_blocks[].  So
right now, by *design* the only place that needs to know about extents
formats is lib/ext2fs/extent.c.

						- Ted
