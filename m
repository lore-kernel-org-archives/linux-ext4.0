From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] Flex_BG ialloc awareness.
Date: Mon, 3 Dec 2007 13:42:47 -0700
Message-ID: <20071203204247.GL3604@webber.adilger.int>
References: <20071203130539.52e096a0@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:38198 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXLCUmt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2007 15:42:49 -0500
Content-Disposition: inline
In-Reply-To: <20071203130539.52e096a0@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 03, 2007  13:05 -0600, Jose R. Santos wrote:
> @@ -600,6 +600,7 @@ void ext4_free_blocks_sb(handle_t *handle, struct super_block *sb,
>  	ext4_grpblk_t group_freed;
> +	ext4_group_t meta_group;

Please do not call these meta_groups.  This already means something very
specific (i.e. desc_per_block groups) and using it for FLEX_BG is confusing.
One possibly desirable relation is if the FLEX_BG count is some integer or
power-of-two multiple of the metabg count.  That would allow the FLEX_BG
code to share the same in-memory group struct as the mballoc code and save
on some memory overhead.

> +			meta_group = ext4_meta_group(sbi, block_group);
> +			spin_lock(&sbi->s_meta_groups[meta_group].meta_group_lock);
> +			sbi->s_meta_groups[meta_group].free_inodes++;
> +			if (is_directory)
> +				sbi->s_meta_groups[meta_group].num_dirs--;
> +			spin_unlock(&sbi->s_meta_groups[meta_group].meta_group_lock);

This can be as many as hundreds or thousands of spin locks.  Why not use
the same hashed locking code as the group descriptors themselves?

		spin_lock(sb_bgl_lock(sbi, meta_group));
		spin_unlock(sb_bgl_lock(sbi, meta_group));

This scales with the number of CPUs and chance of contention is very low.

> +int find_group_meta(struct super_block *sb, struct inode *parent)
> +{
> +	ext4_group_t parent_mgroup = parent_group / sbi->s_groups_per_meta;

This could use ext4_meta_group(sbi, parent_group)?

> +static inline ext4_group_t ext4_meta_group(struct ext4_sb_info *sbi,
> +					     ext4_group_t block_group)
> +{
> +	return block_group/sbi->s_groups_per_meta;
> +}

It would be preferable to limit s_groups_per_meta to be a power-of-two
so that this can become a shift instead of a divide.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
