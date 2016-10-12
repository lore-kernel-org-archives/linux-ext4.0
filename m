From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: correct endianness conversion in
 __xattr_check_inode()
Date: Wed, 12 Oct 2016 12:36:46 +0200
Message-ID: <20161012103646.GA14664@quack2.suse.cz>
References: <1476205286-136713-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932615AbcJLKgz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Oct 2016 06:36:55 -0400
Content-Disposition: inline
In-Reply-To: <1476205286-136713-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 11-10-16 10:01:26, Eric Biggers wrote:
> It should be cpu_to_le32(), not le32_to_cpu().  No change in behavior.
> 
> Found with sparse, and this was the only endianness warning in fs/ext4/.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index c15d633..e90c5cd 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -241,7 +241,7 @@ __xattr_check_inode(struct inode *inode, struct ext4_xattr_ibody_header *header,
>  	int error = -EFSCORRUPTED;
>  
>  	if (((void *) header >= end) ||
> -	    (header->h_magic != le32_to_cpu(EXT4_XATTR_MAGIC)))
> +	    (header->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC)))
>  		goto errout;
>  	error = ext4_xattr_check_names(entry, end, entry);
>  errout:
> -- 
> 2.8.0.rc3.226.g39d4020
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
