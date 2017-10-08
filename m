From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [FOR STABLE 4.1 -v2] ext4 crypto: don't regenerate the per-inode
 encryption key unnecessarily
Date: Sun, 8 Oct 2017 15:16:05 -0700
Message-ID: <20171008221605.GB1602@zzz.localdomain>
References: <20171008180953.rpnxvpggqggc334m@thunk.org>
 <20171008191749.GA26458@zzz.localdomain>
 <20171008203449.ys4sg5xztbzxx6ik@thunk.org>
 <20171008215530.hnty5a7v6dsip45e@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171008215530.hnty5a7v6dsip45e@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Oct 08, 2017 at 05:55:30PM -0400, Theodore Ts'o wrote:
> diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
> index 52170d0b7c40..4f9818719d61 100644
> --- a/fs/ext4/crypto_key.c
> +++ b/fs/ext4/crypto_key.c
> @@ -99,9 +99,17 @@ int ext4_generate_encryption_key(struct inode *inode)
>  	struct ext4_encryption_context ctx;
>  	struct user_key_payload *ukp;
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> -	int res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
> -				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> -				 &ctx, sizeof(ctx));
> +	int res;
> +
> +	mutex_lock(&ei->i_encryption_lock);
> +	if (ext4_has_encryption_key(inode)) {
> +		mutex_unlock(&ei->i_encryption_lock);
> +		return 0;
> +	}
> +
> +	res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
> +			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> +			     &ctx, sizeof(ctx));
>  
>  	if (res != sizeof(ctx)) {
>  		if (res > 0)
> @@ -154,6 +162,7 @@ out:
>  		key_put(keyring_key);
>  	if (res < 0)
>  		crypt_key->mode = EXT4_ENCRYPTION_MODE_INVALID;
> +	mutex_unlock(&ei->i_encryption_lock);
>  	return res;

This looks better, but maybe the call to ext4_has_encryption_key() should also
be removed from ext4_get_fname_crypto_ctx() --- so it calls
ext4_generate_encryption_key() unconditionally, like ext4_file_open() and
ext4_file_mmap() do?  Otherwise it will still be doing a racy check without the
lock.

Eric
