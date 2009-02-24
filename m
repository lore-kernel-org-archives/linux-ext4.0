From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH, RFC] ext4: New inode/block allocation algorithms for
	flex_bg filesystems
Date: Tue, 24 Feb 2009 14:29:31 +0530
Message-ID: <20090224085931.GA25657@skywalker>
References: <20090218154310.GH3600@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50671 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbZBXJAE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 04:00:04 -0500
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1O8xvOe013942
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 19:59:57 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n1O90EX5483456
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 20:00:14 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1O8xuw5017458
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 19:59:56 +1100
Content-Disposition: inline
In-Reply-To: <20090218154310.GH3600@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  4 files changed, 186 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/ext4/ext4_i.h b/fs/ext4/ext4_i.h
> index 2d516c0..4ce2187 100644
> --- a/fs/ext4/ext4_i.h
> +++ b/fs/ext4/ext4_i.h
> @@ -122,6 +122,9 @@ struct ext4_inode_info {
>  	struct list_head i_prealloc_list;
>  	spinlock_t i_prealloc_lock;
> 
> +	/* ialloc */
> +	ext4_group_t	i_last_alloc_group;
> +
>  	/* allocation reservation info for delalloc */
>  	unsigned int i_reserved_data_blocks;
>  	unsigned int i_reserved_meta_blocks;
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e2eab19..0aeb8c2 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -152,6 +152,8 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
>  	ext4_fsblk_t bg_start;
>  	ext4_fsblk_t last_block;
>  	ext4_grpblk_t colour;
> +	ext4_group_t block_group;
> +	int flex_size = ext4_flex_bg_size(EXT4_SB(inode->i_sb));
>  	int depth;
> 
>  	if (path) {
> @@ -170,10 +172,23 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
>  	}
> 
>  	/* OK. use inode's group */
> -	bg_start = (ei->i_block_group * EXT4_BLOCKS_PER_GROUP(inode->i_sb)) +
> +	block_group = ei->i_block_group;
> +	if (flex_size >= 4) {
> +		block_group &= ~(flex_size-1);
> +		if (S_ISREG(inode->i_mode))
> +			block_group++;
> +	}


Can you explain why we select 4 here ?


Also add a comment explaining directory/symlink block allocation goes to
first group of flex_bg and regular files goes to second group and which
type of workload that would help ? You have the comment in commit message. 


> +	bg_start = (block_group * EXT4_BLOCKS_PER_GROUP(inode->i_sb)) +
>  		le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_first_data_block);
>  	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;
> 
> +	/* 
> +	 * If we are doing delayed allocation, we don't need take
> +	 * colour into account.
> +	 */
> +	if (test_opt(inode->i_sb, DELALLOC))
> +		return bg_start;
> +

Again why we don't want to look at colour for delayed allocation ?


>  	if (bg_start + EXT4_BLOCKS_PER_GROUP(inode->i_sb) <= last_block)
>  		colour = (current->pid % 16) *
>  			(EXT4_BLOCKS_PER_GROUP(inode->i_sb) / 16);
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 21080ab..212e5be 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -409,6 +409,42 @@ out:
>  }
> 
>  /*
> + * Helper function for Orlov's allocator; returns critical information 
> + * for a particular block group or flex_bg
> + */
> +struct orlov_stats {
> +	__u32 free_inodes;
> +	__u32 free_blocks;
> +	__u32 used_dirs;  
> +};
> +
> +void get_orlov_stats(struct super_block *sb, ext4_group_t g, 
> +		       int flex_size, struct orlov_stats *stats)
> +{
> +	struct ext4_group_desc *desc;
> +	ext4_group_t		ngroups = EXT4_SB(sb)->s_groups_count;
> +	int			i;
> +
> +	stats->free_inodes = 0;
> +	stats->free_blocks = 0;
> +	stats->used_dirs = 0;
> +
> +	g *= flex_size;


Can you add a comment to the function saying g can be flex group number
or the actual group number depending on flex_size ?. Without that
comment the above operation can be confusing.

> +
> +	for (i = 0; i < flex_size; i++) {
> +		if (g >= ngroups)
> +			break;
> +		desc = ext4_get_group_desc(sb, g++, NULL);
> +		if (!desc)
> +			continue;
> +
> +		stats->free_inodes += ext4_free_inodes_count(sb, desc);
> +		stats->free_blocks += ext4_free_blks_count(sb, desc);
> +		stats->used_dirs += ext4_used_dirs_count(sb, desc);
> +	}
> +}
> +
> +/*
>   * Orlov's allocator for directories.
>   *
>   * We always try to spread first-level directories.
> @@ -423,7 +459,6 @@ out:
>   * it has too many directories already (max_dirs) or
>   * it has too few free inodes left (min_inodes) or
>   * it has too few free blocks left (min_blocks) or
> - * it's already running too large debt (max_debt).
>   * Parent's group is preferred, if it doesn't satisfy these
>   * conditions we search cyclically through the rest. If none
>   * of the groups look good we just look for a group with more
> @@ -437,7 +472,7 @@ out:
>  #define BLOCK_COST 256

You can also remove further description about debt and INODE_COST and
BLOCK_COST



> 
>  static int find_group_orlov(struct super_block *sb, struct inode *parent,
> -				ext4_group_t *group)
> +			    ext4_group_t *group, int mode)
>  {
>  	ext4_group_t parent_group = EXT4_I(parent)->i_block_group;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> @@ -446,12 +481,21 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
>  	int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
>  	unsigned int freei, avefreei;
>  	ext4_fsblk_t freeb, avefreeb;
> -	ext4_fsblk_t blocks_per_dir;
>  	unsigned int ndirs;
> -	int max_debt, max_dirs, min_inodes;
> +	int max_dirs, min_inodes;
>  	ext4_grpblk_t min_blocks;
> -	ext4_group_t i;
> +	ext4_group_t i, grp, g;
>  	struct ext4_group_desc *desc;
> +	struct orlov_stats stats;
> +	int flex_size = ext4_flex_bg_size(sbi);
> +
> +	if (flex_size < 4)
> +		flex_size = 1;
> +	else {
> +		ngroups = (ngroups + flex_size - 1) >>
> +			sbi->s_log_groups_per_flex;
> +		parent_group >>= sbi->s_log_groups_per_flex;
> +	}
> 
>  	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
>  	avefreei = freei / ngroups;
> @@ -460,71 +504,85 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
>  	do_div(avefreeb, ngroups);
>  	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
> 
> -	if ((parent == sb->s_root->d_inode) ||
> -	    (EXT4_I(parent)->i_flags & EXT4_TOPDIR_FL)) {
> +	if (S_ISDIR(mode) &&
> +	    ((parent == sb->s_root->d_inode) ||
> +	     (EXT4_I(parent)->i_flags & EXT4_TOPDIR_FL))) {
>  		int best_ndir = inodes_per_group;
> -		ext4_group_t grp;
>  		int ret = -1;
> 
>  		get_random_bytes(&grp, sizeof(grp));
>  		parent_group = (unsigned)grp % ngroups;
>  		for (i = 0; i < ngroups; i++) {
> -			grp = (parent_group + i) % ngroups;
> -			desc = ext4_get_group_desc(sb, grp, NULL);
> -			if (!desc || !ext4_free_inodes_count(sb, desc))
> +			g = (parent_group + i) % ngroups;
> +			get_orlov_stats(sb, g, flex_size, &stats);
> +			if (!stats.free_inodes)
>  				continue;
> -			if (ext4_used_dirs_count(sb, desc) >= best_ndir)
> +			if (stats.used_dirs >= best_ndir)
>  				continue;
> -			if (ext4_free_inodes_count(sb, desc) < avefreei)
> +			if (stats.free_inodes < avefreei)
>  				continue;
> -			if (ext4_free_blks_count(sb, desc) < avefreeb)
> +			if (stats.free_blocks < avefreeb)
>  				continue;
> -			*group = grp;
> +			grp = g;
>  			ret = 0;
> -			best_ndir = ext4_used_dirs_count(sb, desc);
> +			best_ndir = stats.used_dirs;
> +		}
> +		if (ret)
> +			goto fallback;
> +	found_flex_bg:
> +		if (flex_size == 1) {
> +			*group = grp;
> +			return 0;
> +		}
> +
> +		grp *= flex_size;
> +		for (i = 1; i < flex_size; i++) {

Why we start  with i = 1 ?


> +			if (grp+i >= sbi->s_groups_count)
> +				break;
> +			desc = ext4_get_group_desc(sb, grp+i, NULL);
> +			if (desc && ext4_free_inodes_count(sb, desc)) {


Can you add a comment saying that we just  pick the first group with
free inode because the goal block for rest of the block allocation
of the file/directory looks at the flex block group number with flex_bg. (more
details on ext4_ext_find_goal)


> +				*group = grp+i;
> +				return 0;
> +			}
> +		}
> +		desc = ext4_get_group_desc(sb, grp, NULL);
> +		if (desc && ext4_free_inodes_count(sb, desc)) {
> +			*group = grp;
> +			return 0;
>  		}
> -		if (ret == 0)
> -			return ret;
>  		goto fallback;
>  	}
> 
> -	blocks_per_dir = ext4_blocks_count(es) - freeb;
> -	do_div(blocks_per_dir, ndirs);
> -
>  	max_dirs = ndirs / ngroups + inodes_per_group / 16;
> -	min_inodes = avefreei - inodes_per_group / 4;
> -	min_blocks = avefreeb - EXT4_BLOCKS_PER_GROUP(sb) / 4;
> -
> -	max_debt = EXT4_BLOCKS_PER_GROUP(sb);
> -	max_debt /= max_t(int, blocks_per_dir, BLOCK_COST);
> -	if (max_debt * INODE_COST > inodes_per_group)
> -		max_debt = inodes_per_group / INODE_COST;
> -	if (max_debt > 255)
> -		max_debt = 255;
> -	if (max_debt == 0)
> -		max_debt = 1;
> +	min_inodes = avefreei - inodes_per_group*flex_size / 4;
> +	if (min_inodes < 1)
> +		min_inodes = 1;
> +	min_blocks = avefreeb - EXT4_BLOCKS_PER_GROUP(sb)*flex_size / 4;
> 
>  	for (i = 0; i < ngroups; i++) {
> -		*group = (parent_group + i) % ngroups;
> -		desc = ext4_get_group_desc(sb, *group, NULL);
> -		if (!desc || !ext4_free_inodes_count(sb, desc))
> +		grp = (parent_group + i) % ngroups;
> +		get_orlov_stats(sb, grp, flex_size, &stats);
> +		if (stats.used_dirs >= max_dirs)
>  			continue;
> -		if (ext4_used_dirs_count(sb, desc) >= max_dirs)
> +		if (stats.free_inodes < min_inodes)
>  			continue;
> -		if (ext4_free_inodes_count(sb, desc) < min_inodes)
> +		if (stats.free_blocks < min_blocks)
>  			continue;
> -		if (ext4_free_blks_count(sb, desc) < min_blocks)
> -			continue;
> -		return 0;
> +		goto found_flex_bg;
>  	}
> 
>  fallback:
> +	ngroups = sbi->s_groups_count;
> +	avefreei = freei / ngroups;
> +	parent_group = EXT4_I(parent)->i_block_group;
>  	for (i = 0; i < ngroups; i++) {
> -		*group = (parent_group + i) % ngroups;
> -		desc = ext4_get_group_desc(sb, *group, NULL);
> +		grp = (parent_group + i) % ngroups;
> +		desc = ext4_get_group_desc(sb, grp, NULL);
>  		if (desc && ext4_free_inodes_count(sb, desc) &&
> -			ext4_free_inodes_count(sb, desc) >= avefreei)
> +		    ext4_free_inodes_count(sb, desc) >= avefreei) {
> +			*group = grp;
>  			return 0;
> +		}
>  	}
> 
>  	if (avefreei) {
> @@ -540,12 +598,54 @@ fallback:
>  }
> 
>  static int find_group_other(struct super_block *sb, struct inode *parent,
> -				ext4_group_t *group)
> +			    ext4_group_t *group, int mode)
>  {
>  	ext4_group_t parent_group = EXT4_I(parent)->i_block_group;
>  	ext4_group_t ngroups = EXT4_SB(sb)->s_groups_count;
>  	struct ext4_group_desc *desc;
> -	ext4_group_t i;
> +	ext4_group_t i, last;
> +	int flex_size = ext4_flex_bg_size(EXT4_SB(sb));
> +
> +	/*
> +	 * If we are doing flex_bg style allocation, try to put
> +	 * special inodes in the first block group; start files and
> +	 * directories at the 2nd block group in the flex_bg.
> +	 */

Why ? Can you explain whether this placing helps any specific work load
? or something where you have observed that this placement helps ?  

> +	if (flex_size >= 4) {
> +		int ret, retry = 0;
> +
> +	try_again:
> +		i = (parent_group & ~(flex_size-1));
> +		last = i+flex_size;
> +		if (last > ngroups)
> +			last = ngroups;
> +		if (S_ISDIR(mode) || S_ISREG(mode))
> +			i++;
> +		while (i < last) {
> +			desc = ext4_get_group_desc(sb, i, NULL);
> +			if (desc && ext4_free_inodes_count(sb, desc)) {
> +				*group = i;
> +				return 0;
> +			}
> +			i++;
> +		}
> +		if (!retry && EXT4_I(parent)->i_last_alloc_group != ~0) {
> +			retry = 1;
> +			parent_group = EXT4_I(parent)->i_last_alloc_group;
> +			goto try_again;
> +		}
> +		/*
> +		 * If this didn't work, use the Orlov search
> +		 * algorithm; we pass in the mode to avoid the subdir
> +		 * of topdir algorithms.  If successful, save the
> +		 * group that we used so that future allocations in
> +		 * that directory are stable.
> +		 */
> +		ret = find_group_orlov(sb, parent, &parent_group, mode);
> +		if (ret == 0)
> +			EXT4_I(parent)->i_last_alloc_group = parent_group;
> +		return ret;
> +	}
> 
>  	/*
>  	 * Try to place the inode in its parent directory
> @@ -713,10 +813,10 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
>  	sbi = EXT4_SB(sb);
>  	es = sbi->s_es;
> 
> -	if (sbi->s_log_groups_per_flex) {
> +	if (sbi->s_log_groups_per_flex && test_opt(sb, OLDALLOC)) {
>  		ret2 = find_group_flex(sb, dir, &group);
>  		if (ret2 == -1) {
> -			ret2 = find_group_other(sb, dir, &group);
> +			ret2 = find_group_other(sb, dir, &group, mode);
>  			if (ret2 == 0)
>  				printk(KERN_NOTICE "ext4: find_group_flex "
>  				       "failed, fallback succeeded dir %lu\n",
> @@ -729,9 +829,9 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
>  		if (test_opt(sb, OLDALLOC))
>  			ret2 = find_group_dir(sb, dir, &group);
>  		else
> -			ret2 = find_group_orlov(sb, dir, &group);
> +			ret2 = find_group_orlov(sb, dir, &group, mode);
>  	} else
> -		ret2 = find_group_other(sb, dir, &group);
> +		ret2 = find_group_other(sb, dir, &group, mode);
> 
>  got_group:
>  	err = -ENOSPC;
> @@ -890,6 +990,7 @@ got:
>  	ei->i_file_acl = 0;
>  	ei->i_dtime = 0;
>  	ei->i_block_group = group;
> +	ei->i_last_alloc_group = ~0;
> 
>  	ext4_set_inode_flags(inode);
>  	if (IS_DIRSYNC(inode))
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cbd2ca9..12f1374 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -459,6 +459,8 @@ static ext4_fsblk_t ext4_find_near(struct inode *inode, Indirect *ind)
>  	ext4_fsblk_t bg_start;
>  	ext4_fsblk_t last_block;
>  	ext4_grpblk_t colour;
> +	ext4_group_t block_group;
> +	int flex_size = ext4_flex_bg_size(EXT4_SB(inode->i_sb));
> 
>  	/* Try to find previous block */
>  	for (p = ind->p - 1; p >= start; p--) {
> @@ -474,9 +476,22 @@ static ext4_fsblk_t ext4_find_near(struct inode *inode, Indirect *ind)
>  	 * It is going to be referred to from the inode itself? OK, just put it
>  	 * into the same cylinder group then.
>  	 */
> -	bg_start = ext4_group_first_block_no(inode->i_sb, ei->i_block_group);
> +	block_group = ei->i_block_group;
> +	if (flex_size >= 4) {
> +		block_group &= ~(flex_size-1);
> +		if (S_ISREG(inode->i_mode))
> +			block_group++;
> +	}
> +	bg_start = ext4_group_first_block_no(inode->i_sb, block_group);
>  	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;
> 
> +	/* 
> +	 * If we are doing delayed allocation, we don't need take
> +	 * colour into account.
> +	 */
> +	if (test_opt(inode->i_sb, DELALLOC))
> +		return bg_start;
> +
>  	if (bg_start + EXT4_BLOCKS_PER_GROUP(inode->i_sb) <= last_block)
>  		colour = (current->pid % 16) *
>  			(EXT4_BLOCKS_PER_GROUP(inode->i_sb) / 16);
> @@ -4250,6 +4265,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  	ei->i_disksize = inode->i_size;
>  	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
>  	ei->i_block_group = iloc.block_group;
> +	ei->i_last_alloc_group = ~0;
>  	/*
>  	 * NOTE! The in-memory inode i_data array is in little-endian order
>  	 * even on big-endian machines: we do NOT byteswap the block numbers!
> -- 

-aneesh
