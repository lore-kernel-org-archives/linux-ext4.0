From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 14/23] ext4: teach ext4_statfs() to deal with clusters if bigalloc is enabled
Date: Wed, 6 Jul 2011 16:58:13 -0600
Message-ID: <4C67AF4F-BA01-4396-B78F-E13264EEE617@dilger.ca>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu> <1309970166-11770-15-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:10528 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1GFW6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2011 18:58:14 -0400
In-Reply-To: <1309970166-11770-15-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-06, at 10:35 AM, Theodore Ts'o wrote:
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> fs/ext4/super.c |   37 ++++++++++++++++++++++++-------------
> 1 files changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a803d65..7a4d54e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4529,16 +4529,34 @@ restore_opts:
> 	return err;
> }
> 
> +/*
> + * Note: calculating the overhead so we can be compatible with
> + * historical BSD practice is quite difficult in the face of
> + * clusters/bigalloc.  This is because multiple metadata blocks from
> + * different block group can end up in the same allocation cluster.
> + * Calculating the exact overhead in the face of clustered allocation
> + * requires either O(all block bitmaps) in memory or O(number of block
> + * groups**2) in time.  We will still calculate the superblock for
> + * older file systems --- and if we come across with a bigalloc file
> + * system with zero in s_overhead_clusters the estimate will be close to
> + * correct especially for very large cluster sizes --- but for newer
> + * file systems, it's better to calculate this figure once at mkfs
> + * time, and store it in the superblock.  If the superblock value is
> + * present (even for non-bigalloc file systems), we will use it.
> + */
> static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
> {
> 	struct super_block *sb = dentry->d_sb;
> 	struct ext4_sb_info *sbi = EXT4_SB(sb);
> 	struct ext4_super_block *es = sbi->s_es;
> +	struct ext4_group_desc *gdp;
> 	u64 fsid;
> 	s64 bfree;
> 
> 	if (test_opt(sb, MINIX_DF)) {

Should we change this check to unlikely()?

> 		sbi->s_overhead_last = 0;
> +	} else if (es->s_overhead_clusters) {
> +		sbi->s_overhead_last = le32_to_cpu(es->s_overhead_clusters);
> 	} else if (sbi->s_blocks_last != ext4_blocks_count(es)) {
> 		ext4_group_t i, ngroups = ext4_get_groups_count(sb);
> 		ext4_fsblk_t overhead = 0;
> @@ -4553,24 +4571,16 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
> 		 * All of the blocks before first_data_block are
> 		 * overhead
> 		 */
> -		overhead = le32_to_cpu(es->s_first_data_block);
> +		overhead = EXT4_B2C(sbi, le32_to_cpu(es->s_first_data_block));
> 
> 		/*
> -		 * Add the overhead attributed to the superblock and
> -		 * block group descriptors.  If the sparse superblocks
> -		 * feature is turned on, then not all groups have this.
> +		 * Add the overhead found in each block group
> 		 */
> 		for (i = 0; i < ngroups; i++) {
> -			overhead += ext4_bg_has_super(sb, i) +
> -				ext4_bg_num_gdb(sb, i);
> +			gdp = ext4_get_group_desc(sb, i, NULL);
> +			overhead += ext4_num_overhead_clusters(sb, i, gdp);
> 			cond_resched();
> 		}
> -
> -		/*
> -		 * Every block group has an inode bitmap, a block
> -		 * bitmap, and an inode table.
> -		 */
> -		overhead += ngroups * (2 + sbi->s_itb_per_group);
> 		sbi->s_overhead_last = overhead;
> 		smp_wmb();
> 		sbi->s_blocks_last = ext4_blocks_count(es);
> @@ -4578,7 +4588,8 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
> 
> 	buf->f_type = EXT4_SUPER_MAGIC;
> 	buf->f_bsize = sb->s_blocksize;
> -	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
> +	buf->f_blocks = (ext4_blocks_count(es) -
> +			 EXT4_C2B(sbi, sbi->s_overhead_last));
> 	bfree = percpu_counter_sum_positive(&sbi->s_freeclusters_counter) -
> 		percpu_counter_sum_positive(&sbi->s_dirtyclusters_counter);
> 	/* prevent underflow in case that few free space is available */
> -- 
> 1.7.4.1.22.gec8e1.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





