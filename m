From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/2] ext4: Don't count free clusters from a corrupt block
 group
Date: Sun, 29 Sep 2013 14:20:45 +0800
Message-ID: <20130929062045.GA10285@gmail.com>
References: <20130928001349.25857.76724.stgit@birch.djwong.org>
 <20130928001357.25857.94425.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40073 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3I2GTH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Sep 2013 02:19:07 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so4207727pbb.6
        for <linux-ext4@vger.kernel.org>; Sat, 28 Sep 2013 23:19:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130928001357.25857.94425.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 27, 2013 at 05:13:57PM -0700, Darrick J. Wong wrote:
> A bg that's been flagged "corrupt" by definition has no free blocks, so that
> the allocator won't be tempted to use the damaged bg.  Therefore, we shouldn't
> count the clusters in the damaged group when calculating free counts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  fs/ext4/balloc.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index dc5d572..6ea7b14 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -640,6 +640,7 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
>  	struct ext4_group_desc *gdp;
>  	ext4_group_t i;
>  	ext4_group_t ngroups = ext4_get_groups_count(sb);
> +	struct ext4_group_info *grp;
>  #ifdef EXT4FS_DEBUG
>  	struct ext4_super_block *es;
>  	ext4_fsblk_t bitmap_count;
> @@ -655,7 +656,11 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
>  		gdp = ext4_get_group_desc(sb, i, NULL);
>  		if (!gdp)
>  			continue;
> -		desc_count += ext4_free_group_clusters(sb, gdp);
> +		grp = NULL;
> +		if (EXT4_SB(sb)->s_group_info)
> +			grp = ext4_get_group_info(sb, i);
> +		if (!grp || !EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
> +			desc_count += ext4_free_group_clusters(sb, gdp);
>  		brelse(bitmap_bh);
>  		bitmap_bh = ext4_read_block_bitmap(sb, i);
>  		if (bitmap_bh == NULL)
> @@ -679,7 +684,11 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
>  		gdp = ext4_get_group_desc(sb, i, NULL);
>  		if (!gdp)
>  			continue;
> -		desc_count += ext4_free_group_clusters(sb, gdp);
> +		grp = NULL;
> +		if (EXT4_SB(sb)->s_group_info)
> +			grp = ext4_get_group_info(sb, i);
> +		if (!grp || !EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
> +			desc_count += ext4_free_group_clusters(sb, gdp);
>  	}
>  
>  	return desc_count;
> 
