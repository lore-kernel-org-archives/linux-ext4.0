From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsprogs: New bitmap and inode table allocation for
	FLEX_BG
Date: Fri, 08 Feb 2008 00:11:16 -0500
Message-ID: <20080208051116.GB3120@webber.adilger.int>
References: <20080207110905.7886d170@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54239 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYBHFLe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2008 00:11:34 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m185BXHZ012954
	for <linux-ext4@vger.kernel.org>; Thu, 7 Feb 2008 21:11:33 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVW00801MAM7L00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 07 Feb 2008 21:11:33 -0800 (PST)
In-reply-to: <20080207110905.7886d170@gara>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 07, 2008  11:09 -0600, Jose R. Santos wrote:
> +blk_t ext2fs_flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
> +			   ext2fs_block_bitmap bmap, int offset, int size)
> +{

Can you add a comment on the intent of this function.  By the name it seems
to be calculating some offset relative to the flex group, but that doesn't
convey anything about searching for free blocks???

> +	/*
> +	 * Dont do a long search if the previous block
> +	 * search is still valid.
> +	 */

What condition here makse the previous search still valid?

> +	if (start_blk && group % flexbg_size) {
> +		if (size > flexbg_size)
> +			elem_size = fs->inode_blocks_per_group;
> +		else
> +			elem_size = 1;
> +		if (ext2fs_test_block_bitmap_range(bmap, start_blk + elem_size,
> +						   size))
> +			return start_blk + elem_size;
> +	}
> +
> +	start_blk = ext2fs_group_first_block(fs, flexbg_size * flexbg);
> +	last_grp = (group + (flexbg_size - (group % flexbg_size) - 1));

This is a confusing calculation...  Is it trying to find the last group
in the flex group that "group" is part of?  I.e. round "group" to the
end of the flex group?  Since flexbg_size is a power-of-two value, you
could just do "last_grp = group | (flexbg_size - 1)"?

> +	last_blk = ext2fs_group_last_block(fs, last_grp);
> +	if (last_grp > fs->group_desc_count)
> +		last_grp = fs->group_desc_count;

Doesn't it make more sense to calculate "last_blk" AFTER limiting
"last_grp" to the actual number of groups in the filesystem?

> +	/* Find the first available block */
> +	if (ext2fs_get_free_blocks(fs, start_blk, last_blk, 1, bmap,
> +				   &first_free))
> +		return first_free;
> +
> +	if (ext2fs_get_free_blocks(fs, first_free + offset, last_blk, size,
> +				   bmap, &first_free))
> +		return first_free;

I don't quite understand this either?  The first search is looking for a
single free block between "start_blk" and "last_blk", while the second
search is looking for "size" free blocks between "first_free + offset"
and "last_blk".  What is the reason to do the second search after doing
the first one, or alternately just doing the second one directly?

Should both of these calls actually be saving the error return value and
returning that to a caller (returning first_free via a pointer arg like
ext2fs_get_free_blocks() does)?

>  errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
>  				      ext2fs_block_bitmap bmap)
>  {
>  	if (!bmap)
>  		bmap = fs->block_map;
> +
> +	if (EXT2_HAS_INCOMPAT_FEATURE (fs->super,
> +				       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {

No space between ..._FEATURE and "(".

> +		flexbg_size = 1 << fs->super->s_log_groups_per_flex;
> +		rem_grps = flexbg_size - (group % flexbg_size);
> +		last_grp = group + rem_grps - 1;

Could this be written as:

		last_grp = group | (flexbg_size - 1);
		rem_grps = last_grp - group;

I'm also trying to see if you have an off-by-one error in your version?
Consider the case of group = 5, flexbg_size = 4.  That gives us with my calc:

		last_grp = 5 | (4 - 1) = 7;
		rem_grps = 7 - 5 = 2;

This makes sense, since group 5 is in the second flexbg [4,7], and there
are 2 groups remaining after group 5 in that flexbg.

> @@ -56,6 +120,15 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs,
>  	} else
>  		start_blk = group_blk;
>  
> +	if (flexbg_size) {
> +		int prev_block = 0;
> +		if (group && fs->group_desc[group-1].bg_block_bitmap)
> +			prev_block = fs->group_desc[group-1].bg_block_bitmap;
> +		start_blk = ext2fs_flexbg_offset(fs, group, prev_block, bmap,
> +						 0, rem_grps);
> +		last_blk = ext2fs_group_last_block(fs, last_grp);
> +	}

This is presumably trying to allocate the block bitmap for "group" to be
after the block bitmap for "group - 1" (allocated in an earlier call).

> +		if (group && fs->group_desc[group-1].bg_inode_bitmap)
> +			prev_block = fs->group_desc[group-1].bg_inode_bitmap;
> +		start_blk = ext2fs_flexbg_offset(fs, group, prev_block, bmap,
> +						 flexbg_size, rem_grps);
> +		last_blk = ext2fs_group_last_block(fs, last_grp);
>  	}

This is allocating the inode bitmap in the same manner.  Would it make more
sense to change the mke2fs code to allocate all of the block bitmaps first
(well, after the sb+gdt backups), then all of the inode bitmaps, and finally
all of the inode tables?

>  #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
>  #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
> +#define EXT2_BG_FLEX_METADATA	0x0004 /* FLEX_BG block group contains meta-data */

Hrm, I thought I had reserved that value in the uninit_groups patch?
+#define EXT3_BG_INODE_ZEROED   0x0004  /* On-disk itable initialized to zero */

The kernel and e2fsck can use that to determine if the inode table was
zeroed out at mke2fs time (i.e. formatted with LAZY_BG or not).  Then
the kernel can zero out the entire inode table and set INODE_ZEROED lazily
some time after mount, instead of mke2fs doing it at mke2fs time sucking
up all of the node's RAM and making it very slow.

This is still needed at some point to avoid the problem of e2fsck trying
to salvage ancient inodes if the group descriptor is corrupted for some
reason and the inode high watermark is lost.

Not implemented yet... but intended to be done by a helper thread started
at mount time to do GDT/bitmap/itable checksum validation, create the
mballoc buddy buffers, prefetch metadata, etc.

> @@ -96,7 +96,7 @@ static void usage(void)
>  {
>  	fprintf(stderr, _("Usage: %s [-c|-t|-l filename] [-b block-size] "
>  	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] "
> -	"[-j] [-J journal-options]\n"
> +	"[-j] [-J journal-options] [-G meta group size]\n"
>  	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
>  	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
>  	"[-M last-mounted-directory]\n\t[-O feature[,...]] "

This also needs an update to the mke2fs.8.in man page.

> +	if(flex_bg_size) {
> +		fs_param.s_log_groups_per_flex = int_log2(flex_bg_size);
> +	}

Whitespace, braces:

	if (flex_bg_size)
		fs_param.s_log_groups_per_flex = int_log2(flex_bg_size);


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
