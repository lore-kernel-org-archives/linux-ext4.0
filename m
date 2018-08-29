From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] ext2: cache NULL when both default_acl and acl are
 NULL
Date: Wed, 29 Aug 2018 15:18:15 +0200
Message-ID: <20180829131815.GC7369@quack2.suse.cz>
References: <20180814141634.5471-1-cgxu519@gmx.com>
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
In-Reply-To: <20180814141634.5471-1-cgxu519@gmx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 14-08-18 22:16:30, Chengguang Xu wrote:
> default_acl and acl of newly created inode will be initiated
> as ACL_NOT_CACHED in vfs function inode_init_always() and later
> will be updated by calling xxx_init_acl() in specific filesystems.
> Howerver, when default_acl and acl are NULL then they keep the value
> of ACL_NOT_CACHED, this patch tries to cache NULL for acl/default_acl
> in this case.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
>  fs/ext2/acl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
> index 224c04abb2e5..74411e8ea507 100644
> --- a/fs/ext2/acl.c
> +++ b/fs/ext2/acl.c
> @@ -262,5 +262,8 @@ ext2_init_acl(struct inode *inode, struct inode *dir)
>  			error = __ext2_set_acl(inode, acl, ACL_TYPE_ACCESS);
>  		posix_acl_release(acl);
>  	}
> +	if (!default_acl && !acl)
> +		cache_no_acl(inode);
> +

Thanks for the patch. I'd somewhat prefer something equivalent to:

	if (!acl)
		inode->i_acl = NULL;
	if (!default_acl)
		inode->i_default_acl = NULL;

given the code in ext2_init_acl(). It would be most natural like:

	if (default_acl) {
		do foo
	} else {
		inode->i_default_acl = NULL;
	}

And similarly for 'acl'.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
