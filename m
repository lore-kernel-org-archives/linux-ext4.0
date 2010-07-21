From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] check name_len before down_read xattr_sem and sb_read
	in ext2_xattr_get
Date: Wed, 21 Jul 2010 19:44:57 +0200
Message-ID: <20100721174457.GE1215@atrey.karlin.mff.cuni.cz>
References: <201007122229025316610@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>
To: crosslonelyover <crosslonelyover@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52096 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753294Ab0GURo6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Jul 2010 13:44:58 -0400
Content-Disposition: inline
In-Reply-To: <201007122229025316610@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Hi,
>        I walked through ext2_xattr_get, and felt that we can
> do some optimization on it. For name_len check, it's done
> after down xattr_sem and sb_read, both of which are time
> consuming operation compared with strlen:
>          down_read(&EXT2_I(inode)->xattr_sem);
>  ...
>          bh = sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
>  ...
>          /* find named attribute */
>          name_len = strlen(name);
> 
>          error = -ERANGE;
>          if (name_len > 255)
>                  goto cleanup;
> 
>        Most of the case, you'll get one valid block, but if the
> name len > 255, then the xattr_sem down and sb_bread operation
> can be seen as a waste of time. So I think we'd better do
> name len check as early as possible.
>        Following is my patch, and it's against 2.6.35-rc4.
> Please check it.
> 
> Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
> ---
>  fs/ext2/xattr.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 7c39157..0b94d61 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -161,6 +161,13 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
>  
>  	if (name == NULL)
>  		return -EINVAL;
> +
> +	/* find named attribute */
> +	name_len = strlen(name);
> +	error = -ERANGE;
> +	if (name_len > 255)
> +		goto cleanup;
  But you cannot go to cleanup here because you don't hold xattr_sem...

									Honza
> +
>  	down_read(&EXT2_I(inode)->xattr_sem);
>  	error = -ENODATA;
>  	if (!EXT2_I(inode)->i_file_acl)
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
