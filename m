From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: check xattr name_len before acquiring sem lock
 in ext2_xattr_get
Date: Fri, 22 Jul 2011 19:37:27 +0200
Message-ID: <20110722173727.GA11015@quack.suse.cz>
References: <4E2983E0.3060208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab1GVRh3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jul 2011 13:37:29 -0400
Content-Disposition: inline
In-Reply-To: <4E2983E0.3060208@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 22-07-11 22:06:24, Wang Sheng-Hui wrote:
> From 667173a18b671896f933c5952fa211601d2e5ab0 Mon Sep 17 00:00:00 2001
> From: Wang Sheng-Hui <shhuiw@gmail.com>
> Date: Fri, 22 Jul 2011 08:50:13 -0500
> Subject: [PATCH] ext2: check xattr name_len before acquiring sem lock in ext2_xattr_get
> 
> The patch is against 3.0.
> 
> In ext2_xattr_get, the code will acquire sem lock first, later check
> the length of xattr name_len > 255. It's kind of time consuming, and
> we should do the basic check before the time consuming acquiring sem
> lock.
  Well, but the check name_len > 255 is almost never true so it does not
really make a difference... But I see ext2_xattr_set() also checks the
length first so it probably makes sense from consistency point of view.
So I'll take the patch into my tree.

								Honza
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/ext2/xattr.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 5299706..d27b71f 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -161,6 +161,10 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
>  
>  	if (name == NULL)
>  		return -EINVAL;
> +	name_len = strlen(name);
> +	if (name_len > 255)
> +		return -ERANGE;
> +
>  	down_read(&EXT2_I(inode)->xattr_sem);
>  	error = -ENODATA;
>  	if (!EXT2_I(inode)->i_file_acl)
> @@ -181,12 +185,8 @@ bad_block:	ext2_error(inode->i_sb, "ext2_xattr_get",
>  		error = -EIO;
>  		goto cleanup;
>  	}
> -	/* find named attribute */
> -	name_len = strlen(name);
>  
> -	error = -ERANGE;
> -	if (name_len > 255)
> -		goto cleanup;
> +	/* find named attribute */
>  	entry = FIRST_ENTRY(bh);
>  	while (!IS_LAST_ENTRY(entry)) {
>  		struct ext2_xattr_entry *next =
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
