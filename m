From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: 64bit inode number and dynamic inode table for ext4
Date: Thu, 29 Mar 2007 10:08:08 -0800
Message-ID: <1175191689.3783.28.camel@dyn9047017103.beaverton.ibm.com>
References: <4601EF95.6020006@linux.vnet.ibm.com>
	 <1174585546.16068.50.camel@localhost.localdomain>
	 <20070328131508.GH14935@atrey.karlin.mff.cuni.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:42630 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030599AbXC2SIM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Mar 2007 14:08:12 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2TI8BYp013161
	for <linux-ext4@vger.kernel.org>; Thu, 29 Mar 2007 14:08:11 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2TI8Bk3120776
	for <linux-ext4@vger.kernel.org>; Thu, 29 Mar 2007 12:08:11 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2TI8Ald009472
	for <linux-ext4@vger.kernel.org>; Thu, 29 Mar 2007 12:08:11 -0600
In-Reply-To: <20070328131508.GH14935@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-03-28 at 15:15 +0200, Jan Kara wrote: 
> > On Wed, 2007-03-21 at 19:53 -0700, Avantika Mathur wrote:
> > > Ext4 Developer Interlock Call: 03/21/2007 Meeting Minutes
> > Here is the basic idea about the dynamic inode table:
> > 
> > In default 4k filesystem block size, a inode table block could store 4
> > 265  bytes inode structures(4*265 = 4k). To avoid inode table blocks
>                               ^^^^^^^^^^ so k=265? ;)
> 
sorry, it should be 16 inodes in a 4k block, 16*256 = 4k;) 
> > fragmentation, we could allocate a cluster of contigous blocks for inode
> > tables at run time, for every say, 64 inodes or 8 blocks 16*8=64 inodes.
> > 
> > To efficiently allocate and deallocate inode structures, we could link
> > all free/used inode structures within the block group and store the
> > first free/used inode number in the block group descriptor. 
>   So you aren't expecting to shrink space allocated to inode, are you?
> 
In theory we could shrink space allocated to inodes, but I am not sure
if this worth the effort.

> > There are some safety concern with dynamic inode table allocation in the
> > case of block group corruption.  This could be addressed by checksuming
> > the block group descriptor.
>   But will it help you in finding those lost inodes once the descriptor
> is corrupted? I guess it would make more sence to checksum each inode
> separately. Then in case of corruption you could at least search through
> all blocks (I know this is desperate ;) and find inodes by verifying
> whether the inode checksum is correct. If it is, you have found an inode
> block with a high probability (especially if a checksum for most of the
> inodes in the block is correct). Another option would be to compute some
> more robust checksum for the whole inode block...
> 

If the block group descriptor is corrupted (with checksuming), we could
locate majority of inodes in the group by scanning the directory
entries, the inode number directly point to the inode table blocks.

Yeah, adding checksum for the whole inode block(s) is what I am
thinking.  Andreas suggested adding magic number to the inode table
block(s) (a cluster of blocks for inode). So in the case the block group
descriptor is corrupted , we could scan the block group and easily
locate the inode block(s).

If a cluster of inode blocks is 8 blocks, we could user one 256 bytes to
store the magic number and checksum. We could also
store the bitmap of this 127 inodes to indicating whether they are free
or not. This is an alternative way(vs. the free/used inode linked
list) to locate inode within the tables to do allocation/deallocation.
Shrinking the freed inode blocks also becomes easier, I assume.
This allows us to do inode allocation in parellal. Then we could store
the address of the previous or next chunk of inode tables in this
cluster header for additional safety protection. The first and last
cluster address(first block number of the chuck) are stored in the block
group descriptor.

> > With dynamical inode table, the block to store the inode structure
> is
> > not at fixed location anymore. One idea to efficiently map the inode
> > number to the block store the corresponding inode structure is encoding
> > the block number into the inode number directly. This implies to use 64
> > bit inode number. The low 4-5 bit of the inode number stores the offset
> > bits within the inode table block, and the rest of 59 bits is enough to
> > store the 48 bit block number, or 32 bit block group number + relative
> > block number within the group:
> > 
> > 63               47               31          20             4      0
> > ----------------|-----------------------------|--------------|------|
> > |               | 32bit group #               |   15 bit     | 5bit |
> > |               |                             |   blk #      |offset|
> > ----------------|-----------------------------|--------------|------|
> > 
> > The bigger concern is possible inode number collision if we choose 64
> > bit inode number.  Although today linux kernel VFS layer is fixed to
> > handle 64 bit inode number, applications might still using 32 bit stat()
> > to access inode numbers could break.  It is unclear how common this case
> > is, and whether by now the application is fixed to use the 64 bit stat64
> > ().  
> > 
> > One solution is avoid generate inode number >2**32 on 32 bit platform.
> > Since ext4 only could address 16TB fs on 32 bit arch, the max of group
> > number is 2**17 (2**17 * 2**15 blocks = 2**32 blocks = 16TB(on 4k blk)),
> > if we could force that inode table blocks could only be allocated at the
> > first 2**10 blocks within a block group, like this:
> > 
> > 63               47               31               15          4      0
> > ----------------|----------------|------------------|---------|------|
> > |               | High 15 bit    |low 17bit grp #   |10 bit   | 5bit |
> > |               | grp #          |                  |blk #    |offset|
> > ----------------|----------------|------------------|---------|------|
> > 
> > 
> > Then on 32 bit platform, the inode number is always <2**32. So even if
> > inode number on fs is 64 bit, since it's high 32 bit is always 0, user
> > application using stat() will get unique inode number.
>   I think that by the time this gets to production I would expect
> all the apps to be converted. And if they are not, then they deserve to be
> screwed..
> 

This kind of compromise on 32 bit platform is not complexed, just a
different set of the micros to decode the inode number, based on 32 bit
archs or 64 bit archs. So the complexity is not a big deal here.

It's not very clear how many apps there will be impacted by the 32->64
bit inode number changes. The plan, per yesterday's ext4 interlock
meeting, is to add a mount option for ext3, and generate the in-kernel
64 bit inode number on the fly, then try ext3 with some commercial
backup tools or ls-al, tar, rsync etc on 32 bit platforms.


> > On 64 bit plat format, there should not be collision issue for 64 bit
> > applications. For 32 bit application running on 64 bit platform,
> > hopefully they are fixed by now. or we could force the inode table block
> > allocated at the first 16TB of fs, since anyway we need meta block group
> > to support >256TB fs, and that already makes the inode structure apart
> > from the data blocks.
> > 
> > 
> > > 	- Andreas is concerned about inode relocation, it would take a
> > > 	lot of effort; because references to the inode would have to be
> > > 	updated.  
> > 
> > I am not clear about this concern. Andreas, are you worried about online
> > defrag? I thought online defrag only transfer the extent maps from the
> > temp inode to the original inode, we do not transfer inode number and
> > structure.
>   Eventually, it would be nice to relocate inodes too (especially if we
> have the possibility to store the inode anywhere on disk). Currently,
> online inode relocation is quite hard as that means changing
> inode numbers and thus updating directory entries...
> 
>   But I'm not sure that the easier inode relocation is worth the additional
> burden of translating inode numbers to disk location (which has to be
> performed on every inode read).
> 
Andreas explained that to me in a separate email. Is inode relocation a
rare case or pretty common? I thought we need to do inode relocation
lookup only if the inode number mismatch what is stored on disk.

>  On the other hand the extent tree (or
> simple radix tree - I'm not sure what would be better in case of inodes)
> would not have to be too deep so maybe it won't be that bad.
> 
Probably. I assume you mean having a per block group inode table file ,
and use extent tree indirectly to lookup block number, given a inode
number.  We have to serialized the multiple lookups within least per
block group though.

The concern I think is mostly reliability. In this scheme, we need to
back up of the inode table file, in case the original inode table file
corrupted we will not lost the inodes for the entire block group.

Mingming
> 
> 								Honza
