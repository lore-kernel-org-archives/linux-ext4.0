From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: Prevent race while waling extent tree
Date: Thu, 08 Nov 2012 16:01:17 +0400
Message-ID: <87liecs3qq.fsf@openvz.org>
References: <1352372929-18513-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51011 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2KHMBU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Nov 2012 07:01:20 -0500
Received: by mail-lb0-f174.google.com with SMTP id n3so2099837lbo.19
        for <linux-ext4@vger.kernel.org>; Thu, 08 Nov 2012 04:01:19 -0800 (PST)
In-Reply-To: <1352372929-18513-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu,  8 Nov 2012 12:08:49 +0100, Lukas Czerner <lczerner@redhat.com> wrote:
> Currently ext4_ext_walk_space() only takes i_data_sem for read when
> searching for the extent at given block with ext4_ext_find_extent().
> Then it drops the lock and the extent tree can be changed at will.
> However later on we're searching for the 'next' extent, but the extent
> tree might already have changed, so the information might not be
> accurate.
> 
> In fact we can hit BUG_ON(end <= start) if the extent got inserted into
> the tree after the one we found and before the block we were searching
> for. This has been reproduced by running xfstests 225 in loop on s390x
> architecture, but theoretically we could hit this on any other
> architecture as well, but probably not as often.
> 
> ext4_ext_walk_space() is currently only used from ext4_fiemap() and even
> if we do not hit the BUG_ON() fiemap might return scrambled information
> to the user.
> 
> Fix this by requiring ext4_ext_walk_space() to be called with i_data_sem
> held. By calling it from ext4_fiemap() we can only take the i_data_sem
> for read, but possibly other users might want to modify the extents so
> they will be able to take write lock.
Agree as a short term fix for BUGON case, but Theodore suggested to use
seqlock approach http://lists.openwall.net/linux-ext4/2011/10/26/25

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/extents.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7011ac9..f1aca06 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1959,6 +1959,11 @@ cleanup:
>  	return err;
>  }
>  
> +/*
> + * ext4_ext_walk_space() should be called with i_data_sem locked. If we're
> + * not modifying found extents, or extent tree in callback function, then
> + * read lock is ok.
> + */
>  static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>  			       ext4_lblk_t num, ext_prepare_callback func,
>  			       void *cbdata)
> @@ -1976,9 +1981,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>  	while (block < last && block != EXT_MAX_BLOCKS) {
>  		num = last - block;
>  		/* find extent for this block */
> -		down_read(&EXT4_I(inode)->i_data_sem);
>  		path = ext4_ext_find_extent(inode, block, path);
> -		up_read(&EXT4_I(inode)->i_data_sem);
>  		if (IS_ERR(path)) {
>  			err = PTR_ERR(path);
>  			path = NULL;
> @@ -5021,8 +5024,10 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		 * Walk the extent tree gathering extent information.
>  		 * ext4_ext_fiemap_cb will push extents back to user.
>  		 */
> +		down_read(&EXT4_I(inode)->i_data_sem);
>  		error = ext4_ext_walk_space(inode, start_blk, len_blks,
>  					  ext4_ext_fiemap_cb, fieinfo);
> +		up_read(&EXT4_I(inode)->i_data_sem);
>  	}
>  
>  	return error;
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
