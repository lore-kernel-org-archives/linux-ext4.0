From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix retry handling in ext4_ext_truncate()
Date: Tue, 30 Jul 2013 07:51:38 +0800
Message-ID: <20130729235138.GD3648@gmail.com>
References: <1375114502-21261-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62558 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3G2Xvq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jul 2013 19:51:46 -0400
Content-Disposition: inline
In-Reply-To: <1375114502-21261-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 29, 2013 at 12:15:02PM -0400, Theodore Ts'o wrote:
> We tested for ENOMEM instead of -ENOMEM.   Oops.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
                                                - Zheng

> ---
>  fs/ext4/extents.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index a618738..72ba470 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4412,7 +4412,7 @@ void ext4_ext_truncate(handle_t *handle, struct inode *inode)
>  retry:
>  	err = ext4_es_remove_extent(inode, last_block,
>  				    EXT_MAX_BLOCKS - last_block);
> -	if (err == ENOMEM) {
> +	if (err == -ENOMEM) {
>  		cond_resched();
>  		congestion_wait(BLK_RW_ASYNC, HZ/50);
>  		goto retry;
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
