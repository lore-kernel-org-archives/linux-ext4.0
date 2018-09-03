From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/5] ext4: cache NULL when both default_acl and acl
 are NULL
Date: Mon, 3 Sep 2018 10:57:50 +0200
Message-ID: <20180903085750.GD10027@quack2.suse.cz>
References: <20180831143352.22970-1-cgxu519@gmx.com>
 <20180831143352.22970-2-cgxu519@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
        jaegeuk@kernel.org, yuchao0@huawei.com, shaggy@kernel.org,
        hubcap@omnibond.com, martin@omnibond.com, devel@lists.orangefs.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        jfs-discussion@lists.sourceforge.net
To: Chengguang Xu <cgxu519@gmx.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180831143352.22970-2-cgxu519@gmx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 31-08-18 22:33:49, Chengguang Xu wrote:
> default_acl and acl of newly created inode will be initiated
> as ACL_NOT_CACHED in vfs function inode_init_always() and later
> will be updated by calling xxx_init_acl() in specific filesystems.
> Howerver, when default_acl and acl are NULL then they keep the value
  ^^^^ However

> of ACL_NOT_CACHED, this patch tries to cache NULL for acl/default_acl
> in this case.

I'd rephrase the above as: ... then they keep the value of ACL_NOT_CACHED.
This patch changes the code to cache NULL for acl / default_acl in this
case to save unnecessary ACL lookup attempt.

Otherwise the patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
> v1->v2:
> - Coding style change.
> 
>  fs/ext4/acl.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index fb50f9aa6ead..c1d570ee1d9f 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -284,12 +284,16 @@ ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
>  		error = __ext4_set_acl(handle, inode, ACL_TYPE_DEFAULT,
>  				       default_acl, XATTR_CREATE);
>  		posix_acl_release(default_acl);
> +	} else {
> +		inode->i_default_acl = NULL;
>  	}
>  	if (acl) {
>  		if (!error)
>  			error = __ext4_set_acl(handle, inode, ACL_TYPE_ACCESS,
>  					       acl, XATTR_CREATE);
>  		posix_acl_release(acl);
> +	} else {
> +		inode->i_acl = NULL;
>  	}
>  	return error;
>  }
> -- 
> 2.17.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
