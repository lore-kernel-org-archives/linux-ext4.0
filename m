From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/2] ext4: Don't count free clusters from a corrupt block
 group
Date: Fri, 27 Sep 2013 13:37:24 +0800
Message-ID: <20130927053723.GA23428@gmail.com>
References: <20130927000321.17889.68250.stgit@birch.djwong.org>
 <20130927000328.17889.30383.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34690 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3I0Ffw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Sep 2013 01:35:52 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so2111514pbb.27
        for <linux-ext4@vger.kernel.org>; Thu, 26 Sep 2013 22:35:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130927000328.17889.30383.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 26, 2013 at 05:03:28PM -0700, Darrick J. Wong wrote:
> A bg that's been flagged "corrupt" by definition has no free blocks, so that
> the allocator won't be tempted to use the damaged bg.  Therefore, we shouldn't
> count the clusters in the damaged group when calculating free counts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ext4/balloc.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index dc5d572..4390f9f 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -640,6 +640,7 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
>  	struct ext4_group_desc *gdp;
>  	ext4_group_t i;
>  	ext4_group_t ngroups = ext4_get_groups_count(sb);
> +	struct ext4_group_info *grp;
>  #ifdef EXT4FS_DEBUG

It seems that you forgot to add these code in this macro definition.

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index dc5d572..3ba2079 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -655,7 +655,11 @@ ext4_fsblk_t ext4_count_free_clusters(struct
super_block *sb)
                gdp = ext4_get_group_desc(sb, i, NULL);
                if (!gdp)
                        continue;
-               desc_count += ext4_free_group_clusters(sb, gdp);
+               grp = NULL;
+               if (EXT4_SB(sb)->s_group_info)
+                       grp = ext4_get_group_info(sb, i);
+               if (!grp || !EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
+                       desc_count += ext4_free_group_clusters(sb, gdp);
                brelse(bitmap_bh);
                bitmap_bh = ext4_read_block_bitmap(sb, i);
                if (bitmap_bh == NULL)

                                                - Zheng

>  	struct ext4_super_block *es;
>  	ext4_fsblk_t bitmap_count;
> @@ -679,7 +680,11 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
