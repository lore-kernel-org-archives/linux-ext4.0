From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH, RFC] ext4: New inode/block allocation algorithms for
	flex_bg filesystems
Date: Fri, 27 Feb 2009 00:08:12 +0530
Message-ID: <20090226183812.GA21612@skywalker>
References: <20090218154310.GH3600@mini-me.lan> <20090226182156.GL7227@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52807 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZBZSin (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Feb 2009 13:38:43 -0500
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1QIceqB027081
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2009 05:38:40 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n1QIcwIM892960
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2009 05:38:58 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1QIcdLV020999
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2009 05:38:40 +1100
Content-Disposition: inline
In-Reply-To: <20090226182156.GL7227@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

....

>  static int find_group_orlov(struct super_block *sb, struct inode *parent,
> -				ext4_group_t *group)
> +			    ext4_group_t *group, int mode)
>  {
>  	ext4_group_t parent_group = EXT4_I(parent)->i_block_group;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> -	struct ext4_super_block *es = sbi->s_es;
>  	ext4_group_t ngroups = sbi->s_groups_count;
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
> +	if (flex_size > 1) {
> +		ngroups = (ngroups + flex_size - 1) >>
> +			sbi->s_log_groups_per_flex;
> +		parent_group >>= sbi->s_log_groups_per_flex;
> +	}
> 
>  	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
>  	avefreei = freei / ngroups;
> @@ -460,71 +496,97 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
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
> +		/*
> +		 * We pack inodes at the beginning of the flexgroup's
> +		 * inode tables.  Block allocation decisions will do
> +		 * something similar, although regular files will
> +		 * start at 2nd block group of the flexgroup.  See
> +		 * ext4_ext_find_goal() and ext4_find_near().
> +		 */
> +		grp *= flex_size;
> +		for (i = 0; i < flex_size; i++) {
> +			if (grp+i >= sbi->s_groups_count)
> +				break;
> +			desc = ext4_get_group_desc(sb, grp+i, NULL);
> +			if (desc && ext4_free_inodes_count(sb, desc)) {
> +				*group = grp+i;
> +				return 0;
> +			}
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
> +
> +	/*
> +	 * Start looking in the flex group where we last allocated an
> +	 * inode for this parent directory
> +	 */
> +	if (EXT4_I(parent)->i_last_alloc_group != ~0) {
> +		parent_group = EXT4_I(parent)->i_last_alloc_group;
> +		if (flex_size > 1)
> +			parent_group >>= sbi->s_log_groups_per_flex;
> +	}
> 
>  	for (i = 0; i < ngroups; i++) {
> -		*group = (parent_group + i) % ngroups;
> -		desc = ext4_get_group_desc(sb, *group, NULL);
> -		if (!desc || !ext4_free_inodes_count(sb, desc))
> -			continue;
> -		if (ext4_used_dirs_count(sb, desc) >= max_dirs)
> +		grp = (parent_group + i) % ngroups;
> +		get_orlov_stats(sb, grp, flex_size, &stats);
> +		if (stats.used_dirs >= max_dirs)
>  			continue;
> -		if (ext4_free_inodes_count(sb, desc) < min_inodes)
> +		if (stats.free_inodes < min_inodes)
>  			continue;
> -		if (ext4_free_blks_count(sb, desc) < min_blocks)
> +		if (stats.free_blocks < min_blocks)
>  			continue;
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
> @@ -540,12 +602,51 @@ fallback:
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
> +	 * Try to place the inode is the same flex group as its
> +	 * parent.  If we can't find space, use the Orlov algorithm to
> +	 * find another flex group, and store that information in the
> +	 * parent directory's inode information so that use that flex
> +	 * group for future allocations.
> +	 */
> +	if (flex_size > 1) {
> +		int retry = 0;
> +
> +	try_again:
> +		parent_group &= ~(flex_size-1);
> +		last = parent_group + flex_size;
> +		if (last > ngroups)
> +			last = ngroups;
> +		for  (i = parent_group; i < last; i++) {
> +			desc = ext4_get_group_desc(sb, i, NULL);
> +			if (desc && ext4_free_inodes_count(sb, desc)) {
> +				*group = i;
> +				return 0;
> +			}
> +		}
> +		if (!retry && EXT4_I(parent)->i_last_alloc_group != ~0) {
> +			retry = 1;
> +			parent_group = EXT4_I(parent)->i_last_alloc_group;
> +			goto try_again;
> +		}


For directories we try first with i_last_alloc_group and then with the
parent i_block_group. For file we are doing the other way round here.
Does it make sense to try with i_last_alloc_group first ?



> +		/*
> +		 * If this didn't work, use the Orlov search algorithm
> +		 * to find a new flex group; we pass in the mode to
> +		 * avoid the topdir algorithms.
> +		 */
> +		*group = parent_group + flex_size;
> +		if (*group > ngroups)
> +			*group = 0;
> +		return find_group_orlov(sb, parent, group, mode);
> +	}
> 
>  	/*

If you want you can add
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

-aneesh
