From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsprogs: New bitmap and inode table allocation for
	FLEX_BG
Date: Fri, 11 Jan 2008 14:01:04 -0700
Message-ID: <20080111210104.GR3351@webber.adilger.int>
References: <20080111112806.1bbd9f38@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:42980 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759065AbYAKVBG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jan 2008 16:01:06 -0500
Content-Disposition: inline
In-Reply-To: <20080111112806.1bbd9f38@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 11, 2008  11:28 -0600, Jose R. Santos wrote:
> +blk_t ext2fs_flexbg_offset(ext2_filsys fs, dgrp_t group, int flexbg_size, 
> +			   ext2fs_block_bitmap bmap, int offset, int size)

Could you please add some comments for what this function is trying to do?

> +	last_grp = (group + (flexbg_size - (group % flexbg_size) - 1));

Is this the same as:

	last_grp = group + (flexbg_size - 1) / flexbg_size * flexbg_size
	
(i.e. trying to round up to the next even multiple of flexbg_size)?

Didn't we decide to have flexbg_size be a power-of-two value, so we could
use shift and mask instead of divide and mod?  It's less of an issue because
group is only a 32-bit value, I guess.

> +	if (ext2fs_get_free_blocks(fs, start_blk, last_blk, 1, bmap, 
> +				   &first_free))
> +		return first_free;
> +	
> +	if (ext2fs_get_free_blocks(fs, first_free + offset, last_blk, size, 
> +				   bmap, &first_free))
> +		return first_free;
> +
> +	return first_free;
> +}
> +
>  errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
>  				      ext2fs_block_bitmap bmap)
>  {
>  	errcode_t	retval;
>  	blk_t		group_blk, start_blk, last_blk, new_blk, blk;
> -	int		j;
> +	dgrp_t		last_grp;
> +	int		j, rem_grps, flexbg_size = 0;
>  
>  	group_blk = ext2fs_group_first_block(fs, group);
>  	last_blk = ext2fs_group_last_block(fs, group);
>  
>  	if (!bmap)
>  		bmap = fs->block_map;
> +
> +	if (EXT2_HAS_INCOMPAT_FEATURE (fs->super,
> +				       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> +		flexbg_size = 1 << fs->super->s_log_groups_per_flex;
> +		rem_grps = flexbg_size - (group % flexbg_size);

Hmm, no point in doing "groups % flexbg_size" if we have
s_log_groups_per_flex.  Could do "groups & (flexbg_size - 1)" instead.

> @@ -101,7 +102,11 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
> +	if (flex_bg_size) {
> +		if ((group % flex_bg_size) == 0)
> +			numblocks -= 2 + fs->inode_blocks_per_group;

Ditto.

> @@ -1045,6 +1046,20 @@ static void PRS(int argc, char *argv[])
>  				exit(1);
>  			}
>  			break;
> +		case 'G':
> +			flex_bg_size = strtoul(optarg, &tmp, 0);
> +			if (*tmp) {
> +				com_err(program_name, 0,
> +					_("Illegal number for Flex_BG size"));
> +				exit(1);
> +			}
> +			if (flex_bg_size < 2 || 
> +			    (flex_bg_size & (flex_bg_size-1)) != 0) {
> +				com_err(program_name, 0,
> +					_("Flex_BG size must be a power of 2"));
> +				exit(1);
> +			}
> +			break;

We've been putting new options under "-E var=value"...  I don't know what
Ted's thoughs are on using new option letters, though this one might qualify.

> @@ -1444,6 +1459,16 @@ static void PRS(int argc, char *argv[])
>  		}
>  	}
>  
> +	if(flex_bg_size) {

Space after "if ".

> +		shift = 0;
> +		tmp = flex_bg_size;
> +		while ((tmp >>= 1UL) != 0UL)
> +			shift++;

There isn't a "log2" function?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
