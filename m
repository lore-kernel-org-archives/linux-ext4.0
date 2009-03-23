From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Track lifetime disk writes
Date: Mon, 23 Mar 2009 21:20:24 +0530
Message-ID: <20090323155024.GA27876@skywalker>
References: <E1LdHKi-0000Zm-Mv@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:49357 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZCWPuz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Mar 2009 11:50:55 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp08.au.ibm.com (8.13.1/8.13.1) with ESMTP id n2NFooiY010742
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2009 02:50:50 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2NFp7571032358
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2009 02:51:08 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2NFooYL024478
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2009 02:50:50 +1100
Content-Disposition: inline
In-Reply-To: <E1LdHKi-0000Zm-Mv@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 28, 2009 at 12:01:52AM -0500, Theodore Ts'o wrote:
> 
> Add a new superblock value which tracks the lifetime amount of writes
> to the filesystem.  This is useful in estimating the amount of wear on
> solid state drives (SSD's) caused by writes to the filesystem.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4.h    |    3 ++-
>  fs/ext4/ext4_sb.h |    4 ++++
>  fs/ext4/super.c   |    7 +++++++
>  3 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8599e37..f9a3bc3 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -685,7 +685,8 @@ struct ext4_super_block {
>  	__u8	s_log_groups_per_flex;  /* FLEX_BG group size */
>  	__u8	s_reserved_char_pad2;
>  	__le16  s_reserved_pad;
> -	__u32   s_reserved[162];        /* Padding to the end of the block */
> +	__le64	s_kbytes_written;	/* nr of lifetime kilobytes written */
> +	__u32   s_reserved[160];        /* Padding to the end of the block */
>  };
> 
>  #ifdef __KERNEL__
> diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
> index 4e4d9cc..50ab116 100644
> --- a/fs/ext4/ext4_sb.h
> +++ b/fs/ext4/ext4_sb.h
> @@ -142,6 +142,10 @@ struct ext4_sb_info {
>  	/* locality groups */
>  	struct ext4_locality_group *s_locality_groups;
> 
> +	/* for write statistics */
> +	unsigned long s_sectors_written_start;
> +	u64 s_kbytes_written;
> +
>  	unsigned int s_log_groups_per_flex;
>  	struct flex_groups *s_flex_groups;
>  };

Do we need this change ? We don't seems to be using it anywhere.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c69f04c..007aa0a 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2039,6 +2039,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	sbi->s_resgid = EXT4_DEF_RESGID;
>  	sbi->s_inode_readahead_blks = EXT4_DEF_INODE_READAHEAD_BLKS;
>  	sbi->s_sb_block = sb_block;
> +	sbi->s_sectors_written_start = part_stat_read(sb->s_bdev->bd_part,
> +						      sectors[1]);
> 
>  	unlock_kernel();
> 
> @@ -2535,6 +2537,7 @@ no_journal:
>  	}
> 
>  	ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY);
> +	sbi->s_kbytes_written = le64_to_cpu(es->s_kbytes_written);
> 
>  	/* determine the minimum size of new large inodes, if present */
>  	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
> @@ -2929,6 +2932,10 @@ static int ext4_commit_super(struct super_block *sb,
>  		set_buffer_uptodate(sbh);
>  	}
>  	es->s_wtime = cpu_to_le32(get_seconds());
> +	es->s_kbytes_written =
> +		cpu_to_le64(EXT4_SB(sb)->s_kbytes_written + 
> +			    ((part_stat_read(sb->s_bdev->bd_part, sectors[1]) -
> +			      EXT4_SB(sb)->s_sectors_written_start) >> 1));
>  	ext4_free_blocks_count_set(es, percpu_counter_sum_positive(
>  					&EXT4_SB(sb)->s_freeblocks_counter));
>  	es->s_free_inodes_count = cpu_to_le32(percpu_counter_sum_positive(

Can't we just do

es->s_kbytes_written = cpu_to_le64(le64_to_cpu(es->s_kbytes_written) + (part_stat_read(sb->s_bdev->bd_part, sectors[1]) >> 1))

During ext4_commit_super without even touching ext4_sb_info ? 

What is being tracked in s_sectors_written_start ?

-aneesh


