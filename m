From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: merge ext4_xattr_list() into ext4_listxattr()
Date: Tue, 21 Mar 2017 16:24:40 +0100
Message-ID: <20170321152440.GA17712@quack2.suse.cz>
References: <20170315043325.6764-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52258 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756805AbdCUPYp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 21 Mar 2017 11:24:45 -0400
Content-Disposition: inline
In-Reply-To: <20170315043325.6764-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 14-03-17 21:33:25, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> There's no difference between ext4_xattr_list() and ext4_listxattr(), so
> merge them together and just have ext4_listxattr().  Some years ago they
> took different arguments, but that's no longer the case.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/xattr.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 67636acf7624..1d59895a91ee 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -78,8 +78,6 @@ static struct buffer_head *ext4_xattr_cache_find(struct inode *,
>  						 struct mb_cache_entry **);
>  static void ext4_xattr_rehash(struct ext4_xattr_header *,
>  			      struct ext4_xattr_entry *);
> -static int ext4_xattr_list(struct dentry *dentry, char *buffer,
> -			   size_t buffer_size);
>  
>  static const struct xattr_handler *ext4_xattr_handler_map[] = {
>  	[EXT4_XATTR_INDEX_USER]		     = &ext4_xattr_user_handler,
> @@ -168,17 +166,6 @@ ext4_xattr_handler(int name_index)
>  	return handler;
>  }
>  
> -/*
> - * Inode operation listxattr()
> - *
> - * d_inode(dentry)->i_mutex: don't care
> - */
> -ssize_t
> -ext4_listxattr(struct dentry *dentry, char *buffer, size_t size)
> -{
> -	return ext4_xattr_list(dentry, buffer, size);
> -}
> -
>  static int
>  ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end,
>  		       void *value_start)
> @@ -524,7 +511,9 @@ ext4_xattr_ibody_list(struct dentry *dentry, char *buffer, size_t buffer_size)
>  }
>  
>  /*
> - * ext4_xattr_list()
> + * Inode operation listxattr()
> + *
> + * d_inode(dentry)->i_rwsem: don't care
>   *
>   * Copy a list of attribute names into the buffer
>   * provided, or compute the buffer size required.
> @@ -533,8 +522,8 @@ ext4_xattr_ibody_list(struct dentry *dentry, char *buffer, size_t buffer_size)
>   * Returns a negative error number on failure, or the number of bytes
>   * used / required on success.
>   */
> -static int
> -ext4_xattr_list(struct dentry *dentry, char *buffer, size_t buffer_size)
> +ssize_t
> +ext4_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
>  {
>  	int ret, ret2;
>  
> -- 
> 2.12.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
