From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] resize2fs: Fix support for the uninit_bg feature
Date: Tue, 17 Jun 2008 09:16:47 -0600
Message-ID: <20080617151647.GD3726@webber.adilger.int>
References: <1213682792-4878-1-git-send-email-tytso@mit.edu>
 <1213682792-4878-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44166 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbYFQPQv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 11:16:51 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5HFGobC016486
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 08:16:50 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2M00M014TXWV00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 17 Jun 2008 08:16:50 -0700 (PDT)
In-reply-to: <1213682792-4878-2-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 17, 2008  02:06 -0400, Theodore Ts'o wrote:
> @@ -1579,13 +1589,35 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
>  	/*
>  	 * First calculate the block statistics
>  	 */
> +	uninit = fs->group_desc[group].bg_flags & EXT2_BG_BLOCK_UNINIT;
> +	ext2fs_super_and_bgd_loc(fs, group, &super_blk, &old_desc_blk,
> +				 &new_desc_blk, 0);
> +	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
> +		old_desc_blocks = fs->super->s_first_meta_bg;
> +	else
> +		old_desc_blocks = fs->desc_blocks +
> +			fs->super->s_reserved_gdt_blocks;

I'm a bit confused by this.  It doesn't seem that you use old_desc_blocks
in the META_BG case?  I'm trying to figure out what "old_desc_blocks"
means in the META_BG case.


Also, the number of places where we have to figure out whick blocks
are in use for a particular group is growing quite large, and with the
interactions between various features (META_BG, SPARSE_SUPER, FLEX_BG,
RESIZE_INODE, etc) getting this right in all of these places is hard.
Places that need this, off the top of my head, include mk2fs, e2fsck,
resize2fs, kernel (online resize, uninit_bg), debugfs.

It would be very handy to have a single function that can figure out
the block layout for any group based on all of the features, and then
return the block numbers of the bitmaps, itable, sb, gdt (if present).
This would be like a more complex version of ext2fs_super_and_bgd_loc(),
but it also returns the number of gdt blocks (normal and reserved),
bitmaps, inode table, and itable blocks.

A group descriptor would almost be the right struct, but it doesn't
(yet?) include the GDT block count, itable block count, or a flag if
there is a superblock.  Adding these fields into the on-disk group_desc
struct wouldn't be a bad idea, then all the need to recalculate the
group layout in 10 places would disappear.

A second function would take the above block numbers (possibly in the
form of a modified group descriptor) and return a populated block bitmap.

>  	for (blk = fs->super->s_first_data_block;
>  	     blk < fs->super->s_blocks_count; blk++) {
> -		if (!ext2fs_fast_test_block_bitmap(fs->block_map, blk)) {
> +		if ((uninit &&
> +		     !((blk == super_blk) ||
> +		       ((old_desc_blk && old_desc_blocks &&
> +			 (blk >= old_desc_blk) &&
> +			 (blk < old_desc_blk + old_desc_blocks))) ||
> +		       ((new_desc_blk && (blk == new_desc_blk))) ||
> +		       (blk == fs->group_desc[group].bg_block_bitmap) ||
> +		       (blk == fs->group_desc[group].bg_inode_bitmap) ||
> +		       ((blk >= fs->group_desc[group].bg_inode_table &&
> +			 (blk < fs->group_desc[group].bg_inode_table
> +			  + fs->inode_blocks_per_group))))) ||
> +		    (!ext2fs_fast_test_block_bitmap(fs->block_map, blk))) {
>  			group_free++;
>  			total_free++;
>  		}

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

