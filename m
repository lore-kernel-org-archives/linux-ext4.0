From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Convert ext4 to new truncate calling convention
Date: Wed, 25 May 2011 11:15:27 +0200
Message-ID: <20110525091527.GA6246@quack.suse.cz>
References: <1306312988-5508-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab1EYJP3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 05:15:29 -0400
Content-Disposition: inline
In-Reply-To: <1306312988-5508-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 25-05-11 10:43:08, Jan Kara wrote:
> Mostly trivial conversion. We fix a bug that IS_IMMUTABLE and IS_APPEND
> files could not be truncated during failed writes as we change the code.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
  I've just noticed that Ted has changed the code this week as well and
removed vmtruncate() from ->setattr(). So Ted, please ignore this patch and
I'll send you another patch based on current ext4 state in your tree.

								Honza
> ---
>  fs/ext4/file.c  |    1 -
>  fs/ext4/inode.c |   24 ++++++++++++++++++++----
>  2 files changed, 20 insertions(+), 5 deletions(-)
> 
>   Ted, can you please merge this patch? Thanks.
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 7b80d54..2c09723 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -272,7 +272,6 @@ const struct file_operations ext4_file_operations = {
>  };
>  
>  const struct inode_operations ext4_file_inode_operations = {
> -	.truncate	= ext4_truncate,
>  	.setattr	= ext4_setattr,
>  	.getattr	= ext4_getattr,
>  #ifdef CONFIG_EXT4_FS_XATTR
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4eca654..0aa52b4 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3513,7 +3513,7 @@ retry:
>  			loff_t end = offset + iov_length(iov, nr_segs);
>  
>  			if (end > isize)
> -				vmtruncate(inode, isize);
> +				ext4_truncate_failed_write(inode);
>  		}
>  	}
>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> @@ -4380,8 +4380,6 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
>  
>  int ext4_can_truncate(struct inode *inode)
>  {
> -	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> -		return 0;
>  	if (S_ISREG(inode->i_mode))
>  		return 1;
>  	if (S_ISDIR(inode->i_mode))
> @@ -5236,6 +5234,24 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
>  	return err;
>  }
>  
> +static int ext4_setsize(struct inode *inode, loff_t newsize)
> +{
> +	loff_t oldsize;
> +	int rc;
> +
> +	rc = inode_newsize_ok(inode, newsize);
> +	if (rc)
> +		return rc;
> +	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> +		return -EPERM;
> +	oldsize = inode->i_size;
> +	i_size_write(inode, newsize);
> +	truncate_pagecache(inode, oldsize, newsize);
> +	ext4_truncate(inode);
> +
> +	return 0;
> +}
> +
>  /*
>   * ext4_setattr()
>   *
> @@ -5353,7 +5369,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  
>  	if ((attr->ia_valid & ATTR_SIZE) &&
>  	    attr->ia_size != i_size_read(inode))
> -		rc = vmtruncate(inode, attr->ia_size);
> +		rc = ext4_setsize(inode, attr->ia_size);
>  
>  	if (!rc) {
>  		setattr_copy(inode, attr);
> -- 
> 1.7.1
> 
