From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/2] ext4: Spot-check block group sub-table locations
Date: Sun, 29 Sep 2013 14:44:01 +0800
Message-ID: <20130929064400.GB10285@gmail.com>
References: <20130928001349.25857.76724.stgit@birch.djwong.org>
 <20130928001404.25857.43349.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:50940 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3I2GmX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Sep 2013 02:42:23 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb4so4219880pbc.36
        for <linux-ext4@vger.kernel.org>; Sat, 28 Sep 2013 23:42:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130928001404.25857.43349.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 27, 2013 at 05:14:04PM -0700, Darrick J. Wong wrote:
> Perform a quick sanity check of bitmap and inode table block numbers when
> loading them, and if there's something suspicious, mark the block group
> corrupt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

One comment below.  Otherwise the patch looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

> ---
>  fs/ext4/balloc.c |    7 +++++++
>  fs/ext4/ext4.h   |    2 ++
>  fs/ext4/ialloc.c |    6 ++++++
>  fs/ext4/inode.c  |    9 +++++++++
>  fs/ext4/super.c  |   21 +++++++++++++++++++++
>  5 files changed, 45 insertions(+)
[...]
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 2c2e6cb..d22248e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2049,6 +2049,27 @@ void ext4_group_desc_csum_set(struct super_block *sb, __u32 block_group,
>  	gdp->bg_checksum = ext4_group_desc_csum(EXT4_SB(sb), block_group, gdp);
>  }
>  
> +/* returns 1 if the location of a blockgroup data item seems sane */
> +int ext4_is_sane_bgdata_location(struct super_block *sb, ext4_group_t grp,
> +				 ext4_fsblk_t blk)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	ext4_fsblk_t first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
> +	ext4_fsblk_t last_block;
> +
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> +		last_block = ext4_blocks_count(sbi->s_es) - 1;
> +	else {
> +		first_block += grp * sbi->s_blocks_per_group;
> +		last_block = first_block + (EXT4_BLOCKS_PER_GROUP(sb) - 1);
> +	}
> +
> +	if (last_block >= ext4_blocks_count(sbi->s_es))
> +		last_block = ext4_blocks_count(sbi->s_es) - 1;
> +
> +	return blk >= first_block && blk <= last_block;
> +}
> +
>  /* Called at mount-time, super-block is locked */
>  static int ext4_check_descriptors(struct super_block *sb,
>  				  ext4_group_t *first_not_zeroed)

FWIW, I notice that in ext4_check_descriptors() we also check the
location of bitmap.  So maybe we could use ext4_is_sane_bgdata_location
in that function.

                                                - Zheng
