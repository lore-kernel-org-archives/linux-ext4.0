From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: remove unreachable code after
 ext4_can_extents_be_merged()
Date: Fri, 1 Nov 2013 11:09:19 +0800
Message-ID: <20131101030919.GB7314@gmail.com>
References: <5272C4E3.5040206@redhat.com>
 <5272C929.80303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63259 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab3KADHG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Oct 2013 23:07:06 -0400
Received: by mail-pa0-f51.google.com with SMTP id ld10so3399866pab.24
        for <linux-ext4@vger.kernel.org>; Thu, 31 Oct 2013 20:07:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5272C929.80303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 31, 2013 at 04:18:33PM -0500, Eric Sandeen wrote:
> commit
> ec22ba8e ext4: disable merging of uninitialized extents
>  
> ensured that if either extent under consideration is uninit,
> we decline to merge, and ext4_can_extents_be_merged() returns false.
> 
> So there is no need for the caller to then test whether the
> extent under consideration is unitialized; if it were, we
> wouldn't have gotten that far.
> 
> The comments were also inaccurate; ext4_can_extents_be_merged()
> no longer XORs the states, it fails if *either* is uninit.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks,
                                                - Zheng

> ---
> 
> Disclaimer: compile-tested only.
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index de6d467..35f65cf 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1715,7 +1715,6 @@ static int ext4_ext_try_to_merge_right(struct inode *inode,
>  	struct ext4_extent_header *eh;
>  	unsigned int depth, len;
>  	int merge_done = 0;
> -	int uninitialized = 0;
>  
>  	depth = ext_depth(inode);
>  	BUG_ON(path[depth].p_hdr == NULL);
> @@ -1725,12 +1724,8 @@ static int ext4_ext_try_to_merge_right(struct inode *inode,
>  		if (!ext4_can_extents_be_merged(inode, ex, ex + 1))
>  			break;
>  		/* merge with next extent! */
> -		if (ext4_ext_is_uninitialized(ex))
> -			uninitialized = 1;
>  		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
>  				+ ext4_ext_get_actual_len(ex + 1));
> -		if (uninitialized)
> -			ext4_ext_mark_uninitialized(ex);
>  
>  		if (ex + 1 < EXT_LAST_EXTENT(eh)) {
>  			len = (EXT_LAST_EXTENT(eh) - ex - 1)
> @@ -1885,7 +1880,6 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
>  	struct ext4_ext_path *npath = NULL;
>  	int depth, len, err;
>  	ext4_lblk_t next;
> -	unsigned uninitialized = 0;
>  	int mb_flags = 0;
>  
>  	if (unlikely(ext4_ext_get_actual_len(newext) == 0)) {
> @@ -1937,18 +1931,8 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
>  			if (err)
>  				return err;
>  
> -			/*
> -			 * ext4_can_extents_be_merged should have checked
> -			 * that either both extents are uninitialized, or
> -			 * both aren't. Thus we need to check only one of
> -			 * them here.
> -			 */
> -			if (ext4_ext_is_uninitialized(ex))
> -				uninitialized = 1;
>  			ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
>  					+ ext4_ext_get_actual_len(newext));
> -			if (uninitialized)
> -				ext4_ext_mark_uninitialized(ex);
>  			eh = path[depth].p_hdr;
>  			nearex = ex;
>  			goto merge;
> @@ -1971,20 +1955,10 @@ prepend:
>  			if (err)
>  				return err;
>  
> -			/*
> -			 * ext4_can_extents_be_merged should have checked
> -			 * that either both extents are uninitialized, or
> -			 * both aren't. Thus we need to check only one of
> -			 * them here.
> -			 */
> -			if (ext4_ext_is_uninitialized(ex))
> -				uninitialized = 1;
>  			ex->ee_block = newext->ee_block;
>  			ext4_ext_store_pblock(ex, ext4_ext_pblock(newext));
>  			ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
>  					+ ext4_ext_get_actual_len(newext));
> -			if (uninitialized)
> -				ext4_ext_mark_uninitialized(ex);
>  			eh = path[depth].p_hdr;
>  			nearex = ex;
>  			goto merge;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
