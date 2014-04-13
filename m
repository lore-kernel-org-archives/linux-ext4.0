From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: use i_size_read in ext4_unaligned_aio()
Date: Sun, 13 Apr 2014 16:10:06 +0800
Message-ID: <20140413081005.GA3041@gmail.com>
References: <1397321174-7605-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:55302 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaDMIDy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Apr 2014 04:03:54 -0400
Content-Disposition: inline
In-Reply-To: <1397321174-7605-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 12, 2014 at 12:46:14PM -0400, Theodore Ts'o wrote:
> We haven't taken i_mutex yet, so we need to use i_size_read().
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  fs/ext4/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 6db7f7d..bc76559 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -82,7 +82,7 @@ ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
>  	size_t count = iov_length(iov, nr_segs);
>  	loff_t final_size = pos + count;
>  
> -	if (pos >= inode->i_size)
> +	if (pos >= i_size_read(inode))
>  		return 0;
>  
>  	if ((pos & blockmask) || (final_size & blockmask))
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
