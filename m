From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [FOR STABLE 4.1] ext4 crypto: don't regenerate the per-inode
 encryption key unnecessarily
Date: Sun, 8 Oct 2017 12:17:49 -0700
Message-ID: <20171008191749.GA26458@zzz.localdomain>
References: <20171008180953.rpnxvpggqggc334m@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171008180953.rpnxvpggqggc334m@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On Sun, Oct 08, 2017 at 02:09:53PM -0400, Theodore Ts'o wrote:
> diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
> index 52170d0b7c40..c8c3bf0286be 100644
> --- a/fs/ext4/crypto_key.c
> +++ b/fs/ext4/crypto_key.c
> @@ -99,9 +99,14 @@ int ext4_generate_encryption_key(struct inode *inode)
>  	struct ext4_encryption_context ctx;
>  	struct user_key_payload *ukp;
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> -	int res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
> -				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> -				 &ctx, sizeof(ctx));
> +	int res;
> +
> +	if (ext4_has_encryption_key(inode))
> +		return 0;
> +
> +	res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
> +			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> +			     &ctx, sizeof(ctx));
>  
>  	if (res != sizeof(ctx)) {
>  		if (res > 0)

This is an improvement, but it's still broken because there is no locking.  If
two processes ->open() the same inode at the same time, one can observe
ext4_has_encryption_key() as true before the key has been fully initialized.  It
may be a good idea to add a really simple
DEFINE_MUTEX(ext4_key_generation_mutex), then do the ext4_has_encryption_key()
check and key generation under the mutex...

Eric
