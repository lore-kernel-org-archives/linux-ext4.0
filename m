From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: remove unreachable code in
 ext4_can_extents_be_merged()
Date: Fri, 1 Nov 2013 11:05:25 +0800
Message-ID: <20131101030525.GA7314@gmail.com>
References: <5272C4E3.5040206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41059 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab3KADDJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Oct 2013 23:03:09 -0400
Received: by mail-pa0-f47.google.com with SMTP id lf10so3397145pab.6
        for <linux-ext4@vger.kernel.org>; Thu, 31 Oct 2013 20:03:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5272C4E3.5040206@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 31, 2013 at 04:00:19PM -0500, Eric Sandeen wrote:
> commit
> ec22ba8e ext4: disable merging of uninitialized extents
> 
> ensured that if either extent under consideration is uninit,
> we decline to merge, and immediately return.
> 
> But right after that test, we test again for an uninit
> extent; we can never hit this.  So just remove the impossible
> test and associated variable.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks,
                                                - Zheng

> ---
> 
> Disclosure: compile-tested only.
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 54d52af..de6d467 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1666,7 +1666,7 @@ int
>  ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
>  				struct ext4_extent *ex2)
>  {
> -	unsigned short ext1_ee_len, ext2_ee_len, max_len;
> +	unsigned short ext1_ee_len, ext2_ee_len;
>  
>  	/*
>  	 * Make sure that both extents are initialized. We don't merge
> @@ -1677,11 +1677,6 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
>  	if (ext4_ext_is_uninitialized(ex1) || ext4_ext_is_uninitialized(ex2))
>  		return 0;
>  
> -	if (ext4_ext_is_uninitialized(ex1))
> -		max_len = EXT_UNINIT_MAX_LEN;
> -	else
> -		max_len = EXT_INIT_MAX_LEN;
> -
>  	ext1_ee_len = ext4_ext_get_actual_len(ex1);
>  	ext2_ee_len = ext4_ext_get_actual_len(ex2);
>  
> @@ -1694,7 +1689,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
>  	 * as an RO_COMPAT feature, refuse to merge to extents if
>  	 * this can result in the top bit of ee_len being set.
>  	 */
> -	if (ext1_ee_len + ext2_ee_len > max_len)
> +	if (ext1_ee_len + ext2_ee_len > EXT_INIT_MAX_LEN)
>  		return 0;
>  #ifdef AGGRESSIVE_TEST
>  	if (ext1_ee_len >= 4)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
