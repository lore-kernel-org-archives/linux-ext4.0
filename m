From: Jan Kara <jack@suse.cz>
Subject: Re: 64bit inode number and dynamic inode table for ext4
Date: Wed, 28 Mar 2007 15:15:08 +0200
Message-ID: <20070328131508.GH14935@atrey.karlin.mff.cuni.cz>
References: <4601EF95.6020006@linux.vnet.ibm.com> <1174585546.16068.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39139 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXC1NPJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Mar 2007 09:15:09 -0400
Content-Disposition: inline
In-Reply-To: <1174585546.16068.50.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Wed, 2007-03-21 at 19:53 -0700, Avantika Mathur wrote:
> > Ext4 Developer Interlock Call: 03/21/2007 Meeting Minutes
> Here is the basic idea about the dynamic inode table:
> 
> In default 4k filesystem block size, a inode table block could store 4
> 265  bytes inode structures(4*265 = 4k). To avoid inode table blocks
                              ^^^^^^^^^^ so k=265? ;)

> fragmentation, we could allocate a cluster of contigous blocks for inode
> tables at run time, for every say, 64 inodes or 8 blocks 16*8=64 inodes.
> 
> To efficiently allocate and deallocate inode structures, we could link
> all free/used inode structures within the block group and store the
> first free/used inode number in the block group descriptor. 
  So you aren't expecting to shrink space allocated to inode, are you?

> There are some safety concern with dynamic inode table allocation in the
> case of block group corruption.  This could be addressed by checksuming
> the block group descriptor.
  But will it help you in finding those lost inodes once the descriptor
is corrupted? I guess it would make more sence to checksum each inode
separately. Then in case of corruption you could at least search through
all blocks (I know this is desperate ;) and find inodes by verifying
whether the inode checksum is correct. If it is, you have found an inode
block with a high probability (especially if a checksum for most of the
inodes in the block is correct). Another option would be to compute some
more robust checksum for the whole inode block...

> With dynamical inode table, the block to store the inode structure is
> not at fixed location anymore. One idea to efficiently map the inode
> number to the block store the corresponding inode structure is encoding
> the block number into the inode number directly. This implies to use 64
> bit inode number. The low 4-5 bit of the inode number stores the offset
> bits within the inode table block, and the rest of 59 bits is enough to
> store the 48 bit block number, or 32 bit block group number + relative
> block number within the group:
> 
> 63               47               31          20             4      0
> ----------------|-----------------------------|--------------|------|
> |               | 32bit group #               |   15 bit     | 5bit |
> |               |                             |   blk #      |offset|
> ----------------|-----------------------------|--------------|------|
> 
> The bigger concern is possible inode number collision if we choose 64
> bit inode number.  Although today linux kernel VFS layer is fixed to
> handle 64 bit inode number, applications might still using 32 bit stat()
> to access inode numbers could break.  It is unclear how common this case
> is, and whether by now the application is fixed to use the 64 bit stat64
> ().  
> 
> One solution is avoid generate inode number >2**32 on 32 bit platform.
> Since ext4 only could address 16TB fs on 32 bit arch, the max of group
> number is 2**17 (2**17 * 2**15 blocks = 2**32 blocks = 16TB(on 4k blk)),
> if we could force that inode table blocks could only be allocated at the
> first 2**10 blocks within a block group, like this:
> 
> 63               47               31               15          4      0
> ----------------|----------------|------------------|---------|------|
> |               | High 15 bit    |low 17bit grp #   |10 bit   | 5bit |
> |               | grp #          |                  |blk #    |offset|
> ----------------|----------------|------------------|---------|------|
> 
> 
> Then on 32 bit platform, the inode number is always <2**32. So even if
> inode number on fs is 64 bit, since it's high 32 bit is always 0, user
> application using stat() will get unique inode number.
  I think that by the time this gets to production I would expect
all the apps to be converted. And if they are not, then they deserve to be
screwed...

> On 64 bit plat format, there should not be collision issue for 64 bit
> applications. For 32 bit application running on 64 bit platform,
> hopefully they are fixed by now. or we could force the inode table block
> allocated at the first 16TB of fs, since anyway we need meta block group
> to support >256TB fs, and that already makes the inode structure apart
> from the data blocks.
> 
> 
> > 	- Andreas is concerned about inode relocation, it would take a
> > 	lot of effort; because references to the inode would have to be
> > 	updated.  
> 
> I am not clear about this concern. Andreas, are you worried about online
> defrag? I thought online defrag only transfer the extent maps from the
> temp inode to the original inode, we do not transfer inode number and
> structure.
  Eventually, it would be nice to relocate inodes too (especially if we
have the possibility to store the inode anywhere on disk). Currently,
online inode relocation is quite hard as that means changing
inode numbers and thus updating directory entries...
  But I'm not sure that the easier inode relocation is worth the additional
burden of translating inode numbers to disk location (which has to be
performed on every inode read). On the other hand the extent tree (or
simple radix tree - I'm not sure what would be better in case of inodes)
would not have to be too deep so maybe it won't be that bad.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
