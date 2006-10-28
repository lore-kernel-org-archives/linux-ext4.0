From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext3: bogus i_mode errors with 2.6.18.1
Date: Sat, 28 Oct 2006 22:24:54 +0800
Message-ID: <20061028142454.GA6182@schatzie.adilger.int>
References: <20061023144556.GY22487@skl-net.de> <20061023164416.GM3509@schatzie.adilger.int> <20061023200242.GA5015@schatzie.adilger.int> <20061024091449.GZ22487@skl-net.de> <20061024202716.GX3509@schatzie.adilger.int> <20061025094418.GA22487@skl-net.de> <20061026093613.GM3509@schatzie.adilger.int> <20061026160241.GB12843@skl-net.de> <20061026180133.GN3509@schatzie.adilger.int> <20061027153414.GA6446@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:62371 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1752074AbWJ1OZB
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Oct 2006 10:25:01 -0400
To: Andre Noll <maan@systemlinux.org>
Content-Disposition: inline
In-Reply-To: <20061027153414.GA6446@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 27, 2006  17:34 +0200, Andre Noll wrote:
> On 12:01, Andreas Dilger wrote:
> > Well, since we know at least one bit needs fixing and results in the block
> > being written to disk then setting the bits for all of the other metadata
> > blocks in this group has no extra IO cost (only a tiny amount of CPU).
> > Re-setting the bits if they are already set is not harmful.
> 
> I.e, something like
> 
>         int i;
>         ext3_fsblk_t bit;
>         unsigned long gdblocks = EXT3_SB(sb)->s_gdb_count;
> 
>         for (i = 0, bit = 1; i < gdblocks; i++, bit++)
>                 ext3_set_bit(bit, gdp_bh->b_data);
> 
> Is that correct?

Well, it needs to also handle backup superblock, bitmaps, inode table:

	if (ext3_bg_has_super())
		ext3_set_bit(0, gdp_bh->b_data);
	gdblocks = ext3_bg_num_gdb(sb, group);
	for (i = 0, bit = 1; i < gdblocks; i++, bit++)
		/* actually a bit more complex for INCOMPAT_META_BG fs */
		ext3_set_bit(i, gdp_bh->b_data);
	ext3_set_bit(gdp->bg_inode_bitmap % EXT3_BLOCKS_PER_GROUP(sb), ...);
	ext3_set_bit(gdp->bg_block_bitmap % EXT3_BLOCKS_PER_GROUP(sb), ...);
	for (i = 0, bit = gdp->bg_inode_table % EXT3_BLOCKS_PER_GROUP(sb);
	     i < EXT3_SB(sb)->s_itb_per_group; i++, bit++)
		ext3_set_bit(i, gdp_bh->b_data);
		
(or something close to this).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
