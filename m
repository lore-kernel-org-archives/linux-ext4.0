From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] ext4: preserve i_mode if __ext4_set_acl() fails
Date: Mon, 17 Jul 2017 17:33:39 +0200
Message-ID: <20170717153339.GI18199@quack2.suse.cz>
References: <cover.1499805484.git.ernesto.mnd.fernandez@gmail.com>
 <52152ec4b83fe0c406475bfee39efafaaa2a88fb.1499805486.git.ernesto.mnd.fernandez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46539 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751291AbdGQPds (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Jul 2017 11:33:48 -0400
Content-Disposition: inline
In-Reply-To: <52152ec4b83fe0c406475bfee39efafaaa2a88fb.1499805486.git.ernesto.mnd.fernandez@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 12-07-17 06:53:51, Ernesto A. Fernández wrote:
> When changing a file's acl mask, __ext4_set_acl() will first set the group
> bits of i_mode to the value of the mask, and only then set the actual
> extended attribute representing the new acl.
> 
> If the second part fails (due to lack of space, for example) and the file
> had no acl attribute to begin with, the system will from now on assume
> that the mask permission bits are actual group permission bits, potentially
> granting access to the wrong users.
> 
> Prevent this by only changing the inode mode after the acl has been set.
> 
> Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

This clashes with my fix of another bug in that area [1] but the fixup
should be straightforward. The patch looks good to me so feel free to add

Reviewed-by: Jan Kara <jack@suse.cz>

[1] https://www.spinics.net/lists/stable/msg178111.html

								Honza

> ---
>  fs/ext4/acl.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index 09441ae..2985cd0 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -189,16 +189,17 @@ __ext4_set_acl(handle_t *handle, struct inode *inode, int type,
>  	void *value = NULL;
>  	size_t size = 0;
>  	int error;
> +	int update_mode = 0;
> +	umode_t mode = inode->i_mode;
>  
>  	switch (type) {
>  	case ACL_TYPE_ACCESS:
>  		name_index = EXT4_XATTR_INDEX_POSIX_ACL_ACCESS;
>  		if (acl) {
> -			error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
> +			error = posix_acl_update_mode(inode, &mode, &acl);
>  			if (error)
>  				return error;
> -			inode->i_ctime = current_time(inode);
> -			ext4_mark_inode_dirty(handle, inode);
> +			update_mode = 1;
>  		}
>  		break;
>  
> @@ -221,8 +222,14 @@ __ext4_set_acl(handle_t *handle, struct inode *inode, int type,
>  				      value, size, xattr_flags);
>  
>  	kfree(value);
> -	if (!error)
> +	if (!error) {
>  		set_cached_acl(inode, type, acl);
> +		if (update_mode) {
> +			inode->i_mode = mode;
> +			inode->i_ctime = current_time(inode);
> +			ext4_mark_inode_dirty(handle, inode);
> +		}
> +	}
>  
>  	return error;
>  }
> -- 
> 2.1.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
