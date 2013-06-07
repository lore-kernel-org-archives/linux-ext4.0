From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: return FIEMAP_EXTENT_UNKNOWN if an extent is
 delayed allocations
Date: Fri, 7 Jun 2013 19:54:22 +0800
Message-ID: <20130607115422.GA12217@gmail.com>
References: <51B08F45.1050605@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58950 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3FGLgV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jun 2013 07:36:21 -0400
Received: by mail-pd0-f180.google.com with SMTP id 10so4672180pdi.25
        for <linux-ext4@vger.kernel.org>; Fri, 07 Jun 2013 04:36:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <51B08F45.1050605@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 06, 2013 at 09:31:49PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Return the FIEMAP_EXTENT_UNKNOWN flag as well except the
> FIEMAP_EXTENT_DELALLOC because the data location of an
> delayed allocation extent is unknown.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  fs/ext4/extents.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bc0f191..47e17b1 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2125,7 +2125,8 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
>  		next_del = ext4_find_delayed_extent(inode, &es);
>  		if (!exists && next_del) {
>  			exists = 1;
> -			flags |= FIEMAP_EXTENT_DELALLOC;
> +			flags |= (FIEMAP_EXTENT_DELALLOC |
> +				  FIEMAP_EXTENT_UNKNOWN);
>  		}
>  		up_read(&EXT4_I(inode)->i_data_sem);
>  
> -- 
> 1.7.9.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
