From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: don't re-try to remove the entry from es tree when
 we encounter a ENOMEM in ext4_ext_truncate
Date: Mon, 29 Jul 2013 23:07:58 +0800
Message-ID: <20130729150758.GB2615@gmail.com>
References: <1374753397-26432-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34389 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3G2PH7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jul 2013 11:07:59 -0400
Received: by mail-pb0-f52.google.com with SMTP id xa12so4700040pbc.39
        for <linux-ext4@vger.kernel.org>; Mon, 29 Jul 2013 08:07:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1374753397-26432-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 25, 2013 at 07:56:37PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> ext4_es_remove_extent returns ENOMEM only if we need to split an entry
> and insert a part into es tree.  After applied this commit (e15f742c),
> we have retried to do this.  So we don't need to do this again in
> ext4_ext_truncate().
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>

Any comment?

Thanks
                                                - Zheng

> ---
>  fs/ext4/extents.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index a618738..4404297 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4409,14 +4409,8 @@ void ext4_ext_truncate(handle_t *handle, struct inode *inode)
>  
>  	last_block = (inode->i_size + sb->s_blocksize - 1)
>  			>> EXT4_BLOCK_SIZE_BITS(sb);
> -retry:
>  	err = ext4_es_remove_extent(inode, last_block,
>  				    EXT_MAX_BLOCKS - last_block);
> -	if (err == ENOMEM) {
> -		cond_resched();
> -		congestion_wait(BLK_RW_ASYNC, HZ/50);
> -		goto retry;
> -	}
>  	if (err) {
>  		ext4_std_error(inode->i_sb, err);
>  		return;
> -- 
> 1.7.9.7
> 
