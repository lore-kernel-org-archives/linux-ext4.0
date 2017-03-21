From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: rename ext4_xattr_check_names() to
 ext4_xattr_check_entries()
Date: Tue, 21 Mar 2017 16:25:40 +0100
Message-ID: <20170321152540.GB17712@quack2.suse.cz>
References: <20170315045057.18837-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52487 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757180AbdCUPZo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 21 Mar 2017 11:25:44 -0400
Content-Disposition: inline
In-Reply-To: <20170315045057.18837-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 14-03-17 21:50:55, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> ext4_xattr_check_names() actually validates both the xattr names and
> values, not just the names.  So rename it to ext4_xattr_check_entries()
> to avoid confusion.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/xattr.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 1d59895a91ee..71bf40933bbb 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -167,8 +167,8 @@ ext4_xattr_handler(int name_index)
>  }
>  
>  static int
> -ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end,
> -		       void *value_start)
> +ext4_xattr_check_entries(struct ext4_xattr_entry *entry, void *end,
> +			 void *value_start)
>  {
>  	struct ext4_xattr_entry *e = entry;
>  
> @@ -222,8 +222,8 @@ ext4_xattr_check_block(struct inode *inode, struct buffer_head *bh)
>  		return -EFSCORRUPTED;
>  	if (!ext4_xattr_block_csum_verify(inode, bh->b_blocknr, BHDR(bh)))
>  		return -EFSBADCRC;
> -	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size,
> -				       bh->b_data);
> +	error = ext4_xattr_check_entries(BFIRST(bh), bh->b_data + bh->b_size,
> +					 bh->b_data);
>  	if (!error)
>  		set_buffer_verified(bh);
>  	return error;
> @@ -238,7 +238,7 @@ __xattr_check_inode(struct inode *inode, struct ext4_xattr_ibody_header *header,
>  	if (end - (void *)header < sizeof(*header) + sizeof(u32) ||
>  	    (header->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC)))
>  		goto errout;
> -	error = ext4_xattr_check_names(IFIRST(header), end, IFIRST(header));
> +	error = ext4_xattr_check_entries(IFIRST(header), end, IFIRST(header));
>  errout:
>  	if (error)
>  		__ext4_error_inode(inode, function, line, 0,
> -- 
> 2.12.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
