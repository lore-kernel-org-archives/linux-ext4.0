From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] ext4 : Add missing posix_acl_release() in
 ext4_xattr_set_acl() in error path.
Date: Wed, 11 May 2011 18:18:08 +0200
Message-ID: <20110511161808.GK5057@quack.suse.cz>
References: <BANLkTin4PDgtZUHgrPnQbg_0+dN6_Fj_Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Manish Katiyar <manish.katiyar@in.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370Ab1EKQSK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2011 12:18:10 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTin4PDgtZUHgrPnQbg_0+dN6_Fj_Gg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 24-04-11 17:18:02, Manish Katiyar wrote:
> This patch fixes the following.
> 
> a) Incase journal transaction allocation fails due to ENOMEM don't call
> ext4_std_error() since it will remount the fs as readonly and logs the
> message in kernel log.
> b) Call posix_acl_release() incase journal allocation fails in case of
> error paths.
> 
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext4/acl.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index 21eacd7..0c98710 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -354,7 +354,6 @@ ext4_acl_chmod(struct inode *inode)
>  				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
>  		if (IS_ERR(handle)) {
>  			error = PTR_ERR(handle);
> -			ext4_std_error(inode->i_sb, error);
  The changelog speaks only about ENOMEM but you actually remove the
message completely (so it won't catch EIO or similar errors). I think you
should just condition ext4_std_error() with if (error != ENOMEM).

>  			goto out;
>  		}
>  		error = ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, clone);
> @@ -450,8 +449,10 @@ ext4_xattr_set_acl(struct dentry *dentry, const
> char *name, const void *value,
> 
>  retry:
>  	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
> -	if (IS_ERR(handle))
> -		return PTR_ERR(handle);
> +	if (IS_ERR(handle)) {
> +		error = PTR_ERR(handle);
> +		goto release_and_out;
> +	}
>  	error = ext4_set_acl(handle, inode, type, acl);
>  	ext4_journal_stop(handle);
>  	if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
