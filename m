From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] mke2fs: prevent creation of unmountable ext4 with
 large flex_bg count
Date: Thu, 12 Jun 2014 16:50:19 -0700
Message-ID: <20140612235019.GB9743@birch.djwong.org>
References: <28989C0C9F1C0A428470D967B5FCED372A7EA3@BPXM22GP.gisp.nec.co.jp>
 <6A410081-0492-4378-BA66-07AFA7C0DEAF@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33327 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFLXu3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2014 19:50:29 -0400
Content-Disposition: inline
In-Reply-To: <6A410081-0492-4378-BA66-07AFA7C0DEAF@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2014 at 01:01:29PM -0600, Andreas Dilger wrote:
> 
> On Jun 11, 2014, at 2:38 AM, Akira Fujita <a-fujita@rs.jp.nec.com> wrote:
> 
> > In mke2fs command, if flex_bg count is too large to filesystem blocks count,
> > unmountable ext4 which has the out of filesystem block offset is created (Case1).
> > Moreover this large flex_bg count causes an unintentional metadata layout
> > (bmap-imap-itable-bmap-imap-itable .. in block group) (Case2).
> > 
> > To fix these issues and keep healthy flex_bg layout, disallow creating ext4
> > with obviously large flex_bg count to filesystem blocks count.
> 
> Patch looks good to me.
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> 
> This also reminds me of my previous flex_bg patch:
> [PATCH][RFC] mke2fs: handle flex_bg collision with backup descriptors
> http://permalink.gmane.org/gmane.comp.file-systems.ext4/42298
> 
> which fixes the "bmap-imap-itable-bmap-imap-itable" problem when a large
> flex_bg size is used.  Sadly, there were no comments on that patch.

I had wondered if you were planning to address the FIXMEs in the patch, but
then forgot to ever follow up... :/

--D

> 
> Cheers, Andreas
> 
> > Steps to reproduce:
> > (Case1)
> > 1.
> > # mke2fs -t ext4 -b 4096 -O ^resize_inode -G $((2**20)) DEV 2130483
> > 
> > 2.
> > # mount -t ext4 DEV MP
> > mount: wrong fs type, bad option, bad superblock on /dev/sdb4,
> >       missing codepage or helper program, or other error
> >       In some cases useful info is found in syslog - try
> >       dmesg | tail  or so
> > 
> > 3.
> > # dumpe2fs DEV
> > <snip>
> > Block count:              2130483
> > <snip>
> > Flex block group size:    1048576 
> > <snip>
> > Group 65: (Blocks 2129920-2130482) [INODE_UNINIT]
> >  Checksum 0x4cb3, unused inodes 8080
> >  Block bitmap at 67 (bg #0 + 67), Inode bitmap at 1048643 (bg #32 + 67)
> >  Inode table at 2129979-2130483 (+59)              <---- 2130483 is out of FS!
> >  65535 free blocks, 8080 free inodes, 0 directories, 8080 unused inodes
> >  Free blocks: 
> >  Free inodes: 525201-533280
> > 
> > (Case2)
> > 1.
> > # mke2fs -t ext4 -G 2147483648 DEV 3145728
> > 
> > 2.
> > # debugfs -R stats DEV
> > <snip>
> > Block count:              786432
> > <snip>
> > Flex block group size:    2147483648
> > <snip>
> > Group  0: block bitmap at 193, inode bitmap at 194, inode table at 195    <-- 
> >           20233 free blocks, 8181 free inodes, 2 used directories, 8181 unused inodes
> >           [Checksum 0xa597]
> > Group  1: block bitmap at 707, inode bitmap at 708, inode table at 709    <--
> >           32575 free blocks, 8192 free inodes, 0 used directories, 8192 unused inodes
> >           [Inode not init, Block not init, Checksum 0x196f]
> > Group  2: block bitmap at 1221, inode bitmap at 1222, inode table at 1223 <--
> >           32768 free blocks, 8192 free inodes, 0 used directories, 8192 unused inodes
> >           [Inode not init, Block not init, Checksum 0x856f]
> > <snip>
> > 
> > Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> > ---
> > lib/ext2fs/initialize.c |   24 ++++++++++++++++++++++++
> > 1 file changed, 24 insertions(+)
> > diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> > index 75fbf8e..34753d0 100644
> > --- a/lib/ext2fs/initialize.c
> > +++ b/lib/ext2fs/initialize.c
> > @@ -91,8 +91,10 @@ errcode_t ext2fs_initialize(const char *name, int flags,
> > 	unsigned int	rem;
> > 	unsigned int	overhead = 0;
> > 	unsigned int	ipg;
> > +	unsigned int	flexbg_size;
> > 	dgrp_t		i;
> > 	blk64_t		free_blocks;
> > +	blk64_t		flexbg_overhead;
> > 	blk_t		numblocks;
> > 	int		rsv_gdt;
> > 	int		csum_flag;
> > @@ -419,6 +421,28 @@ ipg_retry:
> > 	}
> > 
> > 	/*
> > +	 * Calculate the flex_bg related metadata blocks count.
> > +	 * It includes the boot block, the super block,
> > +	 * the block group descriptors, the reserved gdt blocks,
> > +	 * the block bitmaps, the inode bitmaps and the inode tables.
> > +	 * This is a simple check, so that the backup superblock and
> > +	 * other feature related blocks are not considered.
> > +	 */
> > +	flexbg_size = 1 << fs->super->s_log_groups_per_flex;
> > +	flexbg_overhead = super->s_first_data_block + 1 +
> > +		fs->desc_blocks + super->s_reserved_gdt_blocks +
> > +		(__u64)flexbg_size * (2 + fs->inode_blocks_per_group);
> > +
> > +	/*
> > +	 * Disallow creating ext4 which breaks flex_bg metadata layout
> > +	 * obviously.
> > +	 */
> > +	if (flexbg_overhead > ext2fs_blocks_count(fs->super)) {
> > +		retval = EXT2_ET_INVALID_ARGUMENT;
> > +		goto cleanup;
> > +	}
> > +
> > +	/*
> > 	 * At this point we know how big the filesystem will be.  So
> > 	 * we can do any and all allocations that depend on the block
> > 	 * count.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


