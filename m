From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation
 for FLEX_BG
Date: Wed, 23 Apr 2008 16:05:18 -0500
Message-ID: <20080423160518.5c7fad2e@gara>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu>
	<1208868379-17580-2-git-send-email-tytso@mit.edu>
	<1208868379-17580-3-git-send-email-tytso@mit.edu>
	<20080423203955.GH2775@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55688 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYDWVFo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2008 17:05:44 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3NL5faj000816
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 17:05:41 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3NL5fbu249404
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 17:05:41 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3NL5UHD028213
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 17:05:31 -0400
In-Reply-To: <20080423203955.GH2775@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 23 Apr 2008 14:39:55 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Apr 22, 2008  08:46 -0400, Theodore Ts'o wrote:
> > Change the way we allocate bitmaps and inode tables if the FLEX_BG
> > feature is used at mke2fs time.  It places calculates a new offset for
> > bitmaps and inode table base on the number of groups that the user
> > wishes to pack together using the new "-G" option.  Creating a
> > filesystem with 64 block groups in a flex group can be done by:
> > 
> > mke2fs -j -I 256 -O flex_bg -G 32 /dev/sdX
> 
> Presumably you mean "-G 64" based on your description of 64 groups/flex_bg?

Thanks for catching.
 
> > @@ -66,6 +137,22 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
> > +		if (flexbg_size) {
> > +			dgrp_t gr = ext2fs_group_of_blk(fs, new_blk);
> > +			fs->group_desc[gr].bg_free_blocks_count--;
> > +			fs->super->s_free_blocks_count--;
> > +			fs->group_desc[gr].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
> > +			ext2fs_group_desc_csum_set(fs, gr);
> > +		}
> 
> It makes total sense to me that the BG_BLOCK_UNINIT flag would not be set
> on a group that does not have the default bitmap layouts, so I agree with
> this change.  I might suggest that we add a new flag BG_BLOCK_EMPTY or
> similar (which is really part of the FLEXBG feature so it doesn't affect
> the existing uninit_groups code) that indicates that the block bitmap
> contains NO allocated blocks, so that the kernel can know immediately
> when reconstructing the bitmap that there are no bitmaps or itable in
> that group (i.e. the bitmap is all zero).

I originally had a similar idea but was vetoed because there was no
kernel user on the flag.  The flag that I used was set if the block
group had meta-data as opposed to just being empty since there are still
block groups out there that can have no meta-data but still have bgd or
backup super blocks.  Would BG_BLOCK_EMPTY mean no bitmaps/inode tables
or does it imply completely empty block group?

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-JRS
