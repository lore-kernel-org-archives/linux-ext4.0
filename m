From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] [PATCH] Flex_BG ialloc awareness V2.
Date: Fri, 7 Dec 2007 03:14:28 -0700
Message-ID: <20071207101428.GE3214@webber.adilger.int>
References: <20071206161045.1054bbe7@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:38628 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbXLGKOe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Dec 2007 05:14:34 -0500
Content-Disposition: inline
In-Reply-To: <20071206161045.1054bbe7@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 06, 2007  16:10 -0600, Jose R. Santos wrote:
> @@ -600,6 +600,7 @@ void ext4_free_blocks_sb(handle_t *handle, struct super_block *sb,
>  	struct ext4_sb_info *sbi;
>  	int err = 0, ret;
>  	ext4_grpblk_t group_freed;
> +	ext4_group_t flex_group;
>  
>  	*pdquot_freed_blocks = 0;
>  	sbi = EXT4_SB(sb);
> @@ -745,6 +746,14 @@ do_more:
>  	spin_unlock(sb_bgl_lock(sbi, block_group));
>  	percpu_counter_add(&sbi->s_freeblocks_counter, count);
>  
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
> +	    sbi->s_groups_per_flex_shift) {
> +		flex_group = ext4_flex_group(sbi, block_group);
> +		spin_lock(sb_bgl_lock(sbi, flex_group));
> +		sbi->s_flex_groups[flex_group].free_blocks += count;
> +		spin_unlock(sb_bgl_lock(sbi, flex_group));
> +	}

In general, I prefer to keep variables in as local a scope as possible.
In this case, flex_group could be declared inside the "if (EXT4_HAS_INCOMPAT"
check.

> @@ -1610,6 +1619,7 @@ ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
>  	unsigned short windowsz = 0;
>  	ext4_group_t ngroups;
>  	unsigned long num = *count;
> +	ext4_group_t flex_group;
>  
>  	*errp = -ENOSPC;
>  	sb = inode->i_sb;
> @@ -1815,6 +1825,14 @@ allocated:
>  	spin_unlock(sb_bgl_lock(sbi, group_no));
>  	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
>  
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
> +	    sbi->s_groups_per_flex_shift) {
> +		flex_group = ext4_flex_group(sbi, group_no);
> +		spin_lock(sb_bgl_lock(sbi, flex_group));
> +		sbi->s_flex_groups[flex_group].free_blocks -= num;
> +		spin_unlock(sb_bgl_lock(sbi, flex_group));
> +	}

Same as above.

> @@ -158,6 +158,7 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
>  	struct ext4_super_block * es;
>  	struct ext4_sb_info *sbi;
>  	int fatal = 0, err;
> +	ext4_group_t flex_group;
>  
>  	if (atomic_read(&inode->i_count) > 1) {
>  		printk ("ext4_free_inode: inode has count=%d\n",
> @@ -235,6 +236,13 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
>  			if (is_directory)
>  				percpu_counter_dec(&sbi->s_dirs_counter);
>  
> +			if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
> +			    sbi->s_groups_per_flex_shift) {
> +				flex_group = ext4_flex_group(sbi, block_group);
> +				spin_lock(sb_bgl_lock(sbi, flex_group));
> +				sbi->s_flex_groups[flex_group].free_inodes++;
> +				spin_unlock(sb_bgl_lock(sbi, flex_group));
> +			}

Same as above... 

> +#define free_block_ratio 10
> +
> +int find_group_flex(struct super_block *sb, struct inode *parent)
> +{
> +	n_fbg_groups = (sbi->s_groups_count + flex_size - 1) / flex_size;
> +	best_flex = parent_fbg_group;
> +
> +find_close_to_parent:
> +	flex_freeb_ratio = flex_group[best_flex].free_blocks*100/blocks_per_flex;

There is no particular reason that this ratio needs to be "*100", it could
just as easily be a fraction of 256 and make the multiply into a shift.
The free_block_ratio would be 26 in that case.

> +	for (i = 0; i < n_fbg_groups; i++) {
> +		if (i == parent_fbg_group || i == parent_fbg_group - 1)
> +			continue;

It seems this scans flex groups the way we used to scan groups?

> +found_flexbg:
> +	for (i = best_flex * flex_size; i < ngroups &&
> +		     i < (best_flex + 1) * flex_size; i++) {

And now that we've found a suitable flex group, we need to find which
block group therein has some free inodes...

> +static int ext4_fill_flex_info(struct super_block *sb)
> +{

It still seems desirable to have a single per-group array instead of

> @@ -622,7 +631,9 @@ struct ext4_super_block {
>  	__le16  s_mmp_interval;         /* # seconds to wait in MMP checking */
>  	__le64  s_mmp_block;            /* Block for multi-mount protection */
>  	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
> -	__u32   s_reserved[163];        /* Padding to the end of the block */
> +	__le16	s_flex_bg_size;		/* FLEX_BG group size */

Shouldn't this be "s_flex_bg_bits"?

> +{
> +	return block_group >> sbi->s_groups_per_flex_shift;
> +}
> +
> +static inline unsigned int ext4_flex_bg_size(struct ext4_sb_info *sbi)
> +{
> +	return 1 << sbi->s_groups_per_flex_shift;
> +}
> +
>  #define ext4_std_error(sb, errno)				\
>  do {								\
>  	if ((errno))						\

> diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
> --- a/lib/ext2fs/alloc_tables.c
> +++ b/lib/ext2fs/alloc_tables.c
> +	if (EXT2_HAS_INCOMPAT_FEATURE (fs->super, 
> +				       EXT4_FEATURE_INCOMPAT_FLEX_BG)) 
> +		ext2fs_allocate_flex_groups(fs);
> +	
> +	else {
> +		for (i = 0; i < fs->group_desc_count; i++) {
> +			retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
> +			if (retval)
> +				return retval;
> +		}
>  	}

My preference would be to have "if (EXT2_HAS_INCOMPAT...) { ... } else {"
(i.e. add { } for the first part) since there are { } on the second part,
and it is just easier to read.

> @@ -1045,6 +1046,19 @@ static void PRS(int argc, char *argv[])
> +			if ((flex_bg_size & (flex_bg_size-1)) != 0) {
> +				com_err(program_name, 0,
> +					_("Flex_BG size must be a power of 2"));
> +				exit(1);

If flex_bg_size is a power of two then there isn't any need to store anything
except __u8 s_flex_bg_bits in the superblock.

> @@ -1444,6 +1458,10 @@ static void PRS(int argc, char *argv[])
> +	if(flex_bg_size) {
> +		fs_param.s_flex_bg_size = ext2fs_swab16(flex_bg_size);
> +	}

Space between if and (, and no need for braces for a single line body.

It would also be nice to get a m_flexbg test case along with this patch
that (at minimum) creates a filesystem with flexbg enabled, and then
runs e2fsck on it.  This was broken for the lazy_bg feature for a long
time, so it makes sense to add a test to verify each new feature has
some basic functionality.  If the f_random_corruption test is in the
git tree, it would be good to add the flex_bg option to the list of
possible feature combinations to test.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
