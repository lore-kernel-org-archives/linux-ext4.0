From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] New inode allocation for FLEX_BG meta-data groups.
Date: Fri, 11 Jan 2008 14:46:58 -0700
Message-ID: <20080111214658.GS3351@webber.adilger.int>
References: <20080111112818.0cdeadbd@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:35722 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761099AbYAKVrC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jan 2008 16:47:02 -0500
Content-Disposition: inline
In-Reply-To: <20080111112818.0cdeadbd@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 11, 2008  11:28 -0600, Jose R. Santos wrote:
> @@ -127,6 +127,8 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
>  		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
>  	}
>  
> +	if (sbi->s_log_groups_per_flex)
> +		return free_blocks;
>  	return free_blocks - sbi->s_itb_per_group - 2;

To be honest, I think this is a wart in ext4_init_block_bitmap() that
it returns the number of free blocks in the group.  That value should
really be set at mke2fs or e2fsck time, and if the last group is marked
BLOCK_UNINIT it gets the free blocks count wrong because it always starts
with EXT4_BLOCKS_PER_GROUP().

The above patch may also be incorrect since there may be inode tables or
bitmaps in the above group even in the case of FLEX_BG filesystems.

> +#define free_block_ratio 10
> +
> +static int find_group_flex(struct super_block *sb, struct inode *parent, ext4_group_t *best_group)
> +{
> +	n_fbg_groups = (sbi->s_groups_count + flex_size - 1) / flex_size;

Can be a shift?

I would suggest doing some kind of testing to see how well this allocation
policy is working.  We don't want to force all allocations contiguously at
the start of the filesystem, or we end up with FAT...

> +static int ext4_fill_flex_info(struct super_block *sb)
> +{
> +	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;

Hmm, I guess no le*_to_cpu() because this is 8 bits?

> +
> +	flex_group_count = (sbi->s_groups_count + groups_per_flex - 1) /
> +		groups_per_flex;
> +	sbi->s_flex_groups = kmalloc(flex_group_count *
> +				     sizeof(struct flex_groups), GFP_KERNEL);
> +	if (sbi->s_flex_groups == NULL) {
> +		printk(KERN_ERR "EXT4-fs: not enough memory\n");

This should report "not enough memory for N flex groups" or something.

> @@ -2105,6 +2154,13 @@ static int ext4_fill_super (struct super_block *sb,
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> +		if (!ext4_fill_flex_info(sb)) {
> +			printk(KERN_ERR
> +			       "EXT4-fs: unable to initialize flex_bg meta info!\n");
> +			goto failed_mount2;

Should this be considered a fatal error, or could sbi->s_log_groups_per_flex
just be set to 0 and the filesystem be used as-is (maybe with sub-optimal
allocations or something)?  Otherwise this renders the filesystem unusable.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
