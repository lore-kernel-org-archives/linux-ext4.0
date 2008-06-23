From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] resize2fs: Fix support for the uninit_bg feature
Date: Mon, 23 Jun 2008 14:42:01 -0600
Message-ID: <20080623204201.GG6239@webber.adilger.int>
References: <1213682792-4878-1-git-send-email-tytso@mit.edu>
 <1213682792-4878-2-git-send-email-tytso@mit.edu>
 <20080617151647.GD3726@webber.adilger.int> <20080617163038.GE12448@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45294 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbYFWUmE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 16:42:04 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5NKg3X1008349
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jun 2008 13:42:04 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2X00A01NNY7500@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 23 Jun 2008 13:42:03 -0700 (PDT)
In-reply-to: <20080617163038.GE12448@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 17, 2008  12:30 -0400, Theodore Ts'o wrote:
> On Tue, Jun 17, 2008 at 09:16:47AM -0600, Andreas Dilger wrote:
> > I'm a bit confused by this.  It doesn't seem that you use old_desc_blocks
> > in the META_BG case?  I'm trying to figure out what "old_desc_blocks"
> > means in the META_BG case.
> 
> In the META_BG case, s_first_meta_bg is the number of the "meta
> blockgroup" where the META_BG layout starts getting used.  The idea
> here is that you can have a traditional filesystem layout, and then
> instead of using ext2_prepare, you simply grow the block groups until
> the traditional block group descriptor space is filled out, and then
> after that, you switch over to the meta_bg layout.  

Sure, I'm aware of how META_BG works.

> To convert conversion between the block group number and a
> meta_block_group number, the formula is:
> 
>        block_grp_num = meta_bg_num * (block_size / descriptor_size)
> 
> Because of this, very conveniently fs->super->s_first_meta also is the
> size of the block group descriptors for block groups below the meta_bg
> boundary.  
> Hence, old_desc_blocks is the number of blocks used by block group
> descriptors for block groups that have the traditional block group
> descriptor layout.

Ah, this is what I wasn't seeing.  For the above code, can you please
add a comment to this effect.

> > A group descriptor would almost be the right struct, but it doesn't
> > (yet?) include the GDT block count, itable block count, or a flag if
> > there is a superblock.  Adding these fields into the on-disk group_desc
> > struct wouldn't be a bad idea, then all the need to recalculate the
> > group layout in 10 places would disappear.
> 
> It's not worth managing the disk format change, nor the space on disk
> for all this information, IMHO.

Given that the kernel increasingly needs to be able to generate correct
bitmaps itself (uninit_bg, online resize) it wouldn't be a bad idea IMHO.
The 64-bit descriptor still has some reserved space in it...

On a related note, I'd like to "reserve" the 2 __u32 fields in the 32-bit
group descriptor for inode and block bitmap checksums (at least some
comments to that effect).

> Probably what we should do is have a new 64-bit version of
> ext2fs_super_and_bgd_loc() fill in a data structure which contains all
> of the calculated information, instead of in a series of pointers
> passed into the function, and then create a new function which given a
> block number and the said data structure, returns a boolean true/false
> value if the block is part of the metadata.

Yes, that seems reasonable.

> > A second function would take the above block numbers (possibly in the
> > form of a modified group descriptor) and return a populated block bitmap.
> 
> Yes, possibly; this will only be used by e2fsck and resize2fs, but
> it's probably worth factoring out the code.

Ideally mke2fs would be restructured to also use this, for consistency,
instead of the current implementation where it "allocates" the blocks
from the available blocks in the bitmap.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

