From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: no need to remove extent if len is 0 in
 ext4_es_remove_extent()
Date: Fri, 22 Feb 2013 14:25:09 +0800
Message-ID: <20130222062509.GA2735@gmail.com>
References: <1361511243-2458-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61006 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3BVGKX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2013 01:10:23 -0500
Received: by mail-pb0-f45.google.com with SMTP id ro8so218577pbb.4
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2013 22:10:23 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1361511243-2458-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 22, 2013 at 01:34:03PM +0800, Eryu Guan wrote:
> len is 0 means no extent needs to be removed, so return immediately.
> Otherwise it could trigger the following BUG_ON()
> 
> 	436	end = offset + len - 1;
> 	437	BUG_ON(end < offset);
> 
> This could be reproduced by a simple truncate(1) command by an
> unprivileged user
> 
> 	truncate -s $(($((2**32 - 1)) * 4096)) /mnt/ext4/testfile
> 
> The same is true for __es_insert_extent().
> 
> Patched kernel passed xfstests regression test.
> 
> Also remove comments about EXT4_I(inode)->i_es_lock, this rwlock
> isn't hold by callers.
> 
> Cc: Zheng Liu <wenqing.lz@taobao.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Thanks for fixing it.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                                - Zheng

> ---
>  fs/ext4/extents_status.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 564d981..3ac09ca 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -328,6 +328,9 @@ static int __es_insert_extent(struct ext4_es_tree *tree, ext4_lblk_t offset,
>  	struct extent_status *es;
>  	ext4_lblk_t end = offset + len - 1;
>  
> +	if (!len)
> +		return 0;
> +
>  	BUG_ON(end < offset);
>  	es = tree->cache_es;
>  	if (es && offset == (extent_status_end(es) + 1)) {
> @@ -386,7 +389,6 @@ out:
>  
>  /*
>   * ext4_es_insert_extent() adds a space to a delayed extent tree.
> - * Caller holds inode->i_es_lock.
>   *
>   * ext4_es_insert_extent is called by ext4_da_write_begin and
>   * ext4_es_remove_extent.
> @@ -415,7 +417,6 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t offset,
>  
>  /*
>   * ext4_es_remove_extent() removes a space from a delayed extent tree.
> - * Caller holds inode->i_es_lock.
>   *
>   * Return 0 on success, error code on failure.
>   */
> @@ -433,6 +434,9 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t offset,
>  	es_debug("remove [%u/%u) from extent status tree of inode %lu\n",
>  		 offset, len, inode->i_ino);
>  
> +	if (!len)
> +		return err;
> +
>  	end = offset + len - 1;
>  	BUG_ON(end < offset);
>  	write_lock(&EXT4_I(inode)->i_es_lock);
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
