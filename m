From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2] ext4: add WARN_ON to check the length of allocated
 blocks
Date: Tue, 30 Jul 2013 07:37:46 +0800
Message-ID: <20130729233746.GA3648@gmail.com>
References: <1373590852-29544-1-git-send-email-wenqing.lz@taobao.com>
 <20130729150915.GC2615@gmail.com>
 <20130729165245.GJ11816@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63343 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3G2Xho (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jul 2013 19:37:44 -0400
Received: by mail-pb0-f44.google.com with SMTP id wy7so5236464pbc.31
        for <linux-ext4@vger.kernel.org>; Mon, 29 Jul 2013 16:37:43 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130729165245.GJ11816@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 29, 2013 at 12:52:45PM -0400, Theodore Ts'o wrote:
> The patch didn't apply as-is so I had to adjust it a bit.  I also
> reworded the commit description.

Ah, sorry, I forgot that this patch needs to be rebased against the
latest ext4/dev branch.  The patch looks good.  Thanks for fixing it.

                                                - Zheng

> 
> 					- Ted
> 
> From 44fb851dfb2f8e3462617e19a7b3b9025db9d919 Mon Sep 17 00:00:00 2001
> From: Zheng Liu <wenqing.lz@taobao.com>
> Date: Mon, 29 Jul 2013 12:51:42 -0400
> Subject: [PATCH] ext4: add WARN_ON to check the length of allocated blocks
> 
> In commit 921f266b: ext4: add self-testing infrastructure to do a
> sanity check, some sanity checks were added in map_blocks to make sure
> 'retval == map->m_len'.
> 
> Enable these checks by default and report any assertion failures using
> ext4_warning() and WARN_ON() since they can help us to figure out some
> bugs that are otherwise hard to hit.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/inode.c | 39 ++++++++++++++++++---------------------
>  1 file changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ba33c67..dd32a2e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -555,14 +555,13 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  		int ret;
>  		unsigned long long status;
>  
> -#ifdef ES_AGGRESSIVE_TEST
> -		if (retval != map->m_len) {
> -			printk("ES len assertion failed for inode: %lu "
> -			       "retval %d != map->m_len %d "
> -			       "in %s (lookup)\n", inode->i_ino, retval,
> -			       map->m_len, __func__);
> +		if (unlikely(retval != map->m_len)) {
> +			ext4_warning(inode->i_sb,
> +				     "ES len assertion failed for inode "
> +				     "%lu: retval %d != map->m_len %d",
> +				     inode->i_ino, retval, map->m_len);
> +			WARN_ON(1);
>  		}
> -#endif
>  
>  		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
>  				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
> @@ -656,14 +655,13 @@ found:
>  		int ret;
>  		unsigned long long status;
>  
> -#ifdef ES_AGGRESSIVE_TEST
> -		if (retval != map->m_len) {
> -			printk("ES len assertion failed for inode: %lu "
> -			       "retval %d != map->m_len %d "
> -			       "in %s (allocation)\n", inode->i_ino, retval,
> -			       map->m_len, __func__);
> +		if (unlikely(retval != map->m_len)) {
> +			ext4_warning(inode->i_sb,
> +				     "ES len assertion failed for inode "
> +				     "%lu: retval %d != map->m_len %d",
> +				     inode->i_ino, retval, map->m_len);
> +			WARN_ON(1);
>  		}
> -#endif
>  
>  		/*
>  		 * If the extent has been zeroed out, we don't need to update
> @@ -1637,14 +1635,13 @@ add_delayed:
>  		int ret;
>  		unsigned long long status;
>  
> -#ifdef ES_AGGRESSIVE_TEST
> -		if (retval != map->m_len) {
> -			printk("ES len assertion failed for inode: %lu "
> -			       "retval %d != map->m_len %d "
> -			       "in %s (lookup)\n", inode->i_ino, retval,
> -			       map->m_len, __func__);
> +		if (unlikely(retval != map->m_len)) {
> +			ext4_warning(inode->i_sb,
> +				     "ES len assertion failed for inode "
> +				     "%lu: retval %d != map->m_len %d",
> +				     inode->i_ino, retval, map->m_len);
> +			WARN_ON(1);
>  		}
> -#endif
>  
>  		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
>  				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
