From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/5] ext4: Fix type declaration of
 ext4_validate_block_bitmap
Date: Wed, 24 Jul 2013 15:12:01 +0800
Message-ID: <20130724071201.GA3474@gmail.com>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130719235546.24017.98557.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59061 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab3GXHMI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jul 2013 03:12:08 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so9316435pbb.36
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jul 2013 00:12:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130719235546.24017.98557.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 19, 2013 at 04:55:46PM -0700, Darrick J. Wong wrote:
> The block_group parameter to ext4_validate_block_bitmap is both used as a
> ext4_group_t inside the function and the same type is passed in by all callers.
> We might as well use the typedef consistently instead of open-coding the
> 'unsigned int'.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ext4/balloc.c |    2 +-
>  fs/ext4/ext4.h   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index b430afe..735e701 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -352,7 +352,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
                                          ^^^
It seems that this function also needs to be fixed.

                                                - Zheng

>  
>  void ext4_validate_block_bitmap(struct super_block *sb,
>  			       struct ext4_group_desc *desc,
> -			       unsigned int block_group,
> +			       ext4_group_t block_group,
>  			       struct buffer_head *bh)
>  {
>  	ext4_fsblk_t	blk;
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b577e45..39d24e2 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1915,7 +1915,7 @@ extern ext4_group_t ext4_get_group_number(struct super_block *sb,
>  
>  extern void ext4_validate_block_bitmap(struct super_block *sb,
>  				       struct ext4_group_desc *desc,
> -				       unsigned int block_group,
> +				       ext4_group_t block_group,
>  				       struct buffer_head *bh);
>  extern unsigned int ext4_block_group(struct super_block *sb,
>  			ext4_fsblk_t blocknr);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
