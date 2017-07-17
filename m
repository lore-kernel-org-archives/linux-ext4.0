From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5] ext2: fix line over 80 characters in ext2_set_acl()
Date: Mon, 17 Jul 2017 18:33:28 +0200
Message-ID: <20170717163328.GC22195@quack2.suse.cz>
References: <cover.1499805484.git.ernesto.mnd.fernandez@gmail.com>
 <8c89043c298756b37fa74403b8b9d12fac9f8783.1499805487.git.ernesto.mnd.fernandez@gmail.com>
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
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8c89043c298756b37fa74403b8b9d12fac9f8783.1499805487.git.ernesto.mnd.fernandez@gmail.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 12-07-17 06:54:50, Ernesto A. Fernández wrote:
> Shorten the name of the error variable to 'err' so the call to
> posix_acl_update_mode() fits within 80 characters.
> 
> Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

This is no longer a problem. Patch ignored.

								Honza

> ---
>  fs/ext2/acl.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
> index 4e04b7e..d2cca5c 100644
> --- a/fs/ext2/acl.c
> +++ b/fs/ext2/acl.c
> @@ -184,7 +184,7 @@ ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  	int name_index;
>  	void *value = NULL;
>  	size_t size = 0;
> -	int error;
> +	int err;
>  	int update_mode = 0;
>  	umode_t mode = inode->i_mode;
>  
> @@ -192,9 +192,9 @@ ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		case ACL_TYPE_ACCESS:
>  			name_index = EXT2_XATTR_INDEX_POSIX_ACL_ACCESS;
>  			if (acl) {
> -				error = posix_acl_update_mode(inode, &mode, &acl);
> -				if (error)
> -					return error;
> +				err = posix_acl_update_mode(inode, &mode, &acl);
> +				if (err)
> +					return err;
>  				update_mode = 1;
>  			}
>  			break;
> @@ -214,10 +214,10 @@ ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  			return (int)PTR_ERR(value);
>  	}
>  
> -	error = ext2_xattr_set(inode, name_index, "", value, size, 0);
> +	err = ext2_xattr_set(inode, name_index, "", value, size, 0);
>  
>  	kfree(value);
> -	if (!error) {
> +	if (!err) {
>  		set_cached_acl(inode, type, acl);
>  		if (update_mode) {
>  			inode->i_mode = mode;
> @@ -225,7 +225,7 @@ ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  			mark_inode_dirty(inode);
>  		}
>  	}
> -	return error;
> +	return err;
>  }
>  
>  /*
> -- 
> 2.1.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
