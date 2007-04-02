From: Jan Kara <jack@suse.cz>
Subject: Re: 64bit inode number and dynamic inode table for ext4
Date: Mon, 2 Apr 2007 14:45:43 +0200
Message-ID: <20070402124543.GH3728@duck.suse.cz>
References: <4601EF95.6020006@linux.vnet.ibm.com> <1174585546.16068.50.camel@localhost.localdomain> <20070328131508.GH14935@atrey.karlin.mff.cuni.cz> <1175191689.3783.28.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53793 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934013AbXDBMic (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2007 08:38:32 -0400
Content-Disposition: inline
In-Reply-To: <1175191689.3783.28.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 29-03-07 10:08:08, Mingming Cao wrote:
> > > To efficiently allocate and deallocate inode structures, we could link
> > > all free/used inode structures within the block group and store the
> > > first free/used inode number in the block group descriptor. 
> >   So you aren't expecting to shrink space allocated to inode, are you?
> > 
> In theory we could shrink space allocated to inodes, but I am not sure
> if this worth the effort.
  Yes, I agree...

> > > There are some safety concern with dynamic inode table allocation in the
> > > case of block group corruption.  This could be addressed by checksuming
> > > the block group descriptor.
> >   But will it help you in finding those lost inodes once the descriptor
> > is corrupted? I guess it would make more sence to checksum each inode
> > separately. Then in case of corruption you could at least search through
> > all blocks (I know this is desperate ;) and find inodes by verifying
> > whether the inode checksum is correct. If it is, you have found an inode
> > block with a high probability (especially if a checksum for most of the
> > inodes in the block is correct). Another option would be to compute some
> > more robust checksum for the whole inode block...
> > 
> 
> If the block group descriptor is corrupted (with checksuming), we could
> locate majority of inodes in the group by scanning the directory
> entries, the inode number directly point to the inode table blocks.
  Yes, you're right that works in case inode numbers are easily translated
into physical location on disk.

> Yeah, adding checksum for the whole inode block(s) is what I am
> thinking.  Andreas suggested adding magic number to the inode table
> block(s) (a cluster of blocks for inode). So in the case the block group
> descriptor is corrupted , we could scan the block group and easily
> locate the inode block(s).
> 
> If a cluster of inode blocks is 8 blocks, we could user one 256 bytes to
> store the magic number and checksum. We could also
  Storing the checksum for 8 inode blocks has two disadvantages:
1) You have to update the checksum for each inode write (i.e. writing one
inode block suddently means writing two disk blocks).
2) If it is really a checksum over all 8 blocks and not just 8 checksums
over single blocks, you have to have all 8 blocks in memory to be able to
compute the checksum.

> store the bitmap of this 127 inodes to indicating whether they are free
> or not. This is an alternative way(vs. the free/used inode linked
> list) to locate inode within the tables to do allocation/deallocation.
> Shrinking the freed inode blocks also becomes easier, I assume.
> This allows us to do inode allocation in parellal. Then we could store
> the address of the previous or next chunk of inode tables in this
> cluster header for additional safety protection. The first and last
> cluster address(first block number of the chuck) are stored in the block
> group descriptor.
  Yes, this looks like a good alternative.

<snip>
> > > > 	- Andreas is concerned about inode relocation, it would take a
> > > > 	lot of effort; because references to the inode would have to be
> > > > 	updated.  
> > > 
> > > I am not clear about this concern. Andreas, are you worried about online
> > > defrag? I thought online defrag only transfer the extent maps from the
> > > temp inode to the original inode, we do not transfer inode number and
> > > structure.
> >   Eventually, it would be nice to relocate inodes too (especially if we
> > have the possibility to store the inode anywhere on disk). Currently,
> > online inode relocation is quite hard as that means changing
> > inode numbers and thus updating directory entries...
> > 
> >   But I'm not sure that the easier inode relocation is worth the additional
> > burden of translating inode numbers to disk location (which has to be
> > performed on every inode read).
> > 
> Andreas explained that to me in a separate email. Is inode relocation a
> rare case or pretty common? I thought we need to do inode relocation
> lookup only if the inode number mismatch what is stored on disk.
  Inode relocation is useful for defragmentation and such beasts. So you
don't care much about the performance of a relocation as such. But after
you relocate the inode to some other place, you'd like it to behave as if
it was there since the beginning...

> >  On the other hand the extent tree (or
> > simple radix tree - I'm not sure what would be better in case of inodes)
> > would not have to be too deep so maybe it won't be that bad.
> > 
> Probably. I assume you mean having a per block group inode table file ,
> and use extent tree indirectly to lookup block number, given a inode
> number.  We have to serialized the multiple lookups within least per
> block group though.
  Yes, I meant such inode file. Why would we have to serialize lookups?
They can be perfectly parallel. The only thing you have to serialize are
modifications and those should be append-only anyway...

> The concern I think is mostly reliability. In this scheme, we need to
> back up of the inode table file, in case the original inode table file
> corrupted we will not lost the inodes for the entire block group.
  If you have checksums / magic numbers, you will be able to find blocks
belonging to the inode table file. If you also implement the idea with the
chunks of inode blocks (actually, it looks like a small inode table) with a
header, you can even store all the information you need for reconstruction
in the header...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
