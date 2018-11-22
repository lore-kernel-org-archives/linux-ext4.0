Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41014 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729105AbeKVXBG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 18:01:06 -0500
Date: Thu, 22 Nov 2018 13:21:55 +0100
From: Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [PATCH] ext4: add ext4_sb_bread() to disambiguate ENOMEM cases
Message-ID: <20181122122155.GN9840@quack2.suse.cz>
References: <20181117233523.8832-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181117233523.8832-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 17-11-18 18:35:23, Theodore Ts'o wrote:
> Today, when sb_bread() returns NULL, this can either be because of an
> I/O error or because the system failed to allocate the buffer.  Since
> it's an old interface, changing would require changing many call
> sites.
> 
> So instead we create our own ext4_sb_bread(), which also allows us to
> set the REQ_META flag.
> 
> Also fixed a problem in the xattr code where a NULL return in a
> function could also mean that the xattr was not found, which could
> lead to the wrong error getting returned to userspace.
> 
> Fixes: ac27a0ec112a ("ext4: initial copy of files from ext3")
> Cc: stable@kernel.org
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

...

> +/*
> + * This works like sb_bread() except it uses ERR_PTR for error
> + * returns.  Currently with sb_bread it's impossible to distinguish
> + * between ENOMEM and EIO situations (since both result in a NULL
> + * return.
> + */
> +struct buffer_head *
> +ext4_sb_bread(struct super_block *sb, sector_t block)
> +{
> +	struct buffer_head *bh = sb_getblk(sb, block);
> +
> +	if (bh == NULL)
> +		return ERR_PTR(-ENOMEM);
> +	if (buffer_uptodate(bh))
> +		return bh;
> +	ll_rw_block(REQ_OP_READ, REQ_META | REQ_PRIO, 1, &bh);

Is there a reason for REQ_PRIO? I'm not sure all REQ_META reads are really
a priority ones...

> +	wait_on_buffer(bh);
> +	if (buffer_uptodate(bh))
> +		return bh;
> +	put_bh(bh);
> +	return ERR_PTR(-EIO);
> +}
> +
>  static int ext4_verify_csum_type(struct super_block *sb,
>  				 struct ext4_super_block *es)
>  {

...

> @@ -696,26 +695,23 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
>  	ea_idebug(inode, "buffer=%p, buffer_size=%ld",
>  		  buffer, (long)buffer_size);
>  
> -	error = 0;
>  	if (!EXT4_I(inode)->i_file_acl)
> -		goto cleanup;
> +		return NULL;

NULL looks wrong here - should be 0 I guess...

Otherwise the patch looks good to me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
