From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [patch] ext4: signedness bug breaks ext4_inode_touch_time_cmp()
Date: Thu, 20 Jun 2013 23:21:58 +0800
Message-ID: <20130620152158.GA20615@gmail.com>
References: <20130620080858.GA15095@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51628 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713Ab3FTPDr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Jun 2013 11:03:47 -0400
Content-Disposition: inline
In-Reply-To: <20130620080858.GA15095@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 20, 2013 at 11:08:58AM +0300, Dan Carpenter wrote:
> "diff" is unsigned so this doesn't sort the LRU list correctly.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks for fixing it.

Regards,
                                                - Zheng

> ---
> This was introduced in 6480bad916be "ext4: improve extent cache shrink
> mechanism to avoid to burn CPU time"
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index e0190f6..79e097d 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -880,7 +880,7 @@ static int ext4_inode_touch_time_cmp(void *priv, struct list_head *a,
>  				     struct list_head *b)
>  {
>  	struct ext4_inode_info *eia, *eib;
> -	unsigned long diff;
> +	long diff;
>  
>  	eia = list_entry(a, struct ext4_inode_info, i_es_lru);
>  	eib = list_entry(b, struct ext4_inode_info, i_es_lru);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
