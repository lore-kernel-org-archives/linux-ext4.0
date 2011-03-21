From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH, RFC 10/12] ext4: teach ext4_statfs() to deal with clusters
 if bigalloc is enabled
Date: Mon, 21 Mar 2011 21:17:30 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103212115360.3724@dhcp-27-109.brq.redhat.com>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu> <1300570117-24048-11-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab1CUURe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2011 16:17:34 -0400
In-Reply-To: <1300570117-24048-11-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 19 Mar 2011, Theodore Ts'o wrote:

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/super.c |   35 +++++++++++++++++++++++------------
>  1 files changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index f9b25cd..24964da 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4438,15 +4438,33 @@ restore_opts:
>  	return err;
>  }
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
> + * system with zero in s_overhead_blocks the estimate will be close to
> + * correct especially for very large cluster sizes --- but for newer
> + * file systems, it's better to calculate this figure once at mkfs
> + * time, and store it in the superblock.  If the superblock value is
> + * present (even for non-bigalloc file systems), we will use it.
> + */
>  static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
>  	struct super_block *sb = dentry->d_sb;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct ext4_super_block *es = sbi->s_es;
> +	struct ext4_group_desc *gdp;
>  	u64 fsid;
>  
>  	if (test_opt(sb, MINIX_DF)) {
>  		sbi->s_overhead_last = 0;
> +	} else if (es->s_overhead_blocks) {
> +		sbi->s_overhead_last = le32_to_cpu(es->s_overhead_blocks);
>  	} else if (sbi->s_blocks_last != ext4_blocks_count(es)) {
>  		ext4_group_t i, ngroups = ext4_get_groups_count(sb);
>  		ext4_fsblk_t overhead = 0;
> @@ -4461,24 +4479,16 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  		 * All of the blocks before first_data_block are
>  		 * overhead
>  		 */
> -		overhead = le32_to_cpu(es->s_first_data_block);
> +		overhead = EXT4_B2C(sbi, le32_to_cpu(es->s_first_data_block));
>  
>  		/*
> -		 * Add the overhead attributed to the superblock and
> -		 * block group descriptors.  If the sparse superblocks
> -		 * feature is turned on, then not all groups have this.
> +		 * Add the overhead found in each block group
>  		 */
>  		for (i = 0; i < ngroups; i++) {
> -			overhead += ext4_bg_has_super(sb, i) +
> -				ext4_bg_num_gdb(sb, i);
> +			gdp = ext4_get_group_desc(sb, i, NULL);
> +			overhead += ext4_num_overhead_clusters(sb, i, gdp);
>  			cond_resched();
>  		}
> -
> -		/*
> -		 * Every block group has an inode bitmap, a block
> -		 * bitmap, and an inode table.
> -		 */
> -		overhead += ngroups * (2 + sbi->s_itb_per_group);
>  		sbi->s_overhead_last = overhead;

overhead is in clusters units, but

>  		smp_wmb();
>  		sbi->s_blocks_last = ext4_blocks_count(es);
> @@ -4489,6 +4499,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;

here it seems to be treated as blocks if I am not missing something.

>  	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter) -
>  		       percpu_counter_sum_positive(&sbi->s_dirtyblocks_counter);
> +	buf->f_bfree = buf->f_bfree << sbi->s_cluster_bits;
>  	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
>  	if (buf->f_bfree < ext4_r_blocks_count(es))
>  		buf->f_bavail = 0;
> 
