From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] ext4: don't allow encrypted operations without keys
Date: Thu, 5 Jan 2017 11:26:19 -0800
Message-ID: <20170105192619.GF21696@gmail.com>
References: <20161228034812.ikoat5x3e7ucnac7@thunk.org>
 <20161228052252.10314-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Filesystem Development List
        <linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org,
        richard@nod.at, ebiggers@google.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161228052252.10314-1-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On Wed, Dec 28, 2016 at 12:22:52AM -0500, Theodore Ts'o wrote:
> While we allow deletes without the key, the following should not be
> permitted:
> 
> # cd /vdc/encrypted-dir-without-key
> # ls -l
> total 4
> -rw-r--r-- 1 root root   0 Dec 27 22:35 6,LKNRJsp209FbXoSvJWzB
> -rw-r--r-- 1 root root 286 Dec 27 22:35 uRJ5vJh9gE7vcomYMqTAyD
> # mv uRJ5vJh9gE7vcomYMqTAyD  6,LKNRJsp209FbXoSvJWzB
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/ext4/namei.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index eadba919f26b..45a5ba558074 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3525,6 +3525,12 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  			EXT4_I(old_dentry->d_inode)->i_projid)))
>  		return -EXDEV;
>  
> +	if ((ext4_encrypted_inode(old_dir) &&
> +	     !fscrypt_has_encryption_key(old_dir)) ||
> +	    (ext4_encrypted_inode(new_dir) &&
> +	     !fscrypt_has_encryption_key(new_dir)))
> +		return -ENOKEY;
> +
>  	retval = dquot_initialize(old.dir);
>  	if (retval)
>  		return retval;
> @@ -3725,6 +3731,12 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	int retval;
>  	struct timespec ctime;
>  
> +	if ((ext4_encrypted_inode(old_dir) &&
> +	     !fscrypt_has_encryption_key(old_dir)) ||
> +	    (ext4_encrypted_inode(new_dir) &&
> +	     !fscrypt_has_encryption_key(new_dir)))
> +		return -ENOKEY;
> +
>  	if ((ext4_encrypted_inode(old_dir) ||
>  	     ext4_encrypted_inode(new_dir)) &&
>  	    (old_dir != new_dir) &&

I'm fine with this, with the understanding that it relies on ext4_lookup()
calling fscrypt_get_encryption_info() (via fscrypt_has_permitted_context()) when
looking up the directory.  I also suggest moving the fscrypt_permitted_context()
check in ext4_rename() up to be next to the new check, so that the fscrypt hooks
are grouped together and are consistent with ext4_cross_rename().

I can also write/update an xfstest to test this.

Something I'm thinking about is making things easier for filesystems by having
functions like "fscrypt_rename_hook()" which would handle all these needed
checks.  It would be easy to do with out-of-line functions in fs/crypto/, but we
don't want to be making ->is_encrypted() calls through the fscrypt_operations
all the time, when an inlined call to ext4_encrypted_inode() (or f2fs or
ubifs_encrypted_inode()) is much faster.  I think it could be implemented as
efficiently as now if the hooks were defined in a header and called a macro like
"fs_encrypted_inode()" which filesystems would have to #define first.  It would
be a little ugly, but at least it would be less error-prone than having multiple
filesystems replicate these increasingly complex checks.

Eric
